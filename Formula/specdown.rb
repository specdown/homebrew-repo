class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.0.tar.gz"
  sha256 "a48d13ecae81e813808fd8f3d8546022f544e760a690d145a8f6b3d6b48f01d5"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.0"
    sha256 cellar: :any_skip_relocation, catalina:     "a0c91d3fa45f50ba35d076bdb74b4a1177158a524f38e3590b42c32539c798cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2169156e20ae38f26da71959d13bd5088f196a0a1290a96384b6dcce02727b87"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.0/README.md"
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
