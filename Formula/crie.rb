class Crie < Formula
  desc "Universal meta-linter using containerized execution"
  homepage "https://github.com/tyhal/crie"
  url "https://github.com/tyhal/crie/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a825e8dfe1cd98ffe91fd67f594ab8f5081f6e5a3fe9edfb6e6a4391755e5053"
  license "MIT"

  head "https://github.com/tyhal/crie.git", branch: "main"

  bottle do
    root_url "https://github.com/tyhal/homebrew-tap/releases/download/crie-1.0.4"
    sha256 cellar: :any,                 arm64_sequoia: "84a1a20d81f005c85f8a7b0d1b78ca45a51c7976c7f18fd9563a82c6574bb4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad8a669b97bbe691bbcca6e7d01c47f1958d71eac97e970b4068ab6d85599bd"
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
