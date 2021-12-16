class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.2.tar.gz"
  sha256 "161c12a86f0429601104dcb531fb231cb39f327ae89983dbd0568c535a8bf913"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.2"
    sha256 cellar: :any_skip_relocation, big_sur:      "c553f0ad80d931ea08e26b58ff0132556016196a5f27e051b45405f3db8babec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a1809087c69610b0f7c7150136ab7fd79a34a08fa67c5b856acccf5f64f3529b"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.2/README.md"
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
