class LibguestfsAT136 < Formula
  homepage "http://libguestfs.org/"

  stable do
    url "http://libguestfs.org/download/1.36-stable/libguestfs-1.36.15.tar.gz"
    sha256 "63f0c53a9e79801f4e74254e5b1f6450febb452aeb395d8d3d90f816cd8058ec"

    patch do
      # Change program_name to avoid collision with gnulib
	  url "https://gist.githubusercontent.com/Amar1729/541e66dff14fec0100931b64f78b8f38/raw/b543e5ee87c76c6a5dadc478ea272e141ee67665/libguestfs-gnulib.patch"
      sha256 "a83b5330b58e5a3c386548558580b421971b4eb1a2c6ed60eee5a8f967d39a41"
    end
    patch do
	  # Fix rpc/xdr.h includes (on macOS, include rpc/types.h first)
	  url "https://gist.githubusercontent.com/Amar1729/1a9cf7f3e4d7ea598676405fbf81a609/raw/502be6eeeedfa8134a97c75659f74d709a133866/rpc-xdr.patch"
      sha256 "5c649da91f969126929c4cc90ed17d08cd0d5990c79eb214aa3c8a061eb2ab89"
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

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # macOS bison is one minor revision too old
  depends_on "gnu-sed" => :build # some of the makefiles expect gnu sed functionality
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "truncate" => :build # shouldn't this conflict with something?
  depends_on "augeas"
  depends_on "cdrtools"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "qemu"
  depends_on "readline"
  depends_on "xz"
  depends_on "yajl"
  depends_on :osxfuse

  # Since we can't build an appliance, the recommended way is to download a fixed one.
  resource "fixed_appliance" do
    url "http://download.libguestfs.org/binaries/appliance/appliance-1.36.1.tar.xz"
    sha256 "45040a9dacf597870108fde0ac395f340d2469bf3cee2d1f2cc1bcfb46c89bce"
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
      "--disable-ocaml",
      "--disable-lua",
      "--disable-haskell",
      "--disable-erlang",
      "--disable-gtk-doc-html",
      "--disable-gobject",
	  # libvirt fails (error.h issues from gnulib on this version)
      "--without-libvirt",
      "--disable-php",
      "--disable-perl",
	  "--disable-golang",
      "--disable-python",
      "--disable-ruby",
    ]

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          *args

    # Build fails with just 'make install'
	# fix for known race condition: https://bugzilla.redhat.com/show_bug.cgi?id=1614502
	system "make", "-j1", "-C", "builder", "index-parse.c"
	system "make", "-C", "builder", "index-scan.c"
    system "make"

    ENV["REALLY_INSTALL"] = "yes"
    system "make", "install"

    libguestfs_path = "#{prefix}/var/libguestfs-appliance"
    mkdir_p libguestfs_path
    resource("fixed_appliance").stage(libguestfs_path)

    bin.install_symlink Dir["bin/*"]
  end

  def caveats
    <<~EOS
      A fixed appliance is required for libguestfs to work on Mac OS X.
      This formula downloads the appliance and places it in:
        #{prefix}/var/libguestfs-appliance

      To use the appliance, add the following to your shell configuration:
        export LIBGUESTFS_PATH=#{prefix}/var/libguestfs-appliance
      and use libguestfs binaries in the normal way.

      For compilers to find libguestfs you may need to set:
        export LDFLAGS="-L/usr/local/opt/libguestfs@1.36/lib"
        export CPPFLAGS="-I/usr/local/opt/libguestfs@1.36/include"

      For pkg-config to find libguestfs you may need to set:
        export PKG_CONFIG_PATH="/usr/local/opt/libguestfs@1.36/lib/pkgconfig"

    EOS
  end

  test do
    ENV["LIBGUESTFS_PATH"] = "#{prefix}/var/libguestfs-appliance"
    system "#{prefix}/bin/libguestfs-test-tool", "-t 180"
  end
end
