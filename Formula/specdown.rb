class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.9/specdown-aarch64-apple-darwin"
      sha256 "c15bb94d985d93488db4cf746df04b155674040b4edfe3f8db1273e9caee9fd4"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.9/specdown-x86_64-apple-darwin"
      sha256 "282f1ff0116f6e590e2864851a49d6030149b96788f90a0f7e63254200dc9b8b"
      version "1.9.9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.9/specdown-x86_64-unknown-linux-gnu"
      sha256 "50ef77d3834fa7f9fd3a8d56e828ed7ce6743295a0fe7c65636c61002d2a9937"
      version "1.9.9"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.9/specdown-aarch64-unknown-linux-gnu"
      sha256 "6ae2eb0e121708a46efdc006229bf97420eb31cecc3a3d9d669638088723a73c"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.9/README.md"
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
