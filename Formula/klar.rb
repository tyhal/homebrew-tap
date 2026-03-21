class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "b7d883bce0cd2cac44a7bef2a031865e14cc5b987833924d4c1149388e32ac5d"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d70ca3418fd594f0bbbeb516f276e5fbea4fcdc05151de2db9008df560b59391"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3d4e539f75ec98ef331273ee6dbea0325d7c3063ec7a524711327f4ec0122c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = ""
    ENV["GOEXPERIMENT"] = "jsonv2"

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/klar"

    generate_completions_from_executable(bin/"klar", "completion")
  end

  test do
    assert_match "klar version #{version}", shell_output("#{bin}/klar --version")
  end
end
