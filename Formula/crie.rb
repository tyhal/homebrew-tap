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
  depends_on "pkg-config" => :build
  depends_on "gnupg" => :build


  if OS.linux?
    depends_on "llvm" => :build
    depends_on "btrfs-progs" => :build
  end

  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "gpgme"

  def install
    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.prepend_path "PATH", Formula["llvm"].opt_bin

      # Pkg Config
      Formula["crie"].recursive_dependencies.each do |dep|
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
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crie"

    generate_completions_from_executable(bin/"crie", "completion")
  end

  test do
    assert_match "crie version #{version}", shell_output("#{bin}/crie --version")
  end
end
