class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  version "1.3.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.2/specdown-aarch64-apple-darwin"
      sha256 "8d686491dd695f791fc26131a2424da9c530b319c0744b27c17aeb654e67d743"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.2/specdown-x86_64-apple-darwin"
      sha256 "5e51f0348ec6d413219f4c69960f1227c2c20c8b78ffc332c94bc0e0cafe9700"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.2/specdown-x86_64-unknown-linux-gnu"
      sha256 "3c1870ffd5f4789b10d861543943806bd2a258b55e4a75eaf43dd852ff67b4df"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.2/specdown-aarch64-unknown-linux-gnu"
      sha256 "7b64efd7d6d61dd3a47fefca87810fdc36fb5955c706c0e23731d9e060870cb9"
    end
  end

  depends_on "help2man" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.2/README.md"
    sha256 "b4a0f54551331989fc3f4776188dfcbb901da2e2ff511cd801ba6d30fb662e8c"
  end

  def install
    on_macos do
      on_arm do
        bin.install "specdown-aarch64-apple-darwin" => "specdown"
      end
      on_intel do
        bin.install "specdown-x86_64-apple-darwin" => "specdown"
      end
    end
    on_linux do
      on_intel do
        bin.install "specdown-x86_64-unknown-linux-gnu" => "specdown"
      end
      on_arm do
        bin.install "specdown-aarch64-unknown-linux-gnu" => "specdown"
      end
    end

    generate_completions_from_executable(bin/"specdown", "completion", shells: [
      :bash,
      :fish,
      :zsh,
    ])

    # Man pages
    output = Utils.safe_popen_read("help2man", "#{bin}/specdown")
    (man1/"specdown.1").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
