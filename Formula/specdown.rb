class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.9.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "10e08acd67c9bdbd8d34c5c7e7c58e86e3d253fbaea229f8a098d0bea61e233e"
    sha256 cellar: :any_skip_relocation, tahoe:        "1cbdab75ff02969c8cd52065660ee8e2d4e3dcefaa3ade594477c5c53609aed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0749451d6a87bfe16aed893cf4a4a5f5b6ab1441ad18724d079d579357988cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4399b3cc65ccfe97aa59470df49ac2989757bb1c54e1051f9919842d429b19af"
  end

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.3/specdown-aarch64-apple-darwin"
      sha256 "c6c51f5bddcfa77f15e19a6b90b9afdad2b8627a83b4a4e77bf35b835f8146d9"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.3/specdown-x86_64-apple-darwin"
      sha256 "dbb177960a88a98fb5009cba9a3c46500552ead27dc915eb4312bdcab113cbef"
      version "1.9.3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.3/specdown-x86_64-unknown-linux-gnu"
      sha256 "2b8dfdc2d950ae9bcc89f174a8ebe812439c116b7f36984c9066c7d39fa512db"
      version "1.9.3"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.3/specdown-aarch64-unknown-linux-gnu"
      sha256 "5d5a09aa2ecbf1c5734160b95445bd4ef0ec494cc5d95bd55b265f29578da65c"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.3/README.md"
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
