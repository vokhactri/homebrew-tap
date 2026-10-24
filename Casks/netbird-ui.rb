cask "netbird-ui" do
  arch arm: "arm64", intel: "amd64"

  version "0.81.4"
  sha256 arm:   "3dc73abf12967f15f82f4c380252af5ae573b06b605dc00f30a0c293eaace55b",
         intel: "002a1c941e85eaa20ec16b248d4ec57c589d4b8ae9b8b820262bfb8583d1a199"

  url "https://github.com/netbirdio/netbird/releases/download/v#{version}/netbird-ui_#{version}_darwin_#{arch}_signed.zip"
  name "Netbird UI"
  desc "Desktop client for the NetBird overlay network"
  homepage "https://www.netbird.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "vokhactri/tap/netbird"
  depends_on :macos

  app "netbird_ui_darwin", target: "Netbird UI.app"

  # The release zip ships installer.sh as 0644. Upstream chmods it inside the
  # signed bundle, which can fail with "Operation not permitted". Running it
  # through /bin/sh needs no chmod.
  postflight_steps do
    run "/bin/sh", args: ["{{appdir}}/Netbird UI.app/installer.sh", version], sudo: true
  end

  # bootout returns before launchd has removed system/netbird. On upgrade the
  # new installer.sh then fails to load the service and the daemon stays down,
  # so wait for the old service to go away first.
  uninstall_preflight_steps do
    run "/bin/launchctl", args: ["bootout", "system/netbird"],
        sudo: true, must_succeed: false, print_stderr: false
    run "/bin/sh",
        args:         ["-c", "i=0; while /bin/launchctl print system/netbird >/dev/null 2>&1 && [ $i -lt 30 ]; " \
                             "do sleep 0.5; i=$((i + 1)); done"],
        sudo:         true,
        must_succeed: false
    run "/bin/launchctl", args: ["unload", "/Library/LaunchDaemons/netbird.plist"],
        sudo: true, must_succeed: false, print_stderr: false
    remove "/Library/LaunchDaemons/netbird.plist", sudo: true
  end
end
