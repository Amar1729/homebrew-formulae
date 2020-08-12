class Browserpass < Formula
  version "3.0.7"
  desc "This is a host application for browserpass browser extension providing it access to your password store."
  homepage "https://github.com/browserpass/browserpass-native"
  url "https://github.com/browserpass/browserpass-native/releases/download/#{version}/browserpass-darwin64-#{version}.tar.gz"
  sha256 "97b9a9068a3c88fb1d52d42a1712e199da5865a4c6f8352b9fe3eae1ee86c746"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/browserpass-3.0.7"
    cellar :any_skip_relocation
    sha256 "0d1b3c9497047ee387e154df75da8d90af9327b80af35391aeb02811c01d6e7a" => :catalina
  end

  resource "testfile" do
    url "https://github.com/browserpass/browserpass-native/files/3062744/request.hex.txt"
    sha256 "83ea960015e5bd05e604c13233d8ed16a87c38f83212822e8d69c622dea21af0"
  end

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "gpg"
  depends_on "pinentry"
  depends_on "pinentry-mac"

  def install
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix.to_s

    inreplace "Makefile", "BIN = browserpass", "BIN = browserpass-darwin64"
    system "make", "configure"
    system "make", "install"

    # NOT possible to symlink the hosts files from a homebrew formula, since they go under HOME
    # Unfortunately, need to have the user do them manually
    # (same with policies, if the user wants them)
  end

  def caveats
    <<~EOF
  ********************************************************************************
  * To configure your browser, RUN THE FOLLOWING:

  $ PREFIX='/usr/local/opt/browserpass' make hosts-BROWSER-user -f /usr/local/opt/browserpass/lib/browserpass/Makefile

  * Where BROWSER is one of the following: [chromium chrome vivaldi brave firefox]
  ********************************************************************************
    EOF
  end

  test do
    resource("testfile").stage(testpath)
    # fails with 14: $HOME/.password-store doesn't exist, since homebrew uses its own $HOME
    # a return value other than 14 is incorrect here
    shell_output("#{prefix}/bin/browserpass-darwin64 < #{testpath}/request.hex.txt 2>/dev/null", 14)
  end
end
