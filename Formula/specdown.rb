class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.51.0.tar.gz"
  sha256 "d5d51c279e0fe0deabdd815bdfa67b2a99d9b00b7eab6a7f2d6112d0e78a5506"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.51.0"
    sha256 cellar: :any_skip_relocation, catalina:     "7af8ee471258a7cde8aa955107808b600a701fb5853962302032913068140aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "717584b65446cc7913e2a1c77250bebac74d1554b568957273f43e5af2229c0e"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.51.0/README.md"
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
