class PinentryPreferTty < Formula
  desc "Prefer the tty when using pinentry, fallback to GUI"
  homepage "https://gist.github.com/Amar1729/18cbcf7e78b84e4097ee6b1c56b65b6f"
  url "https://gist.githubusercontent.com/Amar1729/18cbcf7e78b84e4097ee6b1c56b65b6f/raw/#{version}/pinentry-prefer-tty"
  version "ac127e57451a67e6ed9740857fbbd6f742534a99"
  sha256 "6c6d4794a1163b231e7c08e4ef20d470cd33717c6cc29bf88ff0a2d1d7ef7468"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/pinentry-prefer-tty-ac127e57451a67e6ed9740857fbbd6f742534a99"
    sha256 cellar: :any_skip_relocation, catalina: "463313f25a6dc516c28664552686c6ae95c7b54b0b31ff7461baf0513ff7e06f"
  end

  depends_on "pinentry"
  depends_on "pinentry-mac"

  def install
    bin.install "pinentry-prefer-tty"
    inreplace bin/"pinentry-prefer-tty", "/usr/bin/pinentry-curses", "#{Formula["pinentry"].opt_bin}/pinentry-curses"
    inreplace bin/"pinentry-prefer-tty", "/usr/bin/pinentry-mac", "#{Formula["pinentry-mac"].opt_bin}/pinentry-mac"
  end
end
