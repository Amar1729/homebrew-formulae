class Wp < Formula
  desc "Wrapper script for pywal with per-desktop support and other bells and whistles"
  homepage "https://github.com/Amar1729/wp"
  sha256 "ff61efca6bb11ff4fc641eabd6532678169c4da4eedbd3686a45815952baf303"
  url "https://github.com/Amar1729/wp/archive/refs/tags/v1.0.tar.gz"
  sha256 "04e370af6f6d00ab583ad153a17acda25d3692ee479fd847e2de475a79b36ec2"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/wp-1.0"
    sha256 cellar: :any_skip_relocation, catalina:     "fea79f60c29a33c6cd9001c75b29ba9d8269a80f2b578f9a4853d799530e47da"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e80ae4d7486c2d1de352fd4a2a0b58fe88780cdd6b33f70cc06345ac53e3a105"
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
