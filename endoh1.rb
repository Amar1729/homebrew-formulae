class Endoh1 < Formula
  desc "Fluid simulator using “Smoothed-particle hydrodynamics (SPH)” method"
  homepage "https://www.ioccc.org/2012/endoh1/hint.html"
  url "https://www.ioccc.org/2012/endoh1/endoh1.c"
  version "1.0"
  sha256 "de593a8af39ec73e120bacecae2a09bc9858da6457894840f2f816513cc18fb4"
  revision 1

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/endoh1-1.0_1"
    sha256 cellar: :any_skip_relocation, catalina:     "7a27545f10053cb885506c47f5f2d2146a0aaf6616f12fb559fd63c0c132aae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec54a600b2e9bef3d5e137f00d0c5fc5f84396fbe1aa57db2f9f32ecfa5154c8"
  end

  # color variant
  resource "color" do
    url "https://www.ioccc.org/2012/endoh1/endoh1_color.c"
    sha256 "725130103b3239febbf02207e0d4776b5748f603758110e0292e554e81154629"
  end

  # ~manpage
  resource "hint" do
    url "https://www.ioccc.org/2012/endoh1/hint.text"
    sha256 "63bb09da581652d2047ce00e4509136857afe6b94706dacfc1f752740d8b2eaf"
  end

  # examples
  # ----
  resource "column" do
    url "https://www.ioccc.org/2012/endoh1/column.txt"
    sha256 "2b9a6fce952540ddf7d2851401d88cb1d2eb2a3beebad5f4e4d3cc75f9a04df2"
  end

  resource "column2" do
    url "https://www.ioccc.org/2012/endoh1/column2.txt"
    sha256 "dfda0eb411ff450a89fa4d6b3b95415f4df2928b91ffd70de4f1cc46df8b2d34"
  end

  resource "column3" do
    url "https://www.ioccc.org/2012/endoh1/column3.txt"
    sha256 "f183a344199172fbe13d62ddb3edab61259795f75b046132b8ef41ba912fddee"
  end

  resource "corners" do
    url "https://www.ioccc.org/2012/endoh1/corners.txt"
    sha256 "a29ff6062578024355c636a2cbb713894c173a0fb16a2e4c3f1f104548d3ab60"
  end

  resource "dripping-pan" do
    url "https://www.ioccc.org/2012/endoh1/dripping-pan.txt"
    sha256 "2ee62b7a9201860c370239210a2f042c09fc39761f22f24f55f272dc7c66278a"
  end

  resource "evaporation" do
    url "https://www.ioccc.org/2012/endoh1/evaporation.txt"
    sha256 "89a7ed18cdebd141786f4b110415044f8a5f1361e9ea13ff9603eae70072670b"
  end

  resource "flat" do
    url "https://www.ioccc.org/2012/endoh1/flat.txt"
    sha256 "274fab4bda0d632e8eea544b210c646f0593d8cedbdb70be9465cb79d8b5abed"
  end

  resource "fountain" do
    url "https://www.ioccc.org/2012/endoh1/fountain.txt"
    sha256 "d7928a9cccd450c067a966fbaf11be13902dd5e116a65cf376ddf21e4b98dd59"
  end

  resource "funnel" do
    url "https://www.ioccc.org/2012/endoh1/funnel.txt"
    sha256 "3e3f1326328c2998616e30d7cd118ac10771d0629e1bebe0c8ef79b2fc26d988"
  end

  resource "funnel2" do
    url "https://www.ioccc.org/2012/endoh1/funnel2.txt"
    sha256 "98b27ced9209a8b9cfa8cd460f5714b35e00a0c8636a6583816b6dedb2c1b165"
  end

  resource "funnel3" do
    url "https://www.ioccc.org/2012/endoh1/funnel3.txt"
    sha256 "d09b27cbf66d67f37fdef75122183a34d2b58ff78be71ab8d2320804e622cefa"
  end

  resource "leidenfrost" do
    url "https://www.ioccc.org/2012/endoh1/leidenfrost.txt"
    sha256 "2b675f09f2af1c14626de90731628882b3d72551ab066f867acdaa7635715cb1"
  end

  resource "logo" do
    url "https://www.ioccc.org/2012/endoh1/logo.txt"
    sha256 "bf689c4933481301e1e000d505e2d75d0206edc84feb51d1760ff406200426d2"
  end

  resource "pour-out" do
    url "https://www.ioccc.org/2012/endoh1/pour-out.txt"
    sha256 "d247ee029c6c834ae40779a14ebb6add7f76b0643e3c3585bfbd3d829cfa13c4"
  end

  resource "tanada" do
    url "https://www.ioccc.org/2012/endoh1/tanada.txt"
    sha256 "99d34e6f91c5e9be71434a27057d620ad55ee39910eed0c4aed093b3a542af96"
  end
  # ----

  def install
    resources.each { |f| f.stage(buildpath) }

    cflags = %w[
      -DG=1
      -DP=4
      -DV=8
      -D_BSD_SOURCE
      -lm
    ]

    system ENV.cc.to_s, "endoh1.c", "-o", "endoh1", *cflags
    system ENV.cc.to_s, "endoh1_color.c", "-o", "endoh1-color", *cflags

    bin.install "endoh1"
    bin.install "endoh1-color"
    man1.install "hint.text" => "endoh1.1"

    (libexec/"examples").mkpath
    (libexec/"examples").install Dir["*txt"]
  end

  def caveats
    <<~EOS
      #{"      "}
                  First of all, the source code itself serves as an initial configuration. Preprocessing directives (such as #include)’s # serve as walls.
      #{"      "}
                  Examples have been installed to #{prefix}/libexec/examples.
            #{"      "}
                  note: this is my own formula for Yusuke Endoh's work. Check out the intro video:
                  https://www.youtube.com/watch?v=QMYfkOtYYlg
      #{"      "}
                  or his github:
                  https://github.com/mame/
      #{"      "}
    EOS
  end

  test do
    system "true"
  end
end
