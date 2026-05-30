class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.4/specdown-aarch64-apple-darwin"
      sha256 "dc14a3c6da459550a4b8d4a051bd810ad8de9820dfaa4c7672b13c9d33992df1"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.4/specdown-x86_64-apple-darwin"
      sha256 "2a016df5cf77ba197c4c3f1d09e0566c06af799ed35ba56910f8f4f43fdef931"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.4/specdown-x86_64-unknown-linux-gnu"
      sha256 "948561091042a4f425f8642ffd131d6ede048082c1c616abaaef4884e9d70000"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.4/specdown-aarch64-unknown-linux-gnu"
      sha256 "0a00ad26e0de8aa7fe196c351551fdd2a60caf4238b2bce8912f0267e7788b3f"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.4/README.md"
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
