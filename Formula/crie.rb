class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "63a93ca6b52c994c2c374a5e9b34a3bec3fe3edb93c16783c76ba63a81c56136"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://github.com/tyhal/homebrew-tap/releases/download/crie-1.0.2"
    sha256 cellar: :any,                 arm64_sequoia: "a9446ec61493efd13195e309d8a9e86b06629ba1ae65989a11b2e7ee2325f731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9b0f918260d6348be620701d75a36dacf5193cd0955e86c37442b4656ae6da"
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
