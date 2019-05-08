class Browserpass < Formula
  version "3.0.6"
  desc "This is a host application for browserpass browser extension providing it access to your password store."
  homepage "https://github.com/browserpass/browserpass-native"
  url "https://github.com/browserpass/browserpass-native/releases/download/#{version}/browserpass-darwin64-#{version}.tar.gz"
  sha256 "422bc6dd1270a877af6ac7801a75b4c4b57171d675c071470f31bc24196701e3"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/browserpass-3.0.6"
    cellar :any_skip_relocation
    sha256 "31b2faf15a7f2ba64897a4d741876c6d2b09ac9e309fa9cb2da230c1a0352506" => :mojave
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
    ENV["BIN"] = "browserpass-darwin64"

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
