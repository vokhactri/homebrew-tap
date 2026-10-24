class Netbird < Formula
  desc "Connect devices into a WireGuard-based overlay network"
  homepage "https://netbird.io/"
  license "BSD-3-Clause"

  if Hardware::CPU.arm?
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.4/netbird_0.81.4_darwin_arm64.tar.gz"
    sha256 "459782e6967bdcb3a59734a4da37c9f77d6e085b28039b0501039a1a7cbd0aae"
  else
    url "https://github.com/netbirdio/netbird/releases/download/v0.81.4/netbird_0.81.4_darwin_amd64.tar.gz"
    sha256 "a826aeb8fe328d153eb895a6185a00003a79b1d1040a0898f6bf49b694d92f39"
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
