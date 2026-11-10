# vokhactri/homebrew-tap

This tap moved to https://git.trivk.dev/tri/homebrew-tap. The copy here is archived and gets no
more version bumps, so a tap that still points at GitHub stays on old versions.

Point an existing tap at the new home:

```sh
brew tap --custom-remote vokhactri/tap https://git.trivk.dev/tri/homebrew-tap.git
brew trust vokhactri/tap
```

Or tap it fresh:

```sh
brew tap vokhactri/tap https://git.trivk.dev/tri/homebrew-tap.git
brew trust vokhactri/tap
```
