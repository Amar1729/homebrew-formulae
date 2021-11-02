class Wp < Formula
  desc "Wrapper script for pywal with per-desktop support and other bells and whistles"
  homepage "https://github.com/Amar1729/wp"
  sha256 "ff61efca6bb11ff4fc641eabd6532678169c4da4eedbd3686a45815952baf303"
  url "https://github.com/Amar1729/wp/archive/refs/tags/v1.0.tar.gz"
  sha256 "04e370af6f6d00ab583ad153a17acda25d3692ee479fd847e2de475a79b36ec2"

  depends_on "coreutils"
  depends_on "imagemagick"

  def install
    bin.install "wp"
  end

  test do
    system "wp"
  end
end
