#!/usr/bin/env bash
# Updates Formula/zshellcheck.rb to the latest zshellcheck release.
# On a new version it writes "$BUMP_DIR/zshellcheck": the commit message, then the changed files.
set -euo pipefail
formula=Formula/zshellcheck.rb
repo=afadesigns/zshellcheck
latest=$(gh api repos/$repo/releases/latest --jq .tag_name)
latest=${latest#v}
current=$(sed -nE 's|.*/releases/download/v([^/]+)/.*|\1|p' "$formula" | head -1)
if [ "$latest" = "$current" ]; then
  echo "Already at $current"
  exit 0
fi

# The release publishes checksums.txt with a sha256 for every asset.
if ! checksums=$(curl -fsSL "https://github.com/$repo/releases/download/v$latest/checksums.txt"); then
  echo "checksums.txt is not published yet"
  exit 0
fi
declare -A sha
for asset in zshellcheck_Darwin_{arm64,x86_64}.tar.gz; do
  sha[$asset]=$(awk -v a="$asset" '$2 == a { print $1 }' <<<"$checksums")
  if [ -z "${sha[$asset]}" ]; then
    echo "$asset is not published yet"
    exit 0
  fi
done

sed -i -E "s|/v${current//./\\.}/|/v$latest/|g" "$formula"
for asset in "${!sha[@]}"; do
  sed -i -E "/\/${asset//./\\.}\"/{n;s/[0-9a-f]{64}/${sha[$asset]}/}" "$formula"
done
echo "chore: bump zshellcheck to $latest" > "$BUMP_DIR/zshellcheck"
echo "$formula" >> "$BUMP_DIR/zshellcheck"
