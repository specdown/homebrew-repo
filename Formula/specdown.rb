class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.1.tar.gz"
  sha256 "e084d92ce9c44c3762d176d2d9ad5eab64513ca4bfb6f971a3c405101cc9bddd"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.1"
    sha256 cellar: :any_skip_relocation, catalina:     "3333da3f763da3c130c972e2625e5550c2490ef184a5257687513d11ea2668be"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a71139fca94c8d2bd2f9a17c3baadd50f75a67c8202d283594fa7f7e6cd09e54"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.1/README.md"
    sha256 "a9f658b79fbcb4b13f85cca439cd6e55a2d43a4ad47a05578c28e9c7f88bb8c0"
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
