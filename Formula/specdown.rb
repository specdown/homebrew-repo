class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.8/specdown-aarch64-apple-darwin"
      sha256 "67820e00261d233b22cc93890fbf17c1d0df953e49ef9451d1e571bd5aa18012"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.8/specdown-x86_64-apple-darwin"
      sha256 "a105679080127fb996968a27ba1c10e55420fdf310cb0a89fcc12840e79f732a"
      version "1.9.8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.8/specdown-x86_64-unknown-linux-gnu"
      sha256 "533a96ebf632c0c4d5dfde3c5204229c9364feb9ad676301af8fdeda47d32f89"
      version "1.9.8"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.8/specdown-aarch64-unknown-linux-gnu"
      sha256 "070d473ce7fbf49e0e890398a55a1a2384d1e847381e257becbd7a8261763a12"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.8/README.md"
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
