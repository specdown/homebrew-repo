class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.4.tar.gz"
  sha256 "00e7d8957ddba8de2b1b2fed96a07a1b24446f09cef3b9cf9a3070b027489a0d"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.4"
    sha256 cellar: :any_skip_relocation, big_sur:      "3188bb5a5397241367a4e0efb9110b76da30be4172dd5e9eb3abf8cc1cbeb5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc666a03c164631ac00a23da400c0d451fa59204b93bd0a221a51cc64e232f6b"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.4/README.md"
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
