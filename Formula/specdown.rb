class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.5.tar.gz"
  sha256 "6f5713b1401a288ca9aa58824a3c832498bc1e2c58787dfaf4b82653b9b48124"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.5"
    sha256 cellar: :any_skip_relocation, catalina:     "857134eeef5dbc62ba4e195dcf36ad548ce0aaae73464e60525d0f6bb8ad7e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5926f1231ef4d2856e4933393f4c85000b2f6b6b65b49fe0518972b62444eca8"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.5/README.md"
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
