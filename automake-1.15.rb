class Automake115 < Formula
  # note: can't use AT (standard for homebrew versions?) because this is a perl script,
  # so it will attempt to interpolate the '@' in the filename when used as a string
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  #url "https://ftp.gnu.org/gnu/automake/automake-1.16.1.tar.xz"
  url "https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.xz"
  #sha256 "5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921"
  sha256 "af6ba39142220687c500f79b4aa2f181d9b24e4f8d8ec497cea4ba26c64bedaf"

  conflicts_with "automake"

  depends_on "autoconf"

  ## https://lists.gnu.org/archive/html/bug-automake/2018-04/msg00002.html
  ## Remove this when applying any future 1.16.2 update.
  #patch do
  #  url "https://git.savannah.gnu.org/cgit/automake.git/patch/?id=a348d830659fffd2cfc42994524783b07e69b4b5"
  #  sha256 "7a57ca2b91f7f3c0b168cf5ffbc8a1b2168f3886bcadcc15412281472dace3ce"
  #end

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
