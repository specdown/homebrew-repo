class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.52.0.tar.gz"
  sha256 "8ac07d8c68fb55b6b0f44b4591ef96017b40d461de7edb63f77bacb4d214b7c2"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.52.0"
    sha256 cellar: :any_skip_relocation, catalina:     "85900d5ec4624e90e5fcce7d539895d5eb11a2e2988ed30270d317f6bbecd956"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bf1475932e680e4c9f91e294a964ad6d49a811719907bbea096169489a6ca2c8"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.52.0/README.md"
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
