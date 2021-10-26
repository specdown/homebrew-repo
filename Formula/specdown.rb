class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.0.0.tar.gz"
  sha256 "cc59c2570033da89ed78cd4ab0abc3233a6050bc0034fbe8d7f63ae18843d6bd"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.0.0"
    sha256 cellar: :any_skip_relocation, catalina:     "86a38a8fd97ae3ad849f0e9f0500668f912cd256a566b84b4f9e5d7c0074e70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a2963d129450e82f662de6d416b2f071f49b1ee762857f0fdfc8b65b823d832e"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.0.0/README.md"
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
