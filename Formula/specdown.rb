class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/refs/tags/v1.2.116.tar.gz"
  sha256 "a720240c5177ace40b35a088097ea8deeaca66d9042cc3c0af1e1143da4b4188"

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.116/README.md"
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
