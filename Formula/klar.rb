class Klar < Formula
  desc "Structured json → clear output"
  homepage "https://github.com/tyhal/klar"
  url "https://github.com/tyhal/klar/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "4f4c879803e5679be9ec5809c95434927a8ea03dcf80ac422f030ccfa75f5464"
  license "MIT"

  head "https://github.com/tyhal/klar.git", branch: "main"

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
