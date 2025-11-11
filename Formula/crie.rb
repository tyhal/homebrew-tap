class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "de8234cfcb7172f1459811f0703d6b1be72a72348d0ab828bad5177dedc23e10"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa5dbb8040945f2e89147b053fd7448977390e059d2d9d4a39ce7a8878ff7c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83678f153a77c63e8e02be02b51e27cbcfafd729fa6739ccb5134b8d70d146b"
  end

  depends_on "gnupg" => :build
  depends_on "go" => :build
  depends_on "libassuan" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "btrfs-progs" => :build unless OS.mac?
  depends_on "llvm" => :build unless OS.mac?

  depends_on "gpgme"

  def install
    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV.prepend_path "PATH", Formula["llvm"].opt_bin

      # Make sure pkg-config finds gpgme and its dependencies
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["gpgme"].opt_lib/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["libgpg-error"].opt_lib/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["libassuan"].opt_lib/"pkgconfig"

      # Point to btrfs-progs headers
      ENV.prepend_path "C_INCLUDE_PATH", Formula["btrfs-progs"].opt_include
      ENV.prepend_path "LIBRARY_PATH", Formula["btrfs-progs"].opt_lib
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
