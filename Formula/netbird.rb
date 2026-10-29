class Netbird < Formula
  desc "Connect devices into a WireGuard-based overlay network"
  homepage "https://netbird.io/"
  license "BSD-3-Clause"

  if Hardware::CPU.arm?
    url "https://github.com/netbirdio/netbird/releases/download/v0.82.0/netbird_0.82.0_darwin_arm64.tar.gz"
    sha256 "a46b84c962ac1f47a822d91cb2480bb892f01ee5d74fd2504b6106ceac5f0f87"
  else
    url "https://github.com/netbirdio/netbird/releases/download/v0.82.0/netbird_0.82.0_darwin_amd64.tar.gz"
    sha256 "ee8aadb88419d65af1fd7c68b718f792ce51e912491e13f548b1cf6dc60a11e6"
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
