class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.1/specdown-aarch64-apple-darwin"
      sha256 "4ebca13fa02d8daa1de15e67e34a49a3c293546d71b34049432fd5c343da21dc"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.1/specdown-x86_64-apple-darwin"
      sha256 "f0c56a832b97b460efbb91857d15ee563251a1e852f931fa2421ded750ca36cd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.1/specdown-x86_64-unknown-linux-gnu"
      sha256 "577181b5031e06cd48de043e499e08fd1177e859f504b9228b995558441e4e4d"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.1/specdown-aarch64-unknown-linux-gnu"
      sha256 "55b29e21b8151fa9154da3a0b0313695821adcfbdb93def43a7013e376e731a0"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.5.1/README.md"
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
