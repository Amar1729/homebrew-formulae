# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Weather < Formula
  desc ""
  homepage ""
  url "https://github.com/Amar1729/weather/raw/master/archive/weather-1.0.0.tar.gz"
  sha256 "de9a42adad1cab69600c389f109dd84c4f90062819f50238960ce107babf3ae8"
  # depends_on "cmake" => :build
  
  bottle :unneeded

  option "without-completions", "Do not install completions."

  def install
      bin.install "weather.sh" => weather

    if build.with? "completions"
        zsh_completion.install "completions/_weather"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test master`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
