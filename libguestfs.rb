class LibguestfsLatest < Formula
  homepage "http://libguestfs.org/"

  stable do
    url "http://libguestfs.org/download/1.32-stable/libguestfs-1.32.6.tar.gz"
    sha256 "bbf4e2d63a9d5968769abfe5c0b38b9e4b021b301ca0359f92dbb2838ad85321"

    patch do
      # Change program_name to avoid collision with gnulib
      url "https://gist.github.com/zchee/2845dac68b8d71b6c1f5/raw/ade1096e057711ab50cf0310ceb9a19e176577d2/libguestfs-gnulib.patch"
      sha256 "b88e85895494d29e3a0f56ef23a90673660b61cc6fdf64ae7e5fecf79546fdd0"
    end
    # patch do
    #   # Change program_name to avoid collision with gnulib
    #   url "https://gist.githubusercontent.com/shulima/a0ad4c21b9287a034a4c/raw/656caed670d811692ef8a255fcff94ccc19620d9/program-name.patch"
    #   sha256 "749f49782a24f6abeeb944b406771ca64aa19993bec27d09dd4a548312f5f326"
    # end
    # patch do
    #   # Check whether lcrypt comes from a separate library
    #   url "https://gist.githubusercontent.com/shulima/2feb769e9fcbb2f7a84f/raw/2e99df4f5b16ab8a9624163b9c7d34407ce688f0/lcrypt.patch"
    #   sha256 "f6cae96bd32bb20308c087f091ffd7ff9240bfe8d3a5ea029eeedbeb4a1aa73e"
    # end
    # patch do
    #   # Check if POSIX_FADVISE exists before using it
    #   url "https://gist.githubusercontent.com/shulima/c45bc24af8e0291bfb95/raw/44057e50b0566fb8526838d4927db2f4aa04510f/posix_fadvise.patch"
    #   sha256 "86cd41ddfe85309a2d1c0cc7ffc37330f83f3f5be5fc894b4127ec65cbf52d73"
    # end
    # patch do
    #   # Replace Linux-specific fuse commands
    #   url "https://gist.githubusercontent.com/shulima/b1bfa6accd67c457d5c0/raw/8405558ed32897e5294675f5f2b4bd65990b6f3c/fuse-bsd.patch"
    #   sha256 "cff6759d306077c199bc2ef9503957a0be15b87006e4a07eeb1ba725c5515059"
    # end
    # patch do
    #   # Turn off doclint to allow Java bindings to compile
    #   url "https://gist.githubusercontent.com/shulima/00735be5ece79da21b91/raw/c259d2076c2fc620052b72d71a48bb464b5a4e3d/java_doclint.patch"
    #   sha256 "d32d895daa359111194485ed0d04ab29251952e9395235e17a8426388aeea2c2"
    # end
    # patch do
    #   # Add third parameter to xdrproc_t callbacks
    #   url "https://gist.githubusercontent.com/shulima/65b6445698c4d61d7314/raw/1a873e3f70d6805f346d972bcf2ae734abb57000/xdrproc_t.patch"
    #   sha256 "83aaa05ab8e348ca740cacd43faa51ad3b20c80441da35d10f222f6a6b27952f"
    # end
    # patch do
    #   # Use getprogname where available
    #   url "https://gist.githubusercontent.com/shulima/b232a15b8ff877f817bd/raw/4e301e4e7a02d3aa27f3c2fb5faee69c1c39f3b2/getprogname.patch"
    #   sha256 "6aafa3718b73c45124c72357b460ddc91accc0a418e830a38a933f43cd2feac2"
    # end
    # patch do
    #   # Add MacOSX-specific byteswap defines
    #   url "https://gist.githubusercontent.com/shulima/5ad4c6fbfdfd27048fe8/raw/aff4eaf1c092af50e9b4af46fca352f743bbc9a1/byteswap.patch"
    #   sha256 "e653c59b38cbe2b77cd0271603007db0c2973d00fe666cfbb42732eeade1ca28"
    # end
    # patch do
    #   # Define SOCK_CLOEXEC and SOCK_NONBLOCK
    #   url "https://gist.githubusercontent.com/shulima/3ca0eed701cc27bfbc71/raw/308405bd49188d414caf1198d296d37060c02777/sock_defines.patch"
    #   sha256 "bca242cba0ceb73852007e75f83437d081ae7323790928eb0f0be63de3b33afe"
    # end
    # patch do
    #   # Look up correct extension for ruby libs
    #   url "https://gist.githubusercontent.com/shulima/c42dbaadd26535725666/raw/c86b370ec2797f0e3fe76a96c9852de6e015f586/ruby_dlext.patch"
    #   sha256 "e3ed3c851c5f294bf3ff61aca64be8baff857740a8a7d842097bc9f3e140562a"
    # end
    # patch do
    #   # Add DYLD_LIBRARY_PATH
    #   url "https://gist.githubusercontent.com/shulima/c5fa3de7c84a0352e97e/raw/961e857c4201a82ad05126fbb17bd1f2912f5f43/dyld_library_path.patch"
    #   sha256 "254d9186880cd17cdf478a514b327e372eebaed539df9b172dceb35021265e6c"
    # end
  end

  devel do
    url "http://libguestfs.org/download/1.31-development/libguestfs-1.31.7.tar.gz"
    sha256 "62318ac89baef0dcd3f5bd27996435fd3449878c7e490d3566a4fd40777fa092"

    patch do 
      # Change program_name to avoid collision with gnulib
      url "https://gist.github.com/zchee/2845dac68b8d71b6c1f5/raw/ade1096e057711ab50cf0310ceb9a19e176577d2/libguestfs-gnulib.patch"
      sha256 "b88e85895494d29e3a0f56ef23a90673660b61cc6fdf64ae7e5fecf79546fdd0"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake-1.15" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "truncate" => :build # should this conflict with something?
  # Most dependencies are listed in http://libguestfs.org/README.txt
  depends_on "qemu"
  depends_on "xz"
  depends_on "yajl"
  depends_on "glib"
  depends_on "gettext"
  depends_on "readline"
  depends_on "cdrtools"
  depends_on "augeas"
  depends_on "pcre"
  depends_on :osxfuse

  # Bindings & tools
  depends_on "libvirt" => :optional
  option "with-python", "Build with Python bindings"
  depends_on "python" => :optional
  option "with-java", "Build with Java bindings"
  depends_on :java => :optional
  option "with-perl", "Build with Perl bindings"
  option "with-ruby", "Build with Ruby bindings"
  option "with-php", "Build with PHP bindings"
  # depends_on "go" => :optional
  option "with-go", "Build with Go bindings"

  # Download the precompiled appliance unless explicitly told not to.
  option "without-fixed-appliance", "Not Recommended: Skip downloading the fixed-appliance(supermin kernel)"

  # The two required gnulib patches have been reported to gnulib mailing list, but with little effect so far.
  # patch do
  #   # Add an implementation of open_memstream for BSD/Mac.
  #   # Using Eric Blake's proposal originally published here: https://lists.gnu.org/archive/html/bug-gnulib/2010-04/msg00379.html
  #   # and mentioned again here: http://lists.gnu.org/archive/html/bug-gnulib/2015-02/msg00083.html
  #   url "https://gist.githubusercontent.com/shulima/93138eb342fe94273edd/raw/c75eac3a7f536dca526f52cd8cb5c0d6ce8beecc/gnulib-open_memstream.patch"
  #   sha256 "d62f539def7300e4155bf2447b3c22049938a279957a4a97964d2d04440b58ce"
  # end
  # patch do
  #   # Add a program_name equivalent for Mac.
  #   # http://lists.gnu.org/archive/html/bug-gnulib/2015-02/msg00078.html
  #   url "https://gist.githubusercontent.com/shulima/d851f8f35526db5e2fe9/raw/f80f6a73ec102bbdea2394d9bd3482b400853f2c/gnulib-program_name.patch"
  #   sha256 "d17d1962b98a3418a335915de8a2da219e4598d42c24555bbbc5b0c1177dd38c"
  # end

  # Since we can't build an appliance, the recommended way is to download a fixed one.
  resource "fixed_appliance" do
    url "http://libguestfs.org/download/binaries/appliance/appliance-1.30.1.tar.xz"
    sha256 "12d88227de9921cc40949b1ca7bbfc2f6cd6e685fa6ed2be3f21fdef97661be2"
  end

  def install
    # configure doesn't detect ncurses correctly
    ENV["LIBTINFO_CFLAGS"] = "-I/usr/local/opt/include/ncurses"
    ENV["LIBTINFO_LIBS"] = "-lncurses"

    ENV["FUSE_CFLAGS"] = "-D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/osxfuse/fuse"
    ENV["FUSE_LIBS"] = "-losxfuse -pthread -liconv"

    ENV["AUGEAS_CFLAGS"] = "-I/usr/local/opt/augeas/include"
    ENV["AUGEAS_LIBS"] = "-L/usr/local/opt/augeas/lib"

    args = [
      "--disable-probes",
      "--disable-appliance",
      "--disable-daemon",
      # Not supporting OCaml bindings due to ocamlfind (required) not being packaged in homebrew.
      "--disable-ocaml",
      "--disable-lua",
      "--disable-haskell",
      "--disable-erlang",
      "--disable-gtk-doc-html",
      "--disable-gobject",
    ]

    args << "--without-libvirt" if build.without? "libvirt"
    args << "--disable-php"  if build.without? "php"
    args << "--disable-perl" if build.without? "perl"

    if build.with? "go"
      args << "--enable-golang"
    else
      args << "--disable-golang"
    end

    if build.with? "python"
      ENV.prepend_path "PKG_CONFIG_PATH", `python-config --prefix`.chomp + "/lib/pkgconfig"
      args << "--with-python-installdir=#{lib}/python2.7/site-packages"
    else
      args << "--disable-python"
    end

    if build.with? "ruby"
      # Force ruby bindings to install locally
      ruby_libdir = "#{lib}/ruby/site_ruby/#{RbConfig::CONFIG["ruby_version"]}"
      ruby_archdir = "#{ruby_libdir}/#{RbConfig::CONFIG["sitearch"]}"
      inreplace "ruby/Makefile.am", /\$\(RUBY_LIBDIR\)/, ruby_libdir
      inreplace "ruby/Makefile.am", /\$\(RUBY_ARCHDIR\)/, ruby_archdir
    else
      args << "--disable-ruby"
    end

    if build.with? :java
      args << "--with-java="+`#{Language::Java.java_home_cmd}`.chomp
    end

    if build.with? "go"
      inreplace "golang/Makefile.am", %r{^(golangpkgdir = )(.*)(GOROOT.*)(/pkg/.*)$}, "\\1#{lib}/golang\\4"
      inreplace "golang/Makefile.am", %r{^(golangsrcdir = )(.*)(GOROOT.*)(/src/)(pkg/)(\$\(pkg\).*)$}, "\\1#{lib}/golang\\4\\6"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          *args

    # ENV.deparallelize

    # Build fails with just 'make install'
    system "make"

    if build.with? "php"
      # Put php bindings inside our lib
      inreplace "php/extension/Makefile", %r{^(EXTENSION_DIR = )(.*)(/php/.*)$}, "\\1#{lib}\\3"
    end

    ENV["REALLY_INSTALL"] = "yes"
    system "make", "install"

    if build.with? "go"
      # Fix maked go files permission
      # FileUtils.chmod_R "+w", "#{lib}/golang/src/libguestfs.org/guestfs"
      # Fix not according Go fmt guideline
      # system "gofmt", "-w", "#{lib}/golang/src/libguestfs.org/guestfs"
      # Symlink $GOPATH instead $GOROOT
      # TODO brew do not parse $GOROOT and $GOPATH
      # (lib/"golang/pkg").install "#{ENV["GOPATH"]}/pkg"
      # (lib/"golang/src").install "#{ENV["GOPATH"]}/src"
    end

    if build.with? "fixed-appliance"
      libguestfs_path = "#{prefix}/var/libguestfs-appliance"
      mkdir_p libguestfs_path
      resource("fixed_appliance").stage(libguestfs_path)
      # why tf can't homebrew create /usr/local/lib/guestfs here?
    end
    #    amar edits: move this to a different dir?
