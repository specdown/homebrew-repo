class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.2/specdown-aarch64-apple-darwin"
      sha256 "830d479328e0343c66552d862b9e5093016837ba985c50618858d2a5389e7bc1"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.2/specdown-x86_64-apple-darwin"
      sha256 "f5901be1b50bd1a8a08c37569265eff39d5c5550ff47f92264f45d7190225074"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.2/specdown-x86_64-unknown-linux-gnu"
      sha256 "cf1ceba430f29bcaeb4e936f49b312a6140a5f04e656f34cbb38e96c31f40d3c"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.2/specdown-aarch64-unknown-linux-gnu"
      sha256 "7e5185bb9118857b00bc46d43be7034f36406832692a200a015c6daae3eecb3d"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.5.2/README.md"
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
