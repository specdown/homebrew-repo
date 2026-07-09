class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.2/specdown-aarch64-apple-darwin"
      sha256 "191e0f2bc3a53e0acc209b429357959ebac2e70b9f1058fdf38afb6622f7999b"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.2/specdown-x86_64-apple-darwin"
      sha256 "18049bd69465fb4ac3e4ed9a0171c89ca6ee7a0c1440ecdc6795e81a51b8ade6"
      version "1.6.2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.2/specdown-x86_64-unknown-linux-gnu"
      sha256 "a96b4fa2ed56d6caf2ae99872087fe799767198f6f34e0388e7bcc20b86ef284"
      version "1.6.2"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.2/specdown-aarch64-unknown-linux-gnu"
      sha256 "423071c0542a22c0481e7d566e37c380ced12103d712f32ef91e3c02b7f34dfb"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.6.2/README.md"
    sha256 "b4a0f54551331989fc3f4776188dfcbb901da2e2ff511cd801ba6d30fb662e8c"
  end

  def install
    binary = if OS.mac?
      Hardware::CPU.arm? ? "specdown-aarch64-apple-darwin" : "specdown-x86_64-apple-darwin"
    else
      Hardware::CPU.arm? ? "specdown-aarch64-unknown-linux-gnu" : "specdown-x86_64-unknown-linux-gnu"
    end

    chmod 0755, binary
    bin.install binary => "specdown"

    generate_completions_from_executable(bin/"specdown", "completion")
  end

  test do
    system bin/"specdown", "-h"
    system bin/"specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
