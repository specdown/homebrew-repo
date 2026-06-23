class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.7/specdown-aarch64-apple-darwin"
      sha256 "15c009aecd82da4ed09527e335fd8cea16999b53aeb95b771c0bc9007b58d082"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.7/specdown-x86_64-apple-darwin"
      sha256 "2422a4e056980753781e2e419f12623e81c97b31519742fceb73eeee3d1145bc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.7/specdown-x86_64-unknown-linux-gnu"
      sha256 "40f2e1ee2b2ca291c82b24f7d875d0ba4955b5098c857e34e8686f63ac9a83b4"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.7/specdown-aarch64-unknown-linux-gnu"
      sha256 "6d9c68e4a1ac15364dbb46a4bc294ff58113e919900415a7f4fc07b142ed85df"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.7/README.md"
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
