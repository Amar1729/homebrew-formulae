class Jobq < Formula
  desc "Simple job queueing system in bash"
  homepage "https://github.com/Amar1729/jobq/"
  head "https://github.com/Amar1729/jobq.git"

  bottle :unneeded

  def install
      bin.install "jobq"
  end
end
