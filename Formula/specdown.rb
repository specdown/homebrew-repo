class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.47.4.tar.gz"
  sha256 "af27e8cbcf60020bd1425da646ac9daecec7ad2491278d8ded2090a192c44654"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.47.4"
    sha256 cellar: :any_skip_relocation, catalina:     "c60f7bf25cb52a3563a9662d6f5cb582ea57a36d50fce2a87fd5e1911998dd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "da2a8d7423e1e3c6f09905162a4947542df6f27e01f31ab41aac07f15e8e2d5d"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.47.4/README.md"
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
