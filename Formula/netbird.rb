class Netbird < Formula
  desc "Connect devices into a WireGuard-based overlay network"
  homepage "https://netbird.io/"
  license "BSD-3-Clause"

  if Hardware::CPU.arm?
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.3/netbird_0.81.3_darwin_arm64.tar.gz"
    sha256 "bc37108ee88cbc0a998031231570a2c62f03c0937867a0114b8d137e7840fe71"
  else
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.3/netbird_0.81.3_darwin_amd64.tar.gz"
    sha256 "95ef6a3f3c56d7d7d96e66fdf2523a6ee8c719b8beb959e9f15c6a101e4cac1f"
  end

  livecheck do
    url "https://github.com/netbirdio/netbird"
    strategy :github_latest
  end

  depends_on :macos

  def install
    bin.install "netbird"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netbird version")
  end
end
