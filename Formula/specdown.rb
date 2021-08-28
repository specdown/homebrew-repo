class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.47.0.tar.gz"
  sha256 "9bf912bae64c3858fee77304b12abfb1049614c118cb8b477a3ffa3ebe41aef1"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.47.0"
    sha256 cellar: :any_skip_relocation, catalina:     "53f54bbcc293a72106b813c8b9a368f078841b10bba6786e6d69b14b280356d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1fe737961b9201dca423d8cda0d7cdaf5cafb5a28af1843dd2d286327f052124"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.47.0/README.md"
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
