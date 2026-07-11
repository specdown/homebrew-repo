class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.7.0/specdown-aarch64-apple-darwin"
      sha256 "cce887fa4ca6c2f2c5b609d46c8e6100ee1b95d829b7e5bd5aeb64b014b436bd"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.7.0/specdown-x86_64-apple-darwin"
      sha256 "04e816ac60b8d80adb998156068243718d014a773927aa1da0a5f396bd74733c"
      version "1.7.0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.7.0/specdown-x86_64-unknown-linux-gnu"
      sha256 "13aa390e1efc7478e5a5f9a17e7dd7f581cd662f58de6fe2f78cbdea3fdfb42d"
      version "1.7.0"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.7.0/specdown-aarch64-unknown-linux-gnu"
      sha256 "fcd215ebdb90942dfe6d82832a8ee202b4ee02fc4d8bd75f216b6b2406e594fd"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.7.0/README.md"
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
