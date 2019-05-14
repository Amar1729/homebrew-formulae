class XiMac < Formula
  desc "The xi editor mac frontend"
  homepage "https://github.com/xi-editor/xi-mac"
  head "https://github.com/xi-editor/xi-mac.git"

  depends_on "rust"

  def install
    system "xcodebuild"

    libexec.install Dir["build/Release/*"]
    bin.install_symlink "#{libexec}/XiCli" => "xi"
  end

  def caveats
    <<~EOS
      This editor is very much in alpha.
      There may be numerous issues with it.
      See https://github.com/xi-editor/xi-mac/issues/82
        for upstream discussion on providing a package for xi-mac

      I WILL NOT fix any issues with this package or provide a bottle as it's just for personal use.
    EOS
  end

  test do
    system "xi", "--help"
  end
end
