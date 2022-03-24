class Showkey < Formula
  desc "Simple keystroke visualizer"
  homepage "http://catb.org/esr/showkey/"
  url "http://www.catb.org/~esr/showkey/showkey-1.8.tar.gz"
  sha256 "31b6b064976a34d7d8e7a254db0397ba2dc50f1bb6e283038b17c48a358d50d3"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/showkey-1.8"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "e1b7980ab01590c9f2b8190e71514e1969ab892348aa96bee6f970d4f1eb42a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a4118dba2b3f0c64a2812401c7844f932d7ae5b4ef9ab6d3069b4549f4c12ad"
  end

  patch :DATA

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "true"
  end
end

__END__
diff --git a/Makefile b/Makefile
index fcdea61..b3736e7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,7 @@
 # showkey -- keystroke echoer
 
+PREFIX=/usr
+
 VERS=1.8
 
 showkey: showkey.c
@@ -19,12 +21,14 @@ splint:
 	splint +posixlib +charintliteral +charint showkey.c
 
 install: showkey.1
-	cp showkey /usr/bin/showkey
-	cp showkey.1 /usr/share/man/man1
+	mkdir -p $(DESTDIR)$(PREFIX)/bin
+	cp showkey $(DESTDIR)$(PREFIX)/bin/showkey
+	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
+	cp showkey.1 $(DESTDIR)$(PREFIX)/share/man/man1
 
 uninstall:
-	rm /usr/bin/showkey
-	rm /usr/share/man/man1/showkey.1
+	rm $(DESTDIR)$(PREFIX)/bin/showkey
+	rm $(DESTDIR)$(PREFIX)/share/man/man1/showkey.1
 
 SOURCES = README COPYING NEWS control Makefile showkey.c showkey.xml
 

