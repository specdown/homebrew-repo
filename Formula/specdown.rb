class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7ec60a6042a69065896bda7cf962eaf236d469f19ec9e4c32cabb8e5afb31db6"
    sha256 cellar: :any_skip_relocation, tahoe:        "ab8d38c47273f4874f3e6e0206d5565e9ed17bf36c72f5721ca2ebd60109547c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "edf60f51dacfda61fa576cd4a5e562e1392ae7977d59400eb912343091171c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "990ccede26ba0f46ff13ae09b5c44281fdf6826d7b9f8f301500476e1b5d031d"
  end

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.0/specdown-aarch64-apple-darwin"
      sha256 "1fac25b50fb389a72ba0a060e27724ed790feb8d1f68f61198e88c5eb63b613f"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.0/specdown-x86_64-apple-darwin"
      sha256 "48ef18f8e920482ddee7ee0bf62f8e0a87f942b79ad5d40d984409ac28636866"
      version "1.9.0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "65e1141a8ee6be6279db26ea2c452d90fc805a5944f7658e3f34c33534ee76fc"
      version "1.9.0"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "979ddd113c90df4bc10db27dca76ffb0cf43adb4af5ddfb6ea730e484cbb25be"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.0/README.md"
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
