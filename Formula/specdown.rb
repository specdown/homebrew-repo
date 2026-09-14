class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.13/specdown-aarch64-apple-darwin"
      sha256 "3e69c7b24aefd0f8b3aad979a82cd39bc22c5e81856db06530073fabb02fc146"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.13/specdown-x86_64-apple-darwin"
      sha256 "1de4202c5314ad8b3b52262be210cda5f0e30e6e2de0b4a76997114c28a01184"
      version "1.9.13"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.13/specdown-x86_64-unknown-linux-gnu"
      sha256 "41743763f10b4a63c47d8cbe9ad7144d6aa962881780770335622add1705e33d"
      version "1.9.13"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.13/specdown-aarch64-unknown-linux-gnu"
      sha256 "ea196814562ba96d5ecd27c9ac4d9e82d1a7bc97354ff1a8edc2d57d1f242305"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.13/README.md"
    sha256 "2b19ae63dd39b0ddd5385822b8e4783509fe5ff465eace3501094058c130019f"
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
