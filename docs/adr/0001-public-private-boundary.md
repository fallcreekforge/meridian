# 0001: Separate customer and cloud source

- Status: accepted
- Date: 2026-09-11

## Context

Platform credentials must remain in infrastructure controlled by the studio, while normalized data
may cross into Fall Creek Forge infrastructure.

## Decision

This repository contains only Meridian's open-source customer-controlled software. Proprietary
Meridian Cloud implementation remains outside it. The public sync protocol defines the trust
boundary.

## Consequences

Studios can inspect and self-build the credential-handling side. Protocol expansions require
security review, and cloud product logic cannot leak into this workspace.
