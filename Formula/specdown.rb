class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.0/specdown-aarch64-apple-darwin"
      sha256 "332413c2bd9ba610f638984b13e60576bd3400c80b9076de1c64b8536f64348d"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.0/specdown-x86_64-apple-darwin"
      sha256 "896c34f15f063dc47fce04d87fc39b9048ca571b479a8d2b7b17377b6ead52ac"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.5.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "18b357064f2b6264d9bfd68cf260dcc0cc457dbff3ed6e8faaca7710edb85555"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.5.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "cfd7892e413ae2dad9505287ce136a8a44bb415c3c059de89574b7371deffd01"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.5.0/README.md"
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
