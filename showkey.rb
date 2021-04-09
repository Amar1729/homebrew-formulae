class Showkey < Formula
  desc "Simple keystroke visualizer"
  homepage "http://catb.org/esr/showkey/"
  url "http://www.catb.org/~esr/showkey/showkey-#{version}.tar.gz"
  version "1.8"
  sha256 "31b6b064976a34d7d8e7a254db0397ba2dc50f1bb6e283038b17c48a358d50d3"

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
 

