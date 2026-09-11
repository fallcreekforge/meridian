//! Meridian is a Rust workspace built with the nightly toolchain.

/// Returns the name of this project.
#[must_use]
pub fn name() -> &'static str {
   "meridian"
}

#[cfg(test)]
mod tests {
   use super::name;

   #[test]
   fn exposes_its_name() {
      assert_eq!(name(), "meridian");
   }
}
