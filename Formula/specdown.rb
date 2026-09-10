class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.12/specdown-aarch64-apple-darwin"
      sha256 "7d8750fd7c5a137d3b491966d15933e18165bd8ea9f5773c87d94150d74a79c1"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.12/specdown-x86_64-apple-darwin"
      sha256 "b6974ff2b3051845c133171bf34d79c782b3b08ddcb8cda9baf72360716cb1ee"
      version "1.9.12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.12/specdown-x86_64-unknown-linux-gnu"
      sha256 "921456234d59c02790d7296c29dde569e8bfe02ce88836ec838648b17f8f2027"
      version "1.9.12"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.12/specdown-aarch64-unknown-linux-gnu"
      sha256 "c30f9227d20da5188f229964fa348501ce4015a24c00cb8bf7e35c607603cdad"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.12/README.md"
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
