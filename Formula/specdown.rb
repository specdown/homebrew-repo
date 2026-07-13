class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.1/specdown-aarch64-apple-darwin"
      sha256 "1adb4f5536157f2f426359a654a542c5d197559dd5ec06b0ea2fd06d915c0323"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.1/specdown-x86_64-apple-darwin"
      sha256 "fa0a440809fe742309349b7b9c80092841b9687c783f7c01b3981ac3c48d2555"
      version "1.9.1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.9.1/specdown-x86_64-unknown-linux-gnu"
      sha256 "58fc3c743bd7b31d5c3992ac38a5100ab82e4e8d72935f8b6a37602864c184c3"
      version "1.9.1"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.9.1/specdown-aarch64-unknown-linux-gnu"
      sha256 "c3c1a5bbe758e7d5322984f59b54e0da01adfc9bd33da7792f5beb111f35522c"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.9.1/README.md"
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
