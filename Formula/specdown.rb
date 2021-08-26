class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.46.0.tar.gz"
  sha256 "c5a3533a5d38aaa04509ca5907f78a0cdaa4f4e3a2bb84a4549c108bdd0aefbb"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.46.0"
    sha256 cellar: :any_skip_relocation, catalina:     "f4d65f0cc922a91f1056f0d8c395d360363ef3573c0781d8e8209f17b82c23d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d695f37025eee013a2ff9be8113c70c12546433f76caa7f490e4dd0db7b75823"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.46.0/README.md"
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
