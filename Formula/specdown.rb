class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.4.0/specdown-aarch64-apple-darwin"
      sha256 "49a5aae771130180c10de9ad99d792e7120805556a2fc14e571453baa0b8251e"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.4.0/specdown-x86_64-apple-darwin"
      sha256 "0c45fde54de99c7758a4e86340c94374232586181dc97bfb270aca7aaa99b187"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.4.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "757c6b27d775096a03e82e88476a7ffa4a292528ad797214019681c101da3c03"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.4.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "771a60098afd6add986beb33239313fd8b25dd6b893ceff79450b72acbaccaca"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.4.0/README.md"
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
