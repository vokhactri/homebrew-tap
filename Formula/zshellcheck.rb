class Zshellcheck < Formula
  desc "Static analysis and auto-fix for Zsh scripts"
  homepage "https://github.com/afadesigns/zshellcheck"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/afadesigns/zshellcheck/releases/download/v1.8.0/zshellcheck_Darwin_arm64.tar.gz"
    sha256 "180879dc1fcd106dda667efa070af3829a38b736c23df1a6e7d9a527787d4038"
  else
    url "https://github.com/afadesigns/zshellcheck/releases/download/v1.8.0/zshellcheck_Darwin_x86_64.tar.gz"
    sha256 "d097a48e93b7a77f6e0ca3c72a4f6aef9c7330963117fe2b1f394f682a651f6e"
  end

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on :macos

  def install
    bin.install "zshellcheck"
    man1.install "man/man1/zshellcheck.1"
    bash_completion.install "completions/bash/zshellcheck-completion.bash" => "zshellcheck"
    zsh_completion.install "completions/zsh/_zshellcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zshellcheck --version")
    (testpath/"t.zsh").write "echo $x\n"
    assert_match "ZC1075", shell_output("#{bin}/zshellcheck t.zsh", 1)
  end
end
