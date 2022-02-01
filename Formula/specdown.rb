class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.6.tar.gz"
  sha256 "b27eb0985548870d439307353af716f886e4a3aad57fa486d41c839d3b09933f"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.6"
    sha256 cellar: :any_skip_relocation, big_sur:      "c3cf74df5c5cccde75dc41923989c3ef6b51d96c6dbc66646d3d363f58523949"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52bd31a2261aad54af9202aa081888e9eb8ca37f420e8e9c0b74b39fc4f7fffd"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.6/README.md"
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
