class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.6.tar.gz"
  sha256 "c03be1f9eae476752f1db46e27738e5415f53fbb5050f169491aa128ac68e742"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.6"
    sha256 cellar: :any_skip_relocation, catalina:     "9c710b586e6f96523dec5045de25e97e28e66760c8958340c21a7e0822f0df58"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5329c991c4328d1cd1cd879ccb508f76b27754c2865b34e323a41ad0c471c5a8"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.6/README.md"
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
