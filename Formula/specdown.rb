class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/refs/tags/v1.2.97.tar.gz"
  sha256 "a62d0728aaf166c3f4c17a8abd34401c37c53c8c379f3b547a2956d214de31c4"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.97"
    sha256 cellar: :any_skip_relocation, ventura:      "d5d66fb075a70e19573d53642cb2caa5f2d6fb8e1f50f979b02f02c4b06babd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f54a101180a0d01e92e64e9a263f4e61c1f0ffa6863077744d6395b3592846d"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.97/README.md"
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
