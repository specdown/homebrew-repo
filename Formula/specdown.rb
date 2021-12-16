class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.3.tar.gz"
  sha256 "ce8688497785d4d49adf5f1df673c181555f6673d560876c039bf607c407f3ab"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.3"
    sha256 cellar: :any_skip_relocation, big_sur:      "2bd383ed31317421007c7d9a201bdad83f755146f8aea1ff4d465e182d89b427"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9f27537fc5102739d5138be97c25a2d1c51bc716baf0ad845699873395d7c4b"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.3/README.md"
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
