const warning_bytes = 16 * 1024
const maximum_bytes = 32 * 1024

def file-size [path: path] {
    ls --long $path | get size | first | into int
}

def relative-path [path: path, root: path] {
    $path | path relative-to $root
}

def is-within [path: path, directory: path] {
    ($path == $directory) or ($path | str starts-with $"($directory)/")
}

def is-excluded [path: path, root: path] {
    let git_directory = ($root | path join ".git")
    let target_directory = ($root | path join "target")
    (is-within $path $git_directory) or (is-within $path $target_directory)
}

def main [root: path = "."] {
    let repository = ($root | path expand)
    mut failures = []

    let instruction_candidates = (
        (glob --no-dir ($repository | path join "**/AGENTS.md"))
        | append (glob --no-dir ($repository | path join "**/AGENTS.override.md"))
        | where {|path| not (is-excluded $path $repository) }
    )

    let instruction_directories = (
        $instruction_candidates
        | each {|path| $path | path dirname }
        | uniq
        | sort
    )

    let active_instructions = (
        $instruction_directories
        | each {|directory|
            let override = ($directory | path join "AGENTS.override.md")
            let standard = ($directory | path join "AGENTS.md")

            if (($override | path exists) and (file-size $override) > 0) {
                $override
            } else if (($standard | path exists) and (file-size $standard) > 0) {
                $standard
            }
        }
        | compact
    )

    let root_instructions = (
        $active_instructions
        | where {|instruction| ($instruction | path dirname) == $repository }
    )
    if ($root_instructions | is-empty) {
        let message = "The repository root must contain non-empty agent instructions."
        $failures = $failures | append $message
    }

    print "Repository instruction chains:"
    for scope in $instruction_directories {
        let chain = (
            $active_instructions
            | where {|instruction|
                let instruction_directory = ($instruction | path dirname)
                let nested = ($scope | str starts-with $"($instruction_directory)/")
                ($scope == $instruction_directory) or $nested
            }
        )
        let bytes = ($chain | each {|instruction| file-size $instruction } | math sum)
        let scope_name = if $scope == $repository { "." } else { relative-path $scope $repository }
        let sources = (
            $chain
            | each {|instruction| relative-path $instruction $repository }
            | str join ", "
        )

        print $"  ($scope_name): ($bytes) bytes — ($sources)"

        if $bytes >= $maximum_bytes {
            let message = $"Instruction chain for ($scope_name) reaches the 32 KiB default ceiling."
            $failures = $failures | append $message
        } else if $bytes >= $warning_bytes {
            print $"  warning: ($scope_name) uses at least 16 KiB of repository instructions"
        }
    }

    if not ($root_instructions | is-empty) {
        let root_instruction = ($root_instructions | first)
        if not ((open --raw $root_instruction) | str contains "EXTERNAL-CONTEXT.md") {
            let message = "Root agent instructions must route work to EXTERNAL-CONTEXT.md."
            $failures = $failures | append $message
        }
    }

    let context_guide = ($repository | path join "EXTERNAL-CONTEXT.md")
    if not (($context_guide | path exists) and (file-size $context_guide) > 0) {
        let message = "The repository root must contain a non-empty EXTERNAL-CONTEXT.md."
        $failures = $failures | append $message
    }

    let symlinks = (
        glob ($repository | path join "**/*") --exclude [**/.git/** **/target/**]
        | where {|path|
            (not (is-excluded $path $repository)) and (($path | path type) == "symlink")
        }
    )

    let external_links = (
        $symlinks
        | each {|link|
            let target = (^readlink $link | str trim)
            let target_path = if ($target | str starts-with "/") {
                $target
            } else {
                $link | path dirname | path join $target
            }
            let resolved = (^realpath -m $target_path | str trim)

            if not ($resolved == $repository or ($resolved | str starts-with $"($repository)/")) {
                {
                    link: $link
                    target: $target
                    resolved: $resolved
                }
            }
        }
        | compact
    )

    print "External-context symlinks:"
    if ($external_links | is-empty) {
        print "  none configured"
    }

    for item in $external_links {
        let link_name = (relative-path $item.link $repository)
        let parent_name = ($link_name | path dirname)
        print $"  ($link_name) -> ($item.target)"

        if ($item.target | str starts-with "/") {
            $failures = $failures | append $"($link_name) must use a relative target."
        }

        if not ($item.link | path exists) {
            $failures = $failures | append $"($link_name) does not resolve to an existing target."
        }

        let ignored = (git -C $repository check-ignore -q -- $link_name | complete)
        if $ignored.exit_code != 0 {
            $failures = $failures | append $"($link_name) must be ignored by Git."
        }

        let parent_ignored = (git -C $repository check-ignore -q -- $parent_name | complete)
        if $parent_ignored.exit_code == 0 {
            let message = $"($parent_name) is ignored; ignore its external link instead."
            $failures = $failures | append $message
        }
    }

    if not ($failures | is-empty) {
        print ""
        print "Agent context audit failed:"
        for failure in $failures {
            print $"  - ($failure)"
        }
        exit 1
    }

    print "Agent context audit passed."
}
