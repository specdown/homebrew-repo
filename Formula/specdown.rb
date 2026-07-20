class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.4/specdown-aarch64-apple-darwin"
      sha256 "3131212fc86f0079c46c12d101387f313fca9b6073e1d62ad6bb01bfc037008d"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.4/specdown-x86_64-apple-darwin"
      sha256 "96de10d7fcd5916fe52e08c8b867945c13aa51055ae01cfe013e47e2a5df52eb"
      version "1.9.4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.4/specdown-x86_64-unknown-linux-gnu"
      sha256 "70f9112f23da6f6fbc05547e3c8fdd431bbe7a07302175fa9a7e21ca8623ebca"
      version "1.9.4"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.4/specdown-aarch64-unknown-linux-gnu"
      sha256 "ff0f04b9a6340bf4762aba8e54b18bdd1bd74036fe16ffdc7541864ca4aacace"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.4/README.md"
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
