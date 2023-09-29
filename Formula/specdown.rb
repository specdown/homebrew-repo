class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.86.tar.gz"
  sha256 "52715c474028b1d4e4a29ce7849dbb4cb862f83adbc20f5bf7b68d4909193048"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.86"
    sha256 cellar: :any_skip_relocation, ventura:      "2d5d666d2e72b8408902c39f18a85ecaadfb87bedf0ddb583dc26da1d58cd67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10784b0dd8f6b6c35d0d05f73092d6c657ee0227a69ba7db89341f74c329b071"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.86/README.md"
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
