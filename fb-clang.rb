class FbClang < Formula
  desc "facebook clang plugins"
  version = "8.0.0"
  url "https://github.com/facebook/facebook-clang-plugins/raw/dc42763b2e43d19518b6d69554a606bb7eaa0f29/clang/src/llvm_clang_compiler-rt_libcxx_libcxxabi_openmp-#{version}.tar.xz"
  sha256 "ce840caa36a0fdf7ce1deabc45b34be341ce386d5d710bf4b2f06f3fe5e7f6da"
  revision 1

  bottle do
    cellar :any
    root_url "https://github.com/Amar1729/homebrew-formulae/releases/download/fb-clang-v8.0.0"
    sha256 "f064f156bf5a688e40bbeac903d725b1ce80c350ae3c5c1a83a959358280c2c3" => :mojave
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gmp" => :build
  depends_on "libtool" => :build
  depends_on "mpfr" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "sqlite" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build

  keg_only :provided_by_macos, "Conflicts with system clang"

  # use specific tag, though patches change infrequently
  tag = "dc42763b2e43d19518b6d69554a606bb7eaa0f29"

  patch :p2 do
    url "https://github.com/facebook/facebook-clang-plugins/raw/#{tag}/clang/src/err_ret_local_block.patch"
    sha256 "2f6f4a492f7cdf9ceb5745d9b72e0073f608506528314aa0dddc6e789f870897"
  end

  patch :p2 do
    url "https://github.com/facebook/facebook-clang-plugins/raw/#{tag}/clang/src/mangle_suppress_errors.patch"
    sha256 "7330688109735c68e274edecaabeb5d28d38f58d60bbe4add01827a9af16dbd7"
  end

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib/"pkgconfig"

    # clang doesn't need opam deps after build (?)
    ENV["OPAMROOT"] = HOMEBREW_CACHE/"opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing"
    # check facebook/infer/build-infer.sh for infer_switch to use
    system "opam", "switch", "create", "ocaml-variants.4.07.1+flambda"
    system "opam", "install", "ctypes", "ounit"

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

    system "strip", "-x", *Dir[prefix/"bin/*"]
    system "strip", "-x", *Dir[prefix/"lib/**/*.dylib"]
    system "strip", "-x", *Dir[prefix/"lib/**/*.a"]
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
