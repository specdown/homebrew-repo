class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.3/specdown-aarch64-apple-darwin"
      sha256 "56438bc3211fe0696a21a371438e965df557ed7071bd19c1cb4c51479306b6b0"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.3/specdown-x86_64-apple-darwin"
      sha256 "cc84d28697b8aef760fe0385b016c6ef5df44f86c703440aa3ccf4963bc3b8f8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.3/specdown-x86_64-unknown-linux-gnu"
      sha256 "f5d08d0d1681c5b771208842e023f777daad259b91b5d9e7b3776ed9ec6d5c87"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.3/specdown-aarch64-unknown-linux-gnu"
      sha256 "a8100fd2893806c2e265c7de5d09425ca10b1ac527955e7153f48c96bf853bd2"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.5.3/README.md"
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
