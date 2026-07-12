class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7b5c7db442de27cc45ce8ed82ae07149fecbdd069630c49c380d5c7ad9697105"
    sha256 cellar: :any_skip_relocation, tahoe:        "66c5fbe4be31818bd52eb4a829527b25f6537e7ba62adddb6c94d93775971d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "19db3fa277021aa674485706093166a3070147929f28225445b8065f568c90c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d101c58a612e37da644d685d7f25da3ed64ec35853bb5f1b002af2fc2fb52d07"
  end

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.8.0/specdown-aarch64-apple-darwin"
      sha256 "6c354aa8fef2df8236f6dd516618d8847400c53042ca4d3b15ca0565a3a8c509"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.8.0/specdown-x86_64-apple-darwin"
      sha256 "bdde80077ad62a69a3c50d63321aacded4509f66f7f4257f22c9478cd177bcf8"
      version "1.8.0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.8.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "d28dc006fe915ac612720b88b873ac67c18e79635e66cb228a41c5384fbaf21a"
      version "1.8.0"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.8.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "53cef7c5778c86204918cf40f8e64d788aa703304324e8deedf9e61d97bfa530"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.8.0/README.md"
    sha256 "b4a0f54551331989fc3f4776188dfcbb901da2e2ff511cd801ba6d30fb662e8c"
  end

  def install
    binary = if OS.mac?
      Hardware::CPU.arm? ? "specdown-aarch64-apple-darwin" : "specdown-x86_64-apple-darwin"
    else
      Hardware::CPU.arm? ? "specdown-aarch64-unknown-linux-gnu" : "specdown-x86_64-unknown-linux-gnu"
    end

    chmod 0755, binary
    bin.install binary => "specdown"

    generate_completions_from_executable(bin/"specdown", "completion")
  end

  test do
    system bin/"specdown", "-h"
    system bin/"specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
