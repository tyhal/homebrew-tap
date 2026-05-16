class Gotraceui < Formula
  desc "Efficient frontend for Go execution traces"
  homepage "https://gotraceui.dev"
  url "https://github.com/dominikh/gotraceui/archive/bfc5b70255cae54a74929a1e2394d57d4a3bc9d8.tar.gz"
  version "20251215"
  sha256 "35955954b8ae323a16ef764bc70fba851cbec92f3cdff15688e1670aa564b68e"
  license "MIT"

  head "https://github.com/dominikh/gotraceui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/tyhal/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6bc9eb7f7b4cc448cafbbcf48e53cd343ccbcaf341812b69a0d8b5290e5dd8c1"
    sha256 cellar: :any_skip_relocation, arm64_linux: "62f4fe1d8531901ba91b7abf434b43648171af7c39dcea6aed95f8fb25ab3caf"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "llvm"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV["CGO_ENABLED"] = "1"
      ENV.prepend_path "PATH", Formula["llvm"].opt_bin

      # Pkg Config
      Formula["gotraceui"].recursive_dependencies.each do |dep|
        f = dep.to_formula

        # pkg-config directories
        pc = f.opt_lib/"pkgconfig"
        ENV.prepend_path "PKG_CONFIG_PATH", pc if pc.directory?

        # include directories
        inc = f.opt_include
        ENV.prepend_path "C_INCLUDE_PATH", inc if inc.directory?
      end
    end
    ldflags = %w[
      -s -w
      -X gioui.org/app.ID=co.honnef.Gotraceui
    ]

    if OS.linux?
      system "go", "build", *std_go_args(output: libexec/"gotraceui", ldflags: ldflags), "./cmd/gotraceui"
      (bin/"gotraceui").write_env_script libexec/"gotraceui",
                                         XLOCALEDIR: Formula["libx11"].opt_share/"X11/locale"
    else
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gotraceui"
    end

    pkgshare.install "share"
  end
end
