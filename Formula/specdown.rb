class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.13.tar.gz"
  sha256 "bf93c38519714732a91341dceec1816ebf52aa0609789a1adcb8d0dbeb11df22"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.13"
    sha256 cellar: :any_skip_relocation, big_sur:      "0d174b8831f4b5b139fa1b8f211a30a8087897fd7d1b90330274fad528669ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e48b432ed5235c6f6586e6c8f0c08518c3c495c2dab3f79de31674cb8a27e505"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.13/README.md"
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
