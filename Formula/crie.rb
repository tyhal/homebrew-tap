class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "15629f0c1afa224bf9de7bb792b4798090f7bf3455c4044213ecb198c21884c5"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/homebrew-tap"
    sha256 cellar: :any,                 arm64_sequoia: "66738e685b997062020d101b8c80f7ad87468bcf480f94af60bad566e7fc7906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e081671fbdf8ae5d958cc2916e91703d72b8f5a724195d2e403087fdb53ee6d"
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
