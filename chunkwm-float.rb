class ChunkwmFloat < Formula
  desc "Chunkwm plugin for better management of floating windows"
  homepage "https://github.com/amar1729/chunkwm-float"
  head "https://github.com/amar1729/chunkwm-float.git"

  depends_on :macos => :el_capitan
  depends_on "chunkwm" => :build

  def install
    cd buildpath/"src" do
      system "make"
    end
    (pkgshare/"plugins").install "#{buildpath}/bin/float.so"
  end

  def caveats; <<~EOS
    The plugins install folder is #{opt_pkgshare}/plugins.

    Unfortunately since formulas are standalone in brew, we cannot just use chunkwm
    standard plugin dir.

    Because of this, the plugin needs to be symlinked to the chunkwm plugin folder:
      ln -sf #{opt_pkgshare}/plugins/float.so #{Formula["chunkwm"].opt_pkgshare}/plugins/float.so

    To activate the plugin, edit your ~/.chunkwmrc and add this load line:
      chunkc core::load float.so

    Given the dependency on chunkwm headers to build this plugin, the formula is HEAD only.
    EOS
  end
end
