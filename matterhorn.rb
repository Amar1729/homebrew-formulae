class Matterhorn < Formula
  desc "Unix terminal client for the Mattermost chat system"
  homepage "https://github.com/matterhorn-chat/matterhorn"
  url "https://github.com/matterhorn-chat/matterhorn/releases/download/50200.1.1/matterhorn-50200.1.1-Darwin-x86_64.tar.bz2"
  sha256 "3ae6a19ecd47eeddb303970e77d5fd5379a64eda3c9b430ec80c6fd6a6429705"

  def install
    bin.install "matterhorn"
  end

  test do
    system "#{bin}matterhorn", "--version"
  end
end
