class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.9.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a193676212b4d41be9c12e63ded54181c111b4051ae155ef369d270cdf089723"
    sha256 cellar: :any_skip_relocation, tahoe:        "6fd6ec75ce8ee528a1c6fd8bd5b969b80ca55c7faaf6eea330792fccc4731c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b1a07f0debed123f1c6947a2a39bd8214ba7f2f32a701900eda4a8b400d4f493"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cb522ef8c3de7412ee9463b5330d3fcca07822f6e10606d57a22570c104ed3c5"
  end

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
