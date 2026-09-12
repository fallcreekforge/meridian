# meridian-sync-protocol

Defines the versioned data allowed to cross from a studio environment into Meridian Cloud.

Version 1 currently contains a studio identifier and explicit game records. Unknown fields are
rejected, and the protocol has no credential type or arbitrary value container. Changes to this
crate expand the security boundary and require review.
