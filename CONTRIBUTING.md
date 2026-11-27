# gtk.dart Contribution Guide

If you have a problem, please [file an issue](https://github.com/canonical/gtk.dart/issues/new).

If you have a solution, then we accept contributions via [pull requests](https://github.com/canonical/gtk.dart/pulls).
All contributions require the author(s) to sign the [contributor license agreement](http://www.ubuntu.com/legal/contributors/).

Thanks for your help!

## Releasing

Releases are automated with [release-please](https://github.com/googleapis/release-please)
and published to [pub.dev](https://pub.dev/packages/gtk) from GitHub Actions.

1. Use [Conventional Commits](https://www.conventionalcommits.org/) for pull
   request titles and commits (`feat:`, `fix:`, `chore:`, ...). Only `feat:`,
   `fix:`, `perf:` and `revert:` commits appear in the changelog, and `feat!:`
   or `BREAKING CHANGE:` marks a breaking change. If the repository allows
   squash merging, prefer it: release-please reads every commit on `main`, so a
   merge commit plus its branch commits can add the same change to the
   changelog twice.
2. After changes land on `main`, the `Release` workflow opens (and keeps
   updating) a `chore: release X.Y.Z` pull request that bumps the version in
   `pubspec.yaml` and updates `CHANGELOG.md`.
3. Merge that pull request to release. The workflow creates the `vX.Y.Z` tag and
   GitHub release, and then the `Publish` workflow publishes the package to
   pub.dev using OIDC (no secrets are involved).

Publishing can also be started manually by pushing a `vX.Y.Z` tag that matches
the version in `pubspec.yaml`. If the `Release` workflow creates the release but
fails to start the publish run, retry it with:

```console
gh workflow run publish.yml --ref vX.Y.Z
```

It is strongly recommended to protect `v*` tags with a repository ruleset so
that published tags cannot be updated, force-pushed, or deleted. Anyone who can
push a tag can trigger a publish, but `publish.yml` only publishes tags that
point at a commit on `main` and whose name matches the version in
`pubspec.yaml`.

### One-time repository setup

Before the first automated release, ensure the following settings exist:

- On [pub.dev](https://pub.dev/packages/gtk/admin), under **Automated
  publishing**, enable publishing from GitHub repository
  `canonical/gtk.dart` with tag pattern `v{{version}}`.
- In the GitHub repository settings, enable **Allow GitHub Actions to create
  and approve pull requests** (required by release-please).
- Optionally add a ruleset for `v*` tags that prevents updating or deleting
  published tags.
