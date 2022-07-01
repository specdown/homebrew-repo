class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.16.tar.gz"
  sha256 "46827d5d06957530867f83e4fbac01022db93832d0e0ccebc6ee585312d1d5cb"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.16"
    sha256 cellar: :any_skip_relocation, big_sur:      "8c8a6505361e3091c9b30d220a7f9e76459ad462cb92f48ad2ee3ed0aa16fa40"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79ac79faa23d81aa2cd7646e9e4dee2ab0741ab701a1052b17873a3d7e47bb9b"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.16/README.md"
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

    # Man pages
    output = Utils.safe_popen_read("help2man", "#{bin}/specdown")
    (man1/"specdown.1").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
