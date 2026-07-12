class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

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
