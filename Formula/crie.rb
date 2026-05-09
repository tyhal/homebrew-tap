class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "24bc36ad1d597d55200d643d2494f634a561799a9e7c75337a0696dd782ee8e3"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "462905719cd31e4e2ad50d09cda0b8cf4760be394e8cc7a6c84b639be17b87e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c195b02e8553f09d5ff59200033a8fd787c2d421961a430debbf298e7889d6c5"
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
