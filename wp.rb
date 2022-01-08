class Wp < Formula
  desc "Wrapper script for pywal with per-desktop support and other bells and whistles"
  homepage "https://github.com/Amar1729/wp"
  url "https://github.com/Amar1729/wp/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "374246089fcf5ea0fc3008877f3831319e894481b1abfffe091addea9badba48"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/wp-1.1.6"
    sha256 cellar: :any_skip_relocation, big_sur:      "51f53601882e9f196fa07bef1034698db0abe6bb88bf55bc2be28b9e30a2c50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58dbe3df3efcb317cfeca49b678b88f152da23fb32d03c0f10f93ad6524cb6df"
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
