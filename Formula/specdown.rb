class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.47.3.tar.gz"
  sha256 "6c79125f7a957ad0809fb1407228bb019abcdb020f88f70b766c53be606eae26"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.47.3"
    sha256 cellar: :any_skip_relocation, catalina:     "76587c12bf982af1c40b014106efe3891e59ecbb9a1df1e98454683c4e7268a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9bc8d21300b84553b0360f28033581566ab2d98a861a37367887af58dc6343f3"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.47.3/README.md"
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
