class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/refs/tags/v1.2.94.tar.gz"
  sha256 "77c43d13a3a37c9cad560af9a1db91860fe6608c6612b124d3c523f948e838d3"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.94"
    sha256 cellar: :any_skip_relocation, ventura:      "dacfbf46a880e1ca4bb142e5efa059926b6c8ab5a10bbc9a916947f7507dd091"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b5b6e7f47bc97054671f4367f8a411f836bf29dada54f74905714944cbfd519"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.94/README.md"
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
