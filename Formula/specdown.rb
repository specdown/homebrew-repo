class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.23.tar.gz"
  sha256 "570330e71bdeedd11a87d02f37cfd005697b8142639baa8b0b80103ff5899420"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.23"
    sha256 cellar: :any_skip_relocation, big_sur:      "0ecba2dd29b51072de46ebe32d610c84a1787d53ccaeb9ac9fd98d61378d53c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28344302d7b6a6ba1b2ced50706e0c39649c4ca4fcef75ab440deecdcdcaa5cd"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.23/README.md"
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
