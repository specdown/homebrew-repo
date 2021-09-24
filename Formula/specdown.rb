class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.54.0.tar.gz"
  sha256 "dfe764e9ad184fe4bee4ab80133a67d4882d81f9e15af4b819c6e1016e1e0021"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.54.0"
    sha256 cellar: :any_skip_relocation, catalina:     "8fa684d1260e3ed37e4fe4376545e348687af3f1e028c876b4330d948343e1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9f97a18810e83dd55b3fed650de49bee556b21fad749085d4311e2a1674fe823"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.54.0/README.md"
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
