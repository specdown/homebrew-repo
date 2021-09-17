class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.50.0.tar.gz"
  sha256 "65946a1b209b8cc0deb8b1805009ca5ecb8427415a2e3ffbc719927d8a3eb607"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.50.0"
    sha256 cellar: :any_skip_relocation, catalina:     "7a2dcdae8cb41ef39f6918edaeff6e4d954e88630a67553d62e095f27990071d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26843b1e5451a9894c6b1f821a9e6723d4c752efd727eca11aba62ce86d6efa6"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.50.0/README.md"
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
