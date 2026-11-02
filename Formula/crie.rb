class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "4e714dfe7dee4288b86ae945b0618c04bb387efae7dfc195232a0109b9b0ef04"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d09f508bbc616a4efbad6c4e2aecebae1cbe9cfd54c018547df0f01e5c58be98"
    sha256 cellar: :any_skip_relocation, arm64_linux: "5c200c1161ebe3faccd5875ad334470a946c844d4b5f12121798d5d67ee5aed3"
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
