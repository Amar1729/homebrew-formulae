class Wp < Formula
  desc "Wrapper script for pywal with per-desktop support and other bells and whistles"
  homepage "https://github.com/Amar1729/wp"
  url "https://github.com/Amar1729/wp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ab9af91dde1991f7eb17ceb296bab218ccb163ad23fcf75a2a85a9b071423169"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/wp-1.2.0"
    sha256 cellar: :any_skip_relocation, monterey: "50c163f5af335ee4fce235b03bc251db2d180f047eb2a29b9240954dff0b1afc"
  end

  depends_on "coreutils"
  depends_on "imagemagick"
  # because wal uses pidof to check whether kitty is running?
  depends_on "pidof"

  def install
    bin.install "wp"
  end

  test do
    system "#{bin}/wp"
  end
end
