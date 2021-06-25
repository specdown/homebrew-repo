class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.45.0.tar.gz"
  sha256 "beacfd24f1fc15e88c59216410936650434c2d9b9078f37ea34e5474f21bf65d"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.45.0"
    sha256 cellar: :any_skip_relocation, catalina:     "ac18120d7f5a9ae2732edd5ccd15f8dd7575fd01edd76e555631a771fff941fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d32b39cd167b026aa8c18e679ce403fbdbc632972d94dfea20c83cd463148a0"
  end

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
