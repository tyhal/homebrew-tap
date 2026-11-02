class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "4e714dfe7dee4288b86ae945b0618c04bb387efae7dfc195232a0109b9b0ef04"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "23ffac081d4b93daf8f7a68b1282456923c1349032d9133b8ea18fb576697694"
    sha256 cellar: :any_skip_relocation, arm64_linux: "997465ac19fca6114bc4217f692dd511a093e80bcb8f438eb94c7b10953a0e36"
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
