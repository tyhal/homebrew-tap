class Gotraceui < Formula
  desc "Efficient frontend for Go execution traces"
  homepage "https://gotraceui.dev"
  url "https://github.com/dominikh/gotraceui/archive/bfc5b70255cae54a74929a1e2394d57d4a3bc9d8.tar.gz"
  version "20251215"
  sha256 "35955954b8ae323a16ef764bc70fba851cbec92f3cdff15688e1670aa564b68e"
  license "MIT"

  head "https://github.com/dominikh/gotraceui.git", branch: "master"

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libxcursor" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "llvm"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    if OS.linux? && !Hardware::CPU.is_64_bit?
      odie "gotraceui requires a 64-bit CPU on Linux; gio's Vulkan backend uses CGO and does not support 32-bit ARM"
    end

    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
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

    system "go", "build", *std_go_args(output: libexec/"gotraceui", ldflags: ldflags), "./cmd/gotraceui"

    unless OS.mac?
      (bin/"gotraceui").write_env_script libexec/"gotraceui",
                                         XLOCALEDIR: Formula["libx11"].opt_share/"X11/locale"
    end

    pkgshare.install "share"
  end
end
