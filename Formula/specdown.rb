class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.45.1.tar.gz"
  sha256 "60c4112bb67c0f5b7c600551ac184685db537db2d0ac97bc3005e627c8af6eef"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.45.1"
    sha256 cellar: :any_skip_relocation, catalina:     "9486a4ac01a2bd7019e84c8648232d96a327eba4fe69cc342606873534f432bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70608e921e8f7a2764822d23d0937e9b90833473df854b5837d1530b309a1a30"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.45.1/README.md"
    sha256 "9917bd20e306e4df2f48fbbb458a8be337710c7fcd843a38871daaa1682970d0"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
