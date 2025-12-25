class Gotraceui < Formula
  desc "An efficient frontend for Go execution traces"
  homepage "https://gotraceui.dev"
  url "https://github.com/dominikh/gotraceui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "894324f78a0f76c4e0317f995e6ae578ca9dc8fa97157946e8b6e8c45b93dc0f"
  license "MIT"

  head "https://github.com/dominikh/gotraceui.git", branch: "master"

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  if OS.linux?
    depends_on "llvm"

    depends_on "wayland"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "mesa"

    depends_on "libxcursor" => :build
    depends_on "vulkan-headers" => :build
  end

  def install
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
    ldflags = %W[
      -s -w
      -X gioui.org/app.ID=co.honnef.Gotraceui
    ]

    system "go", "build", *std_go_args(output: libexec/"gotraceui", ldflags: ldflags), "./cmd/gotraceui"

    # FIX for locales not found...
    (bin/"gotraceui").write_env_script libexec/"gotraceui",
                                       XCOMPOSEFILE: Formula["libx11"].opt_share/"X11/locale/en_US.UTF-8/Compose" unless OS.mac?

    pkgshare.install "share"
  end
end
