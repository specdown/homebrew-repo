class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.7.tar.gz"
  sha256 "b31892db6088c2374b54ec341dbe1aa2a9518875d520e55793c5462e89ea3e5b"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.7"
    sha256 cellar: :any_skip_relocation, big_sur:      "a6208213ca54796e4f969b448b328b79b47a806949de0edc2b9fae7e4f39a81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d94f407b66d9e8d3ff279b1cbb3ea6417e3dfb80aefb307085e910812e04e153"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.7/README.md"
    sha256 "a9f658b79fbcb4b13f85cca439cd6e55a2d43a4ad47a05578c28e9c7f88bb8c0"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "bash")
    (bash_completion/"specdown").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "zsh")
    (zsh_completion/"_specdown").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "fish")
    (fish_completion/"specdown.fish").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
