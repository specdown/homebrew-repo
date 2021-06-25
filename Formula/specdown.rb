class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.45.0.tar.gz"
  sha256 "beacfd24f1fc15e88c59216410936650434c2d9b9078f37ea34e5474f21bf65d"

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.45.0/README.md"
    sha256 "46c7fd644a428a2406a2b5395e569ca0d1a776fc2ec618d8910bab315884379b"
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
