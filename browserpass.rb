class Browserpass < Formula
  version "3.0.5"
  desc "This is a host application for browserpass browser extension providing it access to your password store."
  homepage "https://github.com/browserpass/browserpass-native"
  url "https://github.com/browserpass/browserpass-native/releases/download/#{version}/browserpass-darwin64-#{version}.tar.gz"
  sha256 "d62c63cfcd7f0d69d0c603362e7fb3882784a97ec694f6d269766533e12d45fb"

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
      Due to homebrew formula limitations, this tap only installs the native binary.
         To install nativemessaginghost bindings for your browser, run the following:
      $ cd /usr/local/opt/browserpass/lib/browserpass
      $ DESTDIR='' PREFIX='/usr/local/opt/browserpass' make hosts-BROWSER-user
         Where BROWSER is one of the following:
      [chromium chrome vivaldi brave firefox]
         NOTE: This tap DOES NOT install the browser extension automatically.
      You should go to the browser and manually install the extension there.
    EOF
  end

  test do
    resource("testfile").stage(testpath)
    # fails with 14: $HOME/.password-store doesn't exist, since homebrew uses its own $HOME
    # a return value other than 14 is incorrect here
    shell_output("#{prefix}/bin/browserpass-darwin64 < #{testpath}/request.hex.txt 2>/dev/null", 14)
  end
end
