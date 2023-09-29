class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.87.tar.gz"
  sha256 "0260878f857532ed9697dafe62cc3081e021d51a5c9fec705450d90a80b44ede"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.87"
    sha256 cellar: :any_skip_relocation, ventura:      "567d33a2817effbcf11b01e7937d00c9836546a1abe3ba0670fac005fb5b314c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9b747efc2761a6d9c4e13aa8136ab84eb1d0b6b0b7027870cb5c4c76e6065ff"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.87/README.md"
    sha256 "1c73dd3c91f910d39633cf06cb3c490d70ff7e252d9ce10466b34bdb8ce115dc"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    generate_completions_from_executable(bin/"specdown", "completion", shells: [
      :bash,
      :fish,
      :zsh,
    ])

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
