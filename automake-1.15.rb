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

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/automake-1.15"
    cellar :any_skip_relocation
    sha256 "f81060a0b15b6846e6540bd489381eb644bf313f89000705f5ac33ce26157acf" => :mojave
  end

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
