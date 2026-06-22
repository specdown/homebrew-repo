class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  depends_on "help2man" => :build

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.6/specdown-aarch64-apple-darwin"
      sha256 "6e9abc0798fecee78224079ba15c88167d9460951025d569b9bba129a4fc78fb"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.6/specdown-x86_64-apple-darwin"
      sha256 "4d8c058a246fc03a88c3cf667bfe9509c7c38456b09d288612204e6ffe870bef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.6/specdown-x86_64-unknown-linux-gnu"
      sha256 "01ad9f97bc65efc6994ebace49af9e51d2656b620857b9f842e3bd95898860fc"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.6/specdown-aarch64-unknown-linux-gnu"
      sha256 "955501ec34daa041e69322d4af69d16c1afaf19c23b692f4b2bbc43f279cdd9c"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.6/README.md"
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
