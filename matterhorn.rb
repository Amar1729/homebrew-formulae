class Matterhorn < Formula
  desc "Unix terminal client for the Mattermost chat system"
  homepage "https://github.com/matterhorn-chat/matterhorn"
  version = "50200.5.0"
  url "https://github.com/matterhorn-chat/matterhorn/releases/download/#{version}/matterhorn-#{version}-Darwin-x86_64.tar.bz2"
  sha256 "c91af30caf00e39ad65851f07e9e6fd7036ba460032af5477c143dbcde642827"

  resource "sample_config" do
    url "https://raw.githubusercontent.com/matterhorn-chat/matterhorn/524c6439b4f9b2a423e07781098afec00081cc49/sample-config.ini"
    sha256 "8caacab8b328aaf8f39f33df57fb227a4a972872fed77915dbf85edd0d23fb2e"
  end

  def install
    bin.install "matterhorn"

    cfg_path = "#{prefix}/etc"
    mkdir_p cfg_path
    resource("sample_config").stage(cfg_path)
  end

  def caveats; <<~EOS
	Sample configuration file staged:
	  cp #{prefix}/etc/sample-config.ini ~/.config/matterhorn/config.ini
    EOS
  end

  test do
    system "#{bin}matterhorn", "--version"
  end
end
