class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.44.0.tar.gz"
  sha256 "17ea612eb9cf8b65c96d89d1a85e669bb7be06f3960589687440b0fe29aeb4f6"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.44.0"
    sha256 cellar: :any_skip_relocation, catalina:     "c0a2232d180e53f6800adc34db56460ccba503606fe83f7a1e28b1011170ce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "38f5f85f9e83385dc5009c2c9dbb7d83d1ac398c30dd517dd82cd7424e61fcf6"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.44.0/README.md"
    sha256 "159572701dae798b44a40ee8a1721440d379759c7cf93284a2ae194686ec65e3"
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
