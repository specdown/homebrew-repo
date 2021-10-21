class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.3.tar.gz"
  sha256 "3f1d441ea7faf46a878c730ef395c6e5f950fbc5344bff46c3bfdc63fc0bddf4"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.3"
    sha256 cellar: :any_skip_relocation, catalina:     "b2e08e7a815648b0b4071415af465456a9e1cbe0a4dfee996ec09a21fd57c27f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9975fc664885bcb8e026830be12c1951b76fa8c62776a57279bec5688c03d14d"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.3/README.md"
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
