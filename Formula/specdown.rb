class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/refs/tags/v1.2.98.tar.gz"
  sha256 "12098ae464382d8ec2cec7602acdf2f69d0d2b22667eca9955500edab402d372"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.98"
    sha256 cellar: :any_skip_relocation, ventura:      "77c0be293fb31f0cfc7c8e76d199e3fd71fcf8e06e3fb6c335305c8708fa6fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd1dfaf27aa2b7f4531762c75fbf83603c8fd2906e8c74cfafde92a92a49d7e0"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.98/README.md"
    sha256 "fa7dc4903d8d114032b7fcb424f2dd112d520063faa5df00b396b8726efc2589"
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
