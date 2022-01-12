class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.5.tar.gz"
  sha256 "cb6cf9b75162175c8be9c38e113296479c9453918686277d0e4dd9f5e037e7d5"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.5"
    sha256 cellar: :any_skip_relocation, big_sur:      "1c1aa1965155701cc99c0ac46577773fcf8d70f36e5348068356acd82dc46865"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58457acd1bc871c33714b94cd35e38e841fabea96a6808765b5ed3b4a53d0ec9"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.5/README.md"
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
