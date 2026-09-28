class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.14/specdown-aarch64-apple-darwin"
      sha256 "9541ab3e31043c3185c4d99d3fd5bdd3f55574d91b913d796fc95c5f6f284bb6"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.14/specdown-x86_64-apple-darwin"
      sha256 "b355e50642749aa8b911a0f8b617fb695092cf7627bb450cb3a213a77d393f17"
      version "1.9.14"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.14/specdown-x86_64-unknown-linux-gnu"
      sha256 "fc6dc08fd920099e7c9471b180bef8d8f433345393299cd7b58bf2a93fb723b6"
      version "1.9.14"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.14/specdown-aarch64-unknown-linux-gnu"
      sha256 "673f38f7c9185e99685124baabf21eeea2de903c8fefb1a5be3c7b6feb534d4a"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.14/README.md"
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
