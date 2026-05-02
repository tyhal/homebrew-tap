class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "9c03da34987b1089983c63ac24cc5d6a9eb7f080a4797bf9abdaacb631ba85c6"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "211bdfe84b86970252103925d51b9b994eb0f447f677d720b626a16e5fc32e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95c77cceb9024ea082cced16067e0d82a75aa5e7b029950320338a4e4ee1d8aa"
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
