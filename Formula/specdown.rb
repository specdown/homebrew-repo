class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.1/specdown-aarch64-apple-darwin"
      sha256 "284a438ef56e1d1819feb6c66a8b1e32b717c4e06382aca7b2a82860365025b4"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.1/specdown-x86_64-apple-darwin"
      sha256 "fd8da91737ff44aebc70e3d150c14651b71939c14f37e55ae27866de669879cb"
      version "1.6.1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.1/specdown-x86_64-unknown-linux-gnu"
      sha256 "a280ceacbe64dc5edd3a53f2046855df4f35ec0ac12fa6b038979c6195fbbcd6"
      version "1.6.1"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.1/specdown-aarch64-unknown-linux-gnu"
      sha256 "fb9674d18541a334ed488729cfeace3f4f2b534685ead553bdb2fe883472c3a7"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.6.1/README.md"
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
