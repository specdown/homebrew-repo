class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.5/specdown-aarch64-apple-darwin"
      sha256 "45f323398c8cd418096532cd86164207bc40dbe9d8cdb3e494b97c57ab4796a9"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.5/specdown-x86_64-apple-darwin"
      sha256 "4b8bf279509d4dfb14e3b507c82103f0a56e9ff603351aabfded718a1cdd1d57"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.5/specdown-x86_64-unknown-linux-gnu"
      sha256 "54bb6fcf24e9d1a1fcfc75653fd7852fd8f88fe228840ce06ccf4ece4c975e1f"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.5/specdown-aarch64-unknown-linux-gnu"
      sha256 "192fe0d1383e04200e1a660da93d80399e1b84e30a95585bffb0e35576eb3a65"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.5/README.md"
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
