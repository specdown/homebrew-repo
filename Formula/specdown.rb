class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  version "1.3.3"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.3/specdown-aarch64-apple-darwin"
      sha256 "bd6bfc3370a9c859c097921aa15d855988920b922d41373aee120542ed168a9a"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.3/specdown-x86_64-apple-darwin"
      sha256 "707a8fdc56159aaf1892592d2e7fee90e01560f8e318e0d3eae03188a7785158"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.3/specdown-x86_64-unknown-linux-gnu"
      sha256 "8c91a5e19d60379d6322002708b348942037a375e7232759e066fcebc58f2018"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.3/specdown-aarch64-unknown-linux-gnu"
      sha256 "c30c535b477743cac8400b8ff556d34f7b939deb45e70bc08cf6bd5e5f774b33"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.3/README.md"
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
