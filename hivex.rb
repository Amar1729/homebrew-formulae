class Hivex < Formula
  desc 'This is a self-contained library for reading and writing Windows Registry "hive" binary files.'
  homepage "http://www.libguestfs.org"
  url "http://download.libguestfs.org/hivex/hivex-1.3.18.tar.gz"
  sha256 "8a1e788fd9ea9b6e8a99705ebd0ff8a65b1bdee28e319c89c4a965430d0a7445"

  # note : building hivex from source requires libxml, but not homebrew build?
  depends_on "readline"
  # depends_on "python"

  resource "testhive" do
      url "https://github.com/libguestfs/hivex/raw/1a95c03b5741326128e6c21823ab4f0e363eeb0f/images/special"
      sha256 "cc558c3628f8bf0a69e2c61eb5151492026b6d5041372cc90e20cbb880537271"
  end

  patch do
    url "https://gist.githubusercontent.com/Amar1729/ce54389a5cf9136a3b16472d7b0a4029/raw/aa2db3fc69d9400091952cb972a1d9dd99889b65/enokey.patch"
    sha256 "481a295b1257a33eda1a162d947be7721e5281cecbd3f51bf4ddf5cbbb3ce62d"
  end

  def install
    ENV["LDFLAGS"] = "-L/usr/local/opt/readline/lib"
    ENV["CPPFLAGS"] = "-I/usr/local/opt/readline/include"

    ENV.prepend_path "PERL5LIB", lib/"perl5"

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

    system "make"
    # we need perl.IOStringy (I don't know how to do this in homebrew formula)
    #system "make", "check" # actually fails
    system "make", "install"

    # doesnt work yet
    #(bin/"hivexregedit").write_env_script(libexec/"bin/hivexregedit", :PERL5LIB => ENV["PERL5LIB"])
    rm bin/"hivexregedit"
  end

  test do
    # upstream-generated hivefile for testing
    resource("testhive").stage(testpath)

    # hivexget
    assert_equal '"zero"=dword:00000000', shell_output("hivexget #{testpath}/special zero", 0).chomp

    # hivexregedit
    reg_check = <<~EOS
Windows Registry Editor Version 5.00

[\zerokey]
"zeroval"=dword:00000000
    EOS
    #reg_output = shell_output("hivexregedit --export #{testpath}/special zero", 0).chomp
    #assert_equal reg_check reg_output

    # hivexsh
    (testpath/"test.sh").write <<~EOS
    #/usr/local/bin/hivexsh -f
    load #{testpath}/special
    cd zero
    lsval
    quit
    EOS
    assert_equal '"zero"=dword:00000000', shell_output("#{bin}/hivexsh -f test.sh", 0).chomp
  end
end
