class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.4.tar.gz"
  sha256 "6cee9aae401c20f21308cc8024efb7558be0fe89e7ac69e69336591826a4a3d7"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.4"
    sha256 cellar: :any_skip_relocation, catalina:     "da7b1da578205806b4bc47b0350e0845f8fc26f29e127c037676aa3a96bf3c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a5dc81e0efea05b20177af301d72027a837a7f557398af89410877b9db91b7a"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.4/README.md"
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
