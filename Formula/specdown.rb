class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.43.7.tar.gz"
  sha256 "596305d802ed557ffb602811a0c7a10357848e67f89bdcce82d725d7aaefff46"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.43.7"
    sha256 cellar: :any_skip_relocation, catalina:     "bfc922dd4c07958becb004442ea7d5d15c245884b32bcc38ef2d5808398ba02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c26e11f0e5314a57789be3692ce7ea6adec91a0691bc6808fd9120f17ce3887"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.43.7/README.md"
    sha256 "5dc6c725ab63f61ce92b2ebb7c63136864d7ba55c98264a1e48258f48a908aa1"
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
