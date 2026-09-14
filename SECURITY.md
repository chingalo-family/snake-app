# Security Policy

## Supported versions

We accept vulnerability reports for the version currently published on the `main` branch of [chingalo-family/snake-app](https://github.com/chingalo-family/snake-app) (see `version:` in `pubspec.yaml`).

Older GitHub Release tags may not receive backports.

## Reporting a vulnerability

**Do not** open a public GitHub issue or pull request for a security problem.

Email **[chingalo.family@gmail.com](mailto:chingalo.family@gmail.com)** with:

- A description of the issue and its impact
- Steps to reproduce, or a proof of concept if you have one
- Affected platform(s) (Android, iOS, Linux, macOS, Windows, Web) and app version / build number if known

You may also use [GitHub private vulnerability reporting](https://github.com/chingalo-family/snake-app/security/advisories/new) if it is enabled on the repository.

We will acknowledge the report when we can and follow up with next steps. Please give us a reasonable window to investigate before any public disclosure.

## Scope notes

Snake App is designed to be **offline-first**. Core play, scores, and the optional local profile are stored on the device (SQLite / SharedPreferences). There is no application server in this repository.

Reports that are especially useful include:

- Unexpected access to or leakage of on-device profile data
- Insecure handling of store / update deep links
- Dependency issues in Flutter plugins used by this app
