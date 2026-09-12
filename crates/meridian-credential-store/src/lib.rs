//! Credential storage for studio-controlled environments.
//!
//! Implementations must not log secret values or include them in errors.

use std::fmt;

use thiserror::Error;

/// Identifies a credential without exposing its value.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct CredentialKey(String);

impl CredentialKey {
   #[must_use]
   pub fn new(value: impl Into<String>) -> Self {
      Self(value.into())
   }

   #[must_use]
   pub fn as_str(&self) -> &str {
      &self.0
   }
}

/// An owned secret whose ordinary debug representation is always redacted.
#[derive(Clone, Eq, PartialEq)]
pub struct SecretString(String);

impl SecretString {
   #[must_use]
   pub fn new(value: impl Into<String>) -> Self {
      Self(value.into())
   }

   /// Explicitly exposes the secret to code that must authenticate locally.
   #[must_use]
   pub fn expose_secret(&self) -> &str {
      &self.0
   }
}

impl fmt::Debug for SecretString {
   fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
      formatter.write_str("SecretString([REDACTED])")
   }
}

#[derive(Debug, Error)]
pub enum CredentialStoreError {
   #[error("credential is not configured")]
   NotFound,
}

/// Retrieves credentials held inside studio-controlled infrastructure.
pub trait CredentialStore {
   fn get(&self, key: &CredentialKey) -> Result<SecretString, CredentialStoreError>;
}

#[cfg(test)]
mod tests {
   use super::SecretString;

   #[test]
   fn debug_output_redacts_secret() {
      let secret = SecretString::new("test-secret");
      let output = format!("{secret:?}");

      assert_eq!(output, "SecretString([REDACTED])");
      assert!(!output.contains(secret.expose_secret()));
   }
}
