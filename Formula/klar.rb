class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "9c03da34987b1089983c63ac24cc5d6a9eb7f080a4797bf9abdaacb631ba85c6"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "643509be8e0931dd4c65899ce5bfb328f787a63b19cf73426082247983af1949"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d1199b8c9de5f95749d8059532b6a2afc7e33d2342e8c1794b2c00ec8f66630"
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
