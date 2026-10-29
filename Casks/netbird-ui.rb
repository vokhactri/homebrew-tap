cask "netbird-ui" do
  arch arm: "arm64", intel: "amd64"

  version "0.82.0"
  sha256 arm:   "919cbb6abdfa90d52b19b9412581313f97daddd0129fac1a5c8a0c4a28d40c86",
         intel: "34cb2589672d46f969817dc9c9b886cd6ddda0c8083f18b4a4b3e1c2e48ae498"

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

  # Do what upstream's installer.sh does without running it. The script always
  # calls `netbird service stop` and `netbird service uninstall` and lets their
  # stderr through. On upgrade, uninstall_preflight_steps has already removed
  # the service, so both print launchctl errors even though nothing failed.
  postflight_steps do
    run "/usr/bin/osascript", args: ["-e", 'quit app "Netbird UI"'],
        sudo: true, must_succeed: false, print_stderr: false
    run "{{HOMEBREW_PREFIX}}/bin/netbird", args: ["service", "stop"],
        sudo: true, must_succeed: false, print_stderr: false
    run "{{HOMEBREW_PREFIX}}/bin/netbird", args: ["service", "uninstall"],
        sudo: true, must_succeed: false, print_stderr: false
    run "{{HOMEBREW_PREFIX}}/bin/netbird", args: ["service", "install"], sudo: true
    run "{{HOMEBREW_PREFIX}}/bin/netbird", args: ["service", "start"], sudo: true
    run "/usr/bin/open", args: ["{{appdir}}/Netbird UI.app"], sudo: true, must_succeed: false
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
