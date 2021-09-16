class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.48.0.tar.gz"
  sha256 "f2c9df63b6b9c14f8e34e06de64271c90776830f42e41903a204bf335186a50f"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.48.0"
    sha256 cellar: :any_skip_relocation, catalina:     "7fd201156fc6ffec40ca05199f0885998d396e917150e89e85df4e690153debe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3fad36946c6dfb23b35d5d3b4e959616d271239134c7f8d3eb5ed2959e43f704"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.48.0/README.md"
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
