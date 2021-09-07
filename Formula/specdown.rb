class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.47.2.tar.gz"
  sha256 "723b36265b3a552293d6b38625c3aa47d684c96d67e4561a9f2fdf93b4c4c5da"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.47.2"
    sha256 cellar: :any_skip_relocation, catalina:     "8ed8a79b376b9d7254afeadaaf8ca971a72ccc21e024064269452d97eeeee344"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa14f7268d913203e64d86fd02f57f68aa02f9dc0e9bc3ec00ca0cca7ab73ff9"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.47.2/README.md"
    sha256 "256e375ecdf0c9f0567c05a20f62b222bd0efade004747484227d98fa307eed3"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
