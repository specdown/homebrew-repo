class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.10.tar.gz"
  sha256 "75e9e59261539400236d23a44c2e3f94c1fa8823742ff06da6d1e49dd5973a53"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.10"
    sha256 cellar: :any_skip_relocation, big_sur:      "9e75cde02c43644bdc5e1f3aa4178e58da204f724a671e261ace38489d5f4c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f9d9fd99a52efdc9c49ac6c105707e8891bb46fc53a4faf094c2ba303a24472"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.10/README.md"
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
