#!/usr/bin/env bash
# Updates Casks/netbird-ui.rb and Formula/netbird.rb to the latest NetBird release.
# On a new version it writes "$BUMP_DIR/netbird": the commit message, then the changed files.
set -euo pipefail
cask=Casks/netbird-ui.rb
formula=Formula/netbird.rb
latest=$(gh api repos/netbirdio/netbird/releases/latest --jq .tag_name)
latest=${latest#v}
current=$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$cask")
if [ "$latest" = "$current" ]; then
  echo "Already at $current"
  exit 0
fi

base="https://github.com/netbirdio/netbird/releases/download/v$latest"
declare -A sha
tmp=$(mktemp)
for asset in netbird-ui_${latest}_darwin_{arm64,amd64}_signed.zip netbird_${latest}_darwin_{arm64,amd64}.tar.gz; do
  # Release assets can show up a while after the tag. Try again on the next run.
  if ! curl -fsSL -o "$tmp" "$base/$asset"; then
    echo "$asset is not published yet"
    exit 0
  fi
  sha[$asset]=$(sha256sum "$tmp" | cut -d' ' -f1)
done
rm -f "$tmp"

sed -i -E \
  -e "s/^  version \"[^\"]+\"$/  version \"$latest\"/" \
  -e "s/(arm: +\")[0-9a-f]{64}/\1${sha[netbird-ui_${latest}_darwin_arm64_signed.zip]}/" \
  -e "s/(intel: \")[0-9a-f]{64}/\1${sha[netbird-ui_${latest}_darwin_amd64_signed.zip]}/" \
  "$cask"

# The formula has literal URLs, each followed by its sha256 line.
sed -i -E "s/${current//./\\.}/$latest/g" "$formula"
for arch in arm64 amd64; do
  asset="netbird_${latest}_darwin_${arch}.tar.gz"
  sed -i -E "/\/${asset//./\\.}\"/{n;s/[0-9a-f]{64}/${sha[$asset]}/}" "$formula"
done
echo "chore: bump netbird to $latest" > "$BUMP_DIR/netbird"
printf '%s\n' "$cask" "$formula" >> "$BUMP_DIR/netbird"
