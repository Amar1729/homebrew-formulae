class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.17.0",
      :revision => "99464c01da5809e7159ed1a75ef10f60d34506a4"
  revision 1

  bottle do
    cellar :any
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/infer-0.17.0_1"
    sha256 "2cb80680224d361556c559a9f4c7d5efe9fd2037c41f7bbb86fb9d8b6ef7725c" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "fb-clang" => :build
  depends_on :java => ["1.8+", :build, :test]
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"
  depends_on "sqlite"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib/"pkgconfig"

    opamroot = libexec/"opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # explicitly build the clang before infer's configure
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --with-fcp-clang"

    # use (prebuilt) fb-clang
    ENV["CLANG_PREFIX"] = Formula["fb-clang"].opt_prefix.to_s
    system "facebook-clang-plugins/clang/setup.sh", "-r"
    system "ln", "-s", ENV["CLANG_PREFIX"], "./facebook-clang-plugins/clang/install"

    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "@IS_RELEASE_TREE@", "yes"

    # setup opam (disable opam sandboxing, since it will otherwise fail inside homebrew sandbox)
    # disabling sandboxing inside a sandboxed environment is necessary as of opam 2.0
    inreplace "build-infer.sh", "--no-setup", "--no-setup --disable-sandboxing"
    # prefer system bins configuring opam dependency mlgmpidl (needs to use system clang+ranlib+libtool)
    # if some homebrew versions of these mix with system tools, it can break compilation
    inreplace "build-infer.sh", "opam install", "PATH=/usr/bin:$PATH\n    opam install"

    pathfix_lines = [
      "export SDKROOT=#{MacOS.sdk_path}",
      "eval $(opam env)",
    ]

    # need to set sdkroot for clang to see certain system headers
    inreplace "build-infer.sh", "./configure $INFER_CONFIGURE_OPTS",
        pathfix_lines.join("\n") + "\n./configure $INFER_CONFIGURE_OPTS"

    system "./build-infer.sh", "all", "--yes"
    system "opam", "config", "exec", "--", "make", "install"

    # opam switches contain lots of files for end-user usage
    # much can be removed if all we need is a package
    opam_switch = File.read("build-infer.sh").match(/INFER_OPAM_DEFAULT_SWITCH=\"([^\"]+)\"/)[1]
    cd libexec/"opam" do
      # remove everything but the opam switch used for infer
      rm_rf Dir["*"] - [opam_switch.to_s]

      # remove everything in the switch but the dylibs infer needs during runtime
      cd opam_switch.to_s do
        rm_rf Dir["*"] - ["share"]

        cd "share" do
          rm_rf Dir["*"] - ["apron", "elina"]
        end
      end
    end
  end

  test do
    shell_output("javac -version")
    shell_output("which javac")
    (testpath/"FailingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c")

    (testpath/"FailingTest.java").write <<~EOS
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<~EOS
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java")
    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
  end
end
