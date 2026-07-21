class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.6/specdown-aarch64-apple-darwin"
      sha256 "95ac3afd455dbefba612902bd8bc97c9638c736af4f042f7dae6b28c6e5129bf"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.6/specdown-x86_64-apple-darwin"
      sha256 "3e707fff3bef8bd06f9169bb83d3d75b7834e46a3d0c46d4e0823d89ee4a7f37"
      version "1.9.6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.6/specdown-x86_64-unknown-linux-gnu"
      sha256 "a619e561eaf686fd8abe6d3a002931b6671037636a98be2367378cc2cfeed6cb"
      version "1.9.6"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.6/specdown-aarch64-unknown-linux-gnu"
      sha256 "0c8194eccb0e854accabaecbf07cbe6e2d6d618d832495ef879df935c13641e6"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.6/README.md"
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
