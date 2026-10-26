class Netbird < Formula
  desc "Connect devices into a WireGuard-based overlay network"
  homepage "https://netbird.io/"
  license "BSD-3-Clause"

  if Hardware::CPU.arm?
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.5/netbird_0.81.5_darwin_arm64.tar.gz"
    sha256 "2b1d8fcc3ebd15d9b656b7274dada546780d9c6a55077489844b8a47a605764a"
  else
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.5/netbird_0.81.5_darwin_amd64.tar.gz"
    sha256 "302beac4ee0b0f1de8207bf0c02fa8da77449c260147836420b06804bb28db4d"
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
