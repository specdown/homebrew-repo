class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.88.tar.gz"
  sha256 "cf0ab076f95e4ecb1d5aa65552f46fe9c46745c9723d85fa5593f12958146cbd"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.2.88"
    sha256 cellar: :any_skip_relocation, ventura:      "21baf3bbd80ec57e0a8542e6bf02dfa1e544d11d99352f8c24d9e50c89bab9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a74608bd1c6e162534d63c0bf3fa327722c1268dd5f7d6a6d7c6334ba2b43ef"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.88/README.md"
    sha256 "f63547bd73fb8a06fd21b71ca087823419c2ef51fcdc14d7dd699ee0d127f779"
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
