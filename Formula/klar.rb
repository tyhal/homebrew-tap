class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "8479a782938189174c04edad8c8200026498cfd4e2db34a77fce6b9c19a28d67"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "fa6054c9e9f19e2fcf66555c68bc9ed58a6226ba4c8a68102ce607cfbf5d4abf"
    sha256 cellar: :any_skip_relocation, arm64_linux: "9d9b23d6f8ef7d0c4dd9803c13aa207c569e551e19b6590f9c97e7e51e2336ef"
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
