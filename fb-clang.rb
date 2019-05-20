class FbClang < Formula
  desc "facebook clang plugins"
  url "https://github.com/facebook/facebook-clang-plugins/tarball/36266f6c86041896bed32ffec0637fefbc4463e0"
  sha256 "6105f42e925a3db304eddf74acbfb63cbf59183c0bcd3e2c174c705d3398e1a0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "gmp" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "mpfr" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build

  keg_only :provided_by_macos, "Conflicts with system clang"

  def install
    ENV.permit_arch_flags
    ENV.libcxx if ENV.compiler == :clang

    # avoid rebuilding this until the damn formula works
    opamroot = HOMEBREW_CACHE/"opam"
    #opamroot = libexec/"opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # setup opam
    # disable opam sandboxing because homebrew is sandboxed already
    #system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing"
    #system "opam", "switch", "create", "#{ocaml_version}"

    ## install ocamlbuild proper version here so we don't have to deal with reinstalls ?
    #system "opam", "install", "ocamlbuild=#{ocamlbuild_version}"
    #oPATH = ENV["PATH"]
    #ENV["PATH"] = "/usr/bin:" + ENV["PATH"]
    #system "opam", "install", "mlgmpidl=#{mlgmpidl_version}"
    #ENV["PATH"] = oPATH
    #system "opam", "install", "utop"

      #-DCMAKE_C_FLAGS="$CFLAGS $CMAKE_C_FLAGS"
      #-DCMAKE_CXX_FLAGS="$CXXFLAGS $CMAKE_CXX_FLAGS"
      #-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS $CMAKE_SHARED_LINKER_FLAGS"
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

      -DCMAKE_INSTALL_PREFIX=#{prefix}/install
      -DCMAKE_BUILD_TYPE=Release
    ]

    #cd "clang/src" do
    mkdir buildpath/"llvm" do
        system "tar", "--extract", "--file", buildpath/"clang/src/llvm_clang_compiler-rt_libcxx_libcxxabi_openmp-7.0.1.tar.xz"

        patch :p1 do
          url "https://github.com/facebook/facebook-clang-plugins/blob/36266f6c86041896bed32ffec0637fefbc4463e0/clang/src/err_ret_local_block.patch"
          sha256 ""
        end

        patch :p1 do
          url "https://github.com/facebook/facebook-clang-plugins/blob/36266f6c86041896bed32ffec0637fefbc4463e0/clang/src/mangle_suppress_errors.patch"
          sha256 ""
        end

        mkdir "build" do
          system "mkdir", "-p", "docs/ocamldoc/html"

          system "cmake", "-G", "Unix Makefiles", "../llvm", *llvm_args
          system "make"
          system "./bin/clang", "--version"
          system "make", "install"
        end
    end

    # just bypass stripping altogether?

    cd prefix do
      patch :p1 do
        url "https://github.com/facebook/facebook-clang-plugins/blob/36266f6c86041896bed32ffec0637fefbc4463e0/clang/src/attr_dump_cpu_cases_compilation_fix.patch"
        sha256 ""
      end
    end

    cd "clang/src" do
      srcs = %w[
        llvm_clang_compiler-rt_libcxx_libcxxabi_openmp-7.0.1.tar.xz
        setup.sh
      ]
      system "shasum", "-a", "256", *srcs, ">", "installed.version"
    end

    # not sure if these installs work properly as postinstall failed
    # whatever i'll keep it around
    # (should probably come back to it though)

    libexec.install Dir["clang-ocaml"]
    libexec.install Dir["clang"]
    libexec.install Dir["libtooling"]
    libexec.install Dir["scripts"]

    libexec.install Dir["*"]

    bin.install Dir["clang/install/bin/*"]
    include.install Dir["clang/install/include/*"]
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
