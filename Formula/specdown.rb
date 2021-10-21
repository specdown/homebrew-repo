class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.2.tar.gz"
  sha256 "fb4befaa3786f598bd285325ef56e0844564febc24e3dae2767c6936bd603c2d"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.2"
    sha256 cellar: :any_skip_relocation, catalina:     "0387b0c2e7210fc2b4f08d59636a38b9bc4655a8c6eb72a5904d1696c25a80bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6c8aad33b11389cc950f21c3eab1326de055940442b7728cb14708b3fa287153"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.2/README.md"
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
