class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.47.1.tar.gz"
  sha256 "03a774f4d2f9a016f10c924f54cdf85caea41804da756d3713c02156393edfe3"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.47.1"
    sha256 cellar: :any_skip_relocation, catalina:     "46f8ac59a275dcd0614c581029fa9ec6b2abb664bab9020e53a0678de23e4126"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca3d78d60c5bd67033724294e1dd6d0d177e2f26e8448afcfce83e39ee1b2be7"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.47.1/README.md"
    sha256 "256e375ecdf0c9f0567c05a20f62b222bd0efade004747484227d98fa307eed3"
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
