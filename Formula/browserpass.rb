class Browserpass < Formula
  desc "Host application for browser extension providing access to your password store"
  homepage "https://github.com/browserpass/browserpass-native"
  url "https://github.com/browserpass/browserpass-native/releases/download/3.0.7/browserpass-darwin64-3.0.7.tar.gz"
  sha256 "97b9a9068a3c88fb1d52d42a1712e199da5865a4c6f8352b9fe3eae1ee86c746"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/browserpass-3.0.7"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina: "232e182d192f95f769ff74c9d441e2dd8229c55cf77e120c43ff97e133cb9afb"
  end

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "gpg"
  depends_on "pinentry"
  depends_on "pinentry-mac"

  resource "testfile" do
    url "https://github.com/browserpass/browserpass-native/files/3062744/request.hex.txt"
    sha256 "83ea960015e5bd05e604c13233d8ed16a87c38f83212822e8d69c622dea21af0"
  end

  def install
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix.to_s

    inreplace "Makefile", "BIN ?= browserpass", "BIN ?= browserpass-darwin64"
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

      $ PREFIX='#{prefix}' make hosts-BROWSER-user -f '#{prefix}/lib/browserpass/Makefile'

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
