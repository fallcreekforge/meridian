# meridian-credential-store

Defines credential access within studio-controlled infrastructure.

`CredentialStore` retrieves named credentials without assuming a platform or backend. `SecretString`
redacts its `Debug` output and requires explicit access to the underlying value. No storage backend
is implemented yet.
