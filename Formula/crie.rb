class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "15629f0c1afa224bf9de7bb792b4798090f7bf3455c4044213ecb198c21884c5"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2d4bd2ff49ca90801a87c4436806828caa2b8d21f9cc061b1d43bdc8d6095b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7f1030eaba74ceebf69035ba4b07c6504060a569670c1d4751eeb2783054de2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-tags=exclude_graphdriver_btrfs,containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crie"

    generate_completions_from_executable(bin/"crie", "completion")
  end

  test do
    assert_match "crie version #{version}", shell_output("#{bin}/crie --version")
  end
end
