class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.0.tar.gz"
  sha256 "7e9998e0f0eb8abae808f85006bf26996ca6340b2e980ffbb27f1950d5ac071b"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "2767c821e48f6a6587ac2c0501d51a3272b1e9862b304e13d376622160f30cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "40765565daa5d08f9e60f9a84e5cd7a3fcac1ae7360aa4a969b14f84e565c698"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.0/README.md"
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
