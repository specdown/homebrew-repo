class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.7/specdown-aarch64-apple-darwin"
      sha256 "5efffd7abeeac09f329c7ec39377bf34bd9a550ec29f5ce5c08dc858cf407a9d"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.7/specdown-x86_64-apple-darwin"
      sha256 "59e0209fec49a1a2dd4899f581cc4321192d870ae178b9777685c78e244e89f0"
      version "1.9.7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.7/specdown-x86_64-unknown-linux-gnu"
      sha256 "fcd5a37205f04d8cdd7ef85d859fe950b3af0db7143d0adc811afde6919350ef"
      version "1.9.7"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.7/specdown-aarch64-unknown-linux-gnu"
      sha256 "f9eda91776755d0c27753676a68a7a2cb4f1efa27fe3b1ac6e37f9e9bcf8e11d"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.7/README.md"
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
