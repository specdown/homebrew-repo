class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.53.0.tar.gz"
  sha256 "49b15d5a34856ba69b61eec2f953dd3070962112c31261334844f341f2bb33ef"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.53.0"
    sha256 cellar: :any_skip_relocation, catalina:     "fb5913e318a4a76e677c5b46f94630f8c73274946d9110eb789857ad3531d1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f43d5e3af6234ebf9cc4231ce536734deaa85793d57011c68d4fa77ee821a06"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.53.0/README.md"
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
