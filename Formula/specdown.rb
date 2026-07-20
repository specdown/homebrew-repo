class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.5/specdown-aarch64-apple-darwin"
      sha256 "a353a2e92825167fefb8bf06c824cf62c9eaa13c1725467e8b5bd152477b5236"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.5/specdown-x86_64-apple-darwin"
      sha256 "c6b6e85e088683774a14703fcc8d9ea7124b5256f0d462ceaa620327fd369fbd"
      version "1.9.5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.5/specdown-x86_64-unknown-linux-gnu"
      sha256 "31483d5d2c09a0f19e8d01b01857850e3ad7588452fc00d1a1a1f0ef31090488"
      version "1.9.5"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.5/specdown-aarch64-unknown-linux-gnu"
      sha256 "3c98b051d0d86dc37f8ff911a07708e5fa7759c582428937f9f5e09c34c7cbfc"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.5/README.md"
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
