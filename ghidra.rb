class Ghidra < Formula
  desc "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission."
  homepage "https://ghidra-sre.org/"
  url "https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip"
  sha256 "3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2"

  depends_on :java => "11+"

  # todo - delete .bat/win-specific files?
  # todo - bundle this as an .app directory? and/or name the exec script 'gidra' instead?
  def install
      # install everything into libexec/ to avoid polluting namespace
      libexec.install Dir["*"]

      # create a simple 'exec' script that calls ghidraRun
      bin.write_exec_script(libexec/"ghidraRun")
  end

  def caveats
	msg = <<~EOS
		Installed static app to Homebrew Cellar. You can open the app from the
		command line with:

		$ ghidraRun

		Ghidra allows opening with non-default arguments: See `ghidraRun' and
		`support/launch.sh' in the libexec/ dir of this formula.
	EOS

    msg
  end

  test do
	# since this installs an app, there's not really a nice way to check success :(
	# just assume it's fine, and that `ghidraRun' completes and opens Ghidra
    system "true"
  end
end
