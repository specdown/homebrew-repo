class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.8/specdown-aarch64-apple-darwin"
      sha256 "36e49196067ec1f3ba4a7f8c367633aaf3036cdb3f6f41fefc86274eb58d9b1b"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.8/specdown-x86_64-apple-darwin"
      sha256 "3c1199fe60554357ff5b053d585fc55b09550a78b2e3dde871e9b9538c6fa7b7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.8/specdown-x86_64-unknown-linux-gnu"
      sha256 "875806f48958640434d2d2ba7df78e24ca79213f3a8ed750c25246671878f363"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.8/specdown-aarch64-unknown-linux-gnu"
      sha256 "4224bd1fec9ad1dce04358c71cc418b917c8498dd0a340d4d5df7d1316217ee6"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.8/README.md"
    sha256 "b4a0f54551331989fc3f4776188dfcbb901da2e2ff511cd801ba6d30fb662e8c"
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "specdown-aarch64-apple-darwin" => "specdown"
      elsif Hardware::CPU.intel?
        bin.install "specdown-x86_64-apple-darwin" => "specdown"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        bin.install "specdown-x86_64-unknown-linux-gnu" => "specdown"
      elsif Hardware::CPU.arm?
        bin.install "specdown-aarch64-unknown-linux-gnu" => "specdown"
      end
    end

    generate_completions_from_executable(bin/"specdown", "completion", shells: [
      :bash,
      :fish,
      :zsh,
    ])

    # Man pages
    output = Utils.safe_popen_read("help2man", "#{bin}/specdown")
    (man1/"specdown.1").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