#    Error: An exception occurred within a child process:
#       Errno::EPERM: Operation not permitted @ dir_s_mkdir - /usr/local/lib/guestfs
#    if build.with? "fixed-appliance"
#      # The appliance doesn't change, and we don't want to copy 4GB for each new version
#      # appliance_dir = "#{prefix}/var/appliance"
#      # mkdir_p appliance_dir
#      libguestfs_path = "/usr/local/lib/guestfs"
#      mkdir_p libguestfs_path
#      resource("fixed_appliance").stage(libguestfs_path)
#      # (prefix/"var/appliance").install "/usr/local/lib/guestfs"
#      # mkdir_p libguestfs_path
#      # mkdir_p appliance_dir
#    end

    # installation into /usr/local/bin
    #for f in "#{prefix}/opt/libguestfs-latest" do
    #bin.install Dir["#{prefix}/opt/libguestfs-latest/bin/*"]
    bin.install_symlink Dir["bin/*"]
  end

  def caveats
      # fix appliance path here
    <<~EOS
      A fixed appliance is required for libguestfs to work on Mac OS X.
      Unless you choose to build --without-fixed-appliance, it's downloaded for
      you and placed in the following path:
      #{HOMEBREW_PREFIX}/var/libguestfs-appliance

      To use the appliance, add the following to your shell configuration:
      export LIBGUESTFS_PATH=#{HOMEBREW_PREFIX}/var/libguestfs-appliance
      and use libguestfs binaries in the normal way.

    EOS
  end

  test do
    ENV["LIBGUESTFS_PATH"] = "#{var}appliance"
    system "#{bin}/libguestfs-test-tool", "-t 180"
  end
end
