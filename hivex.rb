class Hivex < Formula
  desc 'This is a self-contained library for reading and writing Windows Registry "hive" binary files.'
  homepage "http://www.libguestfs.org"
  url "http://download.libguestfs.org/hivex/hivex-1.3.18.tar.gz"
  sha256 "8a1e788fd9ea9b6e8a99705ebd0ff8a65b1bdee28e319c89c4a965430d0a7445"

  depends_on "readline"
  # depends_on "python"

  patch do
    url "https://gist.githubusercontent.com/Amar1729/ce54389a5cf9136a3b16472d7b0a4029/raw/aa2db3fc69d9400091952cb972a1d9dd99889b65/enokey.patch"
    sha256 "481a295b1257a33eda1a162d947be7721e5281cecbd3f51bf4ddf5cbbb3ce62d"
  end

  def install
    ENV["LDFLAGS"] = "-L/usr/local/opt/readline/lib"
    ENV["CPPFLAGS"] = "-I/usr/local/opt/readline/include"

    args = [
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--mandir=#{man}",
      "--sysconfdir=#{etc}",
      "--disable-ocaml",
      "--disable-ruby",
    ]

    # no idea how to make this work
    #ENV["PYTHON"] = "/usr/local/bin/python3"
    #ENV.prepend_path "PKG_CONFIG_PATH", `/usr/local/bin/python3-config --prefix`.chomp + "/lib/pkgconfig"
    #args << "--with-python-installdir=#{lib}/python3.7/site-packages"
    args << "--disable-python"

    system "./configure", *args

    # Build fails with just 'make install'
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # update this
    #system "make", "check" # this doesn't work here (build files are already cleaned)
    system "true"
  end
end
