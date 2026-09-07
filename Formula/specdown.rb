class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.11/specdown-aarch64-apple-darwin"
      sha256 "8ad91e9ac7900a04ad7f488db065d4fc73bafdb7532eb0d652cd6248ee8aa93f"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.11/specdown-x86_64-apple-darwin"
      sha256 "e06f18f29346559c08bd3c09361a9a6161047bdf381b1647dc7902051dbd4207"
      version "1.9.11"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.11/specdown-x86_64-unknown-linux-gnu"
      sha256 "6a374ebcf0cd4522e41fe87dc1d95443e9225e1c01293f17ba130cc0cdc0f061"
      version "1.9.11"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.11/specdown-aarch64-unknown-linux-gnu"
      sha256 "380d68a8c4942b5fcbcd71fa1e5ce5cee6e7b199c7c6b9e5aa68e63c8e695fde"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.11/README.md"
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
