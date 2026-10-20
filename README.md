# vokhactri/homebrew-tap

My personal Homebrew tap for macOS.

| Package | Type | Description |
| --- | --- | --- |
| [`netbird`](https://github.com/netbirdio/netbird) | formula | NetBird CLI and daemon |
| [`netbird-ui`](https://github.com/netbirdio/netbird) | cask | NetBird menu bar app |
| [`zshellcheck`](https://github.com/afadesigns/zshellcheck) | formula | Linter for Zsh scripts |

## Install

```sh
brew tap vokhactri/tap
brew trust vokhactri/tap
brew install vokhactri/tap/<name>
```

Use `brew install --cask` for casks.

## Updates

A GitHub Action checks for new upstream releases every two hours and commits the new version
and sha256 values. If a release doesn't have its macOS files yet, the Action tries again on the
next run.
