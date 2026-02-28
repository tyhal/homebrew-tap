class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "1cc3f2e7bed6f79b2e57aa4eb809a9507bc6cd8293654d6673627dd153223b80"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7b964bf0f77c21a2a67261ce78ecba02e937fd8fdf8a2ad9ff8ccdd929a72fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "008abdabccd1ca4f0dc9768ded777fdf12fa4224d9807d52576f9084e02a30ac"
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
