class FbClang701 < Formula
  desc "facebook clang plugins"
  version = "7.0.1"
  url "https://github.com/facebook/facebook-clang-plugins/raw/master/clang/src/llvm_clang_compiler-rt_libcxx_libcxxabi_openmp-#{version}.tar.xz"
  sha256 "1372c12adfa8347a800adfaf9fbfb9b7748ea0c794df82bfd06f6771c6ae8819"

  bottle do
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/fb-clang-v7.0.1"
    cellar :any
    sha256 "b80e6a46ac77fb8a48709a1478c724c407a824a8cb4c923d14337f8bf03ce385" => :mojave
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "gmp" => :build
  depends_on "libtool" => :build
  depends_on "mpfr" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "sqlite" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build

  keg_only :provided_by_macos, "Conflicts with system clang"

  # use specific tag, though patches change infrequently
  tag = "36266f6c86041896bed32ffec0637fefbc4463e0"

  patch :p2 do
    url "https://github.com/facebook/facebook-clang-plugins/raw/#{tag}/clang/src/err_ret_local_block.patch"
    sha256 "2f6f4a492f7cdf9ceb5745d9b72e0073f608506528314aa0dddc6e789f870897"
  end

  patch :p2 do
    url "https://github.com/facebook/facebook-clang-plugins/raw/#{tag}/clang/src/mangle_suppress_errors.patch"
    sha256 "7330688109735c68e274edecaabeb5d28d38f58d60bbe4add01827a9af16dbd7"
  end

  resource "attr_dump_cpu_cases_compilation_fix" do
    url "https://github.com/facebook/facebook-clang-plugins/raw/#{tag}/clang/src/attr_dump_cpu_cases_compilation_fix.patch"
    sha256 "a559df5f789f4166008cb63f301606f2b5075f4de9e6f22a51615c6d0c8706de"
  end

  resource "opam" do
    url "https://github.com/facebook/infer/raw/v0.16.0/opam"
    sha256 "bcc8b1f858d907a728e5149de675ac73b0a1b42775e3f6bcd598029c0b148499"
  end

  resource "opam.locked" do
    url "https://github.com/facebook/infer/raw/v0.16.0/opam.locked"
    sha256 "f17930bacd2a97713520e88eea1c39c29131ae9f5bce4b8a2d8234c43edfbeb1"
  end

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    resources.each { |r| r.stage(buildpath) }

    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/opt/sqlite3/lib/pkgconfig"

    # clang doesn't need opam deps after build (?)
    opamroot = HOMEBREW_CACHE/"opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # hardcoded: infer 0.16.0
    ocaml_version = "ocaml-variants.4.07.1+flambda"

    # infer 0.16.0: mlgmpidl_version = 1.2.7
    mlgmpidl_version = File.read("opam.locked").match(/mlgmpidl\".+\"(.+)\"/)[1]
    # infer 0.16.0: ocamlbuild_version = 0.12.0
    ocamlbuild_version = File.read("opam.locked").match(/\"ocamlbuild\".+\"(.+)\"/)[1]

    begin
      # setup opam (disable opam sandboxing because homebrew is sandboxed already)
      system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing"
      system "opam", "switch", "create", ocaml_version.to_s
    rescue
      ENV["OPAMSWITCH"] = ocaml_version.to_s
    end

    system "opam", "install", "ocamlbuild=#{ocamlbuild_version}"
    original_path = ENV["PATH"]
    ENV["PATH"] = "/usr/bin:" + ENV["PATH"]
    system "opam", "install", "mlgmpidl=#{mlgmpidl_version}"
    ENV["PATH"] = original_path
    system "opam", "install", "--deps-only", "infer", buildpath, "--locked"

    llvm_args = %W[
      -DCMAKE_C_FLAGS=#{ENV.cflags}
      -DCMAKE_CXX_FLAGS=#{ENV.cppflags}
      -DLLVM_ENABLE_ASSERTIONS=Off
      -DLLVM_ENABLE_EH=On
      -DLLVM_ENABLE_RTTI=On
      -DLLVM_INCLUDE_DOCS=Off
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=On

      -DLLVM_ENABLE_LIBCXX=On
      -DCMAKE_SHARED_LINKER_FLAGS=#{ENV.ldflags}
      -DLLVM_BUILD_LLVM_DYLIB=ON

      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=OFF
      -DLIBOMP_ARCH=x86_64

      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
    ]

    mkdir buildpath/"build" do
      system "mkdir", "-p", "docs/ocamldoc/html"

      system "opam", "config", "exec", "--", "cmake", "-G", "Unix Makefiles", "../", *llvm_args
      system "opam", "config", "exec", "--", "make"
      system "opam", "config", "exec", "--", "make", "install"
    end

    cd prefix do
      system "patch -p1 < #{buildpath}/attr_dump_cpu_cases_compilation_fix.patch"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>

      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I/usr/include", # this is where CLT installs stdio.h
              "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      libclangxc = Dir["#{MacOS::Xcode.toolchain_path}/usr/lib/clang/#{DevelopmentTools.clang_version}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end
  end
end
