class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "353ebd4cb3fcb9cebb748903f7319496e5221c98a1f8ceea0a8e32b249df29f2"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a086c7de1165dfc03d52f6ae4e14aa64d9335bd90c6a5c88664c499809e70e43"
    sha256 cellar: :any_skip_relocation, arm64_linux: "5cd8bfd07b322537594e200b8ac173a4ae6b99d2fbeec81f0c403aa59c8372d3"
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
