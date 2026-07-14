class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.2/specdown-aarch64-apple-darwin"
      sha256 "c5fa434d73455fc5d2f595d96c991f07738a66279a935d0a1ef9ec97d48ec15e"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.2/specdown-x86_64-apple-darwin"
      sha256 "76a7519a955541f7769db948b64a3b6cbb0f28482a36e9819c224b018edababe"
      version "1.9.2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.2/specdown-x86_64-unknown-linux-gnu"
      sha256 "1f403a1616a0c5eefeb91cc08998ad0b6ad462a557a216be93e08d2cca60d0ad"
      version "1.9.2"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.2/specdown-aarch64-unknown-linux-gnu"
      sha256 "87465553f15ef8f7d55dff9d879e499a78887b6bcdbe1985b565465482a05057"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.2/README.md"
    sha256 "2b19ae63dd39b0ddd5385822b8e4783509fe5ff465eace3501094058c130019f"
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
