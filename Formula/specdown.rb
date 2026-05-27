class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  version "1.3.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.1/specdown-aarch64-apple-darwin"
      sha256 "2855b9e1d7620bd26c1355ddc742a29e14526e0edcc0938ea9c9bf17f2850535"
    end
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.1/specdown-x86_64-apple-darwin"
      sha256 "f97a4a973c66a86f33611ef567d7be019eccece5beab1b2f51cad24cdffe1845"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/specdown/specdown/releases/download/v1.3.1/specdown-x86_64-unknown-linux-gnu"
      sha256 "2c4ee4956ff42da3ecb15022dd20683ad1554e119b540809a0f3d2a341c0a516"
    end
    on_arm do
      url "https://github.com/specdown/specdown/releases/download/v1.3.1/specdown-aarch64-unknown-linux-gnu"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    end
  end

  depends_on "help2man" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.3.1/README.md"
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
