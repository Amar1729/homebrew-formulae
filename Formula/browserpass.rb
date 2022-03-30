class Browserpass < Formula
  desc "Host application for browser extension providing access to your password store"
  homepage "https://github.com/browserpass/browserpass-native"
  version = "3.0.9"

  if Hardware::CPU.arm?
    url "https://github.com/browserpass/browserpass-native/releases/download/#{version}/browserpass-darwin-arm64-#{version}.tar.gz"
    sha256 "f0a21c7610fb9c68a2f1b8aa8c4116678a2318e61b0b60067d79b5b23bcd4502"
  else
    url "https://github.com/browserpass/browserpass-native/releases/download/#{version}/browserpass-darwin64-#{version}.tar.gz"
    sha256 "a4bd59a0d2fe74dfb16cca8d47011415eaa19d5da39a8c60ac948a491cfa7214"
  end

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/browserpass-3.0.8"
    sha256 cellar: :any_skip_relocation, big_sur: "cb6a4b25ba168a94a6984a70e4d4ee89e0a9af09ff7dede4fffbb76e52fa6a13"
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

    if Hardware::CPU.arm?
      inreplace "Makefile", "BIN ?= browserpass", "BIN ?= browserpass-darwin-arm64"
    else
      inreplace "Makefile", "BIN ?= browserpass", "BIN ?= browserpass-darwin64"
    end
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
    if Hardware::CPU.arm?
      shell_output("#{prefix}/bin/browserpass-darwin-arm64 < #{testpath}/request.hex.txt 2>/dev/null", 14)
    else
      shell_output("#{prefix}/bin/browserpass-darwin64 < #{testpath}/request.hex.txt 2>/dev/null", 14)
    end
  end
end
