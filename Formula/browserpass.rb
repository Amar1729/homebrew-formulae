class Browserpass < Formula
  desc "Host application for browser extension providing access to your password store"
  homepage "https://github.com/browserpass/browserpass-native"
  url "https://github.com/browserpass/browserpass-native/archive/refs/tags/3.1.0.tar.gz"
  sha256 "df90e9a02faa0081fe8bce78a8ecef1e4394f642955f18f452ee0079be85816e"

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "go" => :build
  depends_on "gpg"
  depends_on "pinentry"

  on_macos do
    depends_on "pinentry-mac"
  end

  resource "testfile" do
    url "https://github.com/browserpass/browserpass-native/files/3062744/request.hex.txt"
    sha256 "83ea960015e5bd05e604c13233d8ed16a87c38f83212822e8d69c622dea21af0"
  end

  def install
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix.to_s

    system "make", "configure"
    system "make"
    system "make", "install"

    # NOT possible to symlink the hosts files from a homebrew formula, since they go under HOME
    # Unfortunately, need to have the user do them manually
    # (same with policies, if the user wants them)
  end

  def caveats
    <<~EOF
      ********************************************************************************
      * To configure your browser, RUN THE FOLLOWING:

      $ PREFIX='#{prefix}' make hosts-BROWSER-user -f '#{prefix}/lib/browserpass/Makefile'

      * Where BROWSER is one of the following: [chromium chrome vivaldi brave firefox]
      ********************************************************************************
    EOF
  end

  test do
    resource("testfile").stage(testpath)
    # fails with 14: $HOME/.password-store doesn't exist, since homebrew uses its own $HOME
    # a return value other than 14 is incorrect here
    shell_output("#{prefix}/bin/browserpass < #{testpath}/request.hex.txt 2>/dev/null", 14)
  end
end
