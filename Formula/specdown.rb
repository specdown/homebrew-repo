class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/refs/tags/v1.2.95.tar.gz"
  sha256 "3f8d4ec5b1732b35399526ce01c16ff3e14168a0f2eb37baf3a3b2ab511c722d"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.95"
    sha256 cellar: :any_skip_relocation, ventura:      "968d85fd40e9df7acc0d13138d7976920fe7dfbb67bcb72f8bf1d3859b406120"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9a05d72ece8a5b9ecf15f603aa43f5e34ea4d93da299b869b643678c1fef7b6"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.95/README.md"
    sha256 "fa7dc4903d8d114032b7fcb424f2dd112d520063faa5df00b396b8726efc2589"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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
