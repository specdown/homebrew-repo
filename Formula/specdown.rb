class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.49.0.tar.gz"
  sha256 "b869edbe8b36d1762b469991c0c75e1e7f759c8a1310fc74090e2ffbb13124ab"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.49.0"
    sha256 cellar: :any_skip_relocation, catalina:     "cdf3eff678d5cd928ee18ac1f6045f3f12e094c89d3ed8dced212a0fa1a0eaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b739ff891df283685a7b7a97db67aa9a62047676ef11f759b90053510a7734df"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.49.0/README.md"
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
