class Wp < Formula
  desc "Wrapper script for pywal with per-desktop support and other bells and whistles"
  homepage "https://github.com/Amar1729/wp"
  url "https://github.com/Amar1729/wp/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "0b315c8efe5e59a5ec7ce5db66d75bed85a000cfb481fc8c7f52c5c39fc6faee"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/wp-1.1.7"
    sha256 cellar: :any_skip_relocation, big_sur:      "d6d3755d337b0578b3519c935c39204a22048482cddf4ce6d4cc86b2172c6e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c9074a8247e8bb9c6c20a9d8a1c0071800acfe6952b3a1247fee0312bcb4921"
  end

  depends_on "coreutils"
  depends_on "imagemagick"

  def install
    bin.install "wp"
  end

  test do
    system "wp"
  end
end
