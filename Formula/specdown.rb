class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.6.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f4302fa4c6c875ce62f25fcb1e22f48ec70296396c2c2338d411e84a5564c81a"
    sha256 cellar: :any_skip_relocation, tahoe:        "4b5d541f45649b50c06ef5b38f058dcdd27ca01e3b5be35aaa4a012ecd8f17f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "faa0fee0c30d7e1f8a4d6b0898c695e2de552f49f0d5c823edd79ad325f2fef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b08609499201f9a0c46082922b8acfbc6c390cb4323cab8a11a98ea4dc3c1a34"
  end

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.3/specdown-aarch64-apple-darwin"
      sha256 "4a758d68306b269065899d7f50726636ff57a5666c5398644ea21283dc74bc9c"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.3/specdown-x86_64-apple-darwin"
      sha256 "accafeffe4544eac94f9c219077ce6a2b8ff5e036fed4f1ec23630c94283a007"
      version "1.6.3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.6.3/specdown-x86_64-unknown-linux-gnu"
      sha256 "d719e12418d303f5afbea8620b11a112378f46301c6e1511b149c13c3aee2aa3"
      version "1.6.3"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.6.3/specdown-aarch64-unknown-linux-gnu"
      sha256 "3b662c0049b416843343af9c6134db47882ca10d18a43c59f503e014c6079d22"
    end
  end

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.6.3/README.md"
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
