class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.0/specdown-aarch64-apple-darwin"
      sha256 "83d5a0b63b5cf2a8eb12d715b68ff0d4f3b35e1c905d4223d301d984710739e4"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.0/specdown-x86_64-apple-darwin"
      sha256 "663cfc73ab3051ddf86214041d189abf72407a21788419303802c6e126826664"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "03d40ba639f070801caf0c2a8684d072b3da83372090a55fafd36b3212a91630"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "93e9bd319ebbd38dd82f27fe645acefc8dc8413a770e4d1f73caceea320c90f6"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.6.0/README.md"
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
