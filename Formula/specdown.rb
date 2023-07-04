class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.2.59.tar.gz"
  sha256 "fb4fbe8e3742088b13c35b66ebeb8f379bfccb2d4bf3dc1de21822a1a39a7a19"

  depends_on "help2man" => :build
  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.2.59/README.md"
    sha256 "a9f658b79fbcb4b13f85cca439cd6e55a2d43a4ad47a05578c28e9c7f88bb8c0"
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
