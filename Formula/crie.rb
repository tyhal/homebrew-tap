class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "a3f009b213821b99dfa8868c19c19ff05c281d59eb6532887b85ad1b4bbf78e6"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "86bdb875a09ccce1d9d7635314f0cce827c4eff2e31f246c8e35d537b65422ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6281a0bb1da4defe470d27e8a4c67f7c0443cac616faf5342e45a7f93114c041"
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
