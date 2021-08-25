class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.45.2.tar.gz"
  sha256 "ebef3d3cbd9b7bbe693bb31e97dd4c1b7d7784fa9b4f557e21ab23d30d882927"

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.45.2/README.md"
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
