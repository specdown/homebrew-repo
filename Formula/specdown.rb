class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.10/specdown-aarch64-apple-darwin"
      sha256 "34d4ad572bf44c463c934e502d70e398b69d41d148b18dc27417287935d07605"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.10/specdown-x86_64-apple-darwin"
      sha256 "b09578ddc3e66e67f6a022ea5e44a76051b5a93f9665a6a8fb2a2c27c865e73e"
      version "1.9.10"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.10/specdown-x86_64-unknown-linux-gnu"
      sha256 "ece6107fcb1fb7606a41ae24cfb6816e7630d8a8ed11993efc5e1649d61a74ec"
      version "1.9.10"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.10/specdown-aarch64-unknown-linux-gnu"
      sha256 "7bf18d3d87f820fbf859e5f8bd5d17fee5284f9556e165affaa6a548369be2d9"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.10/README.md"
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
