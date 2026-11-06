class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "353ebd4cb3fcb9cebb748903f7319496e5221c98a1f8ceea0a8e32b249df29f2"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "989cc877164877e65d952230da611df5dcad55869da97d0ea3b7e852436d1802"
    sha256 cellar: :any_skip_relocation, arm64_linux: "358e44b50d80e2c3e2dc38c83f00375c76707f74dc1ac79ac5fc4e65c57d9354"
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
