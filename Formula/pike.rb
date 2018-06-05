class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se"
  url "https://pike.lysator.liu.se/pub/pike/all/8.0.610/Pike-v8.0.610.tar.gz"
  sha256 "6eeb410caf56ff4a209a06db29f003208d507680f7c17c0fd93c15f48b5edf53"

  bottle do
    sha256 "61803c25145ee316b9883a94ebb7b6d96a14aa77e2d860b4025379943d8f27a3" => :high_sierra
    sha256 "0792ad6bbd3988b928e4ad8e91a0b189ef4f591c51f3af4b622d7ddff4039b1d" => :sierra
    sha256 "f23b16351cd5bed06c310c78b083caa6df91c21fbe386f6a2f73803404f01762" => :el_capitan
  end

  option "with-gettext", "Include Gettext support"
  option "with-gdbm", "Include Gdbm support"
  option "with-gtk2", "Include GTK2 support"
  option "with-mysql", "Include Mysql support"
  option "with-pcre", "Include Regexp.PCRE support"
  option "with-sdl", "Include SDL support"
  option "with-sane", "Include Sane support"
  option "with-pdf", "Include PDF support"
  option "with-gl", "Include GL support"
  option "with-all", "Include all features"

  depends_on "nettle"
  depends_on "gmp"
  depends_on "pcre"
  depends_on :x11 => :optional
  depends_on "libtiff" => :recommended

  # optional dependencies
  depends_on "gettext"       if build.with?("gettext") || build.with?("all")
  depends_on "gdbm"          if build.with?("gdbm")    || build.with?("all")
  depends_on "gtk+"          if build.with?("gtk2")    || build.with?("all")
  depends_on "mysql"         if build.with?("mysql")   || build.with?("all")
  depends_on "sdl"           if build.with?("sdl")     || build.with?("all")
  depends_on "sane-backends" if build.with?("sane")    || build.with?("all")
  depends_on "pdflib-lite"   if build.with?("pdf")     || build.with?("all")
  depends_on "mesalib-glw"   if build.with?("gl")      || build.with?("all")

  def install
    args = ["--prefix=#{prefix}", "--without-bundles"]

    if MacOS.prefer_64_bit?
      ENV.append "CFLAGS", "-m64"
      args << "--with-abi=64"
    else
      ENV.append "CFLAGS", "-m32"
      args << "--with-abi=32"
    end

    ENV.deparallelize

    system "make", "CONFIGUREARGS='" + args.join(" ") + "'"

    # installation is complicated by some of brew's standard patterns.
    # hopefully these notes explain the reasons for diverging from
    # the path that most other formulae use.
    #
    # item 1
    #
    # basically, pike already installs itself naturally as brew would want
    # it; that is, if prefix=/Cellar, installation would create
    # /Cellar/pike/ver/bin and so forth. We could just go with that, but it's
    # possible that homebrew might change its layout and then the formula
    # would no longer work.
    #
    # so, rather than guessing at it, we do this alternate gyration, forcing
    # pike to install in a slightly nonstandard way (for pike, at least)
    #
    # item 2
    #
    # a second problem crops up because the during installation, the link
    # function tries to pull in stuff from lib/, which is really more like
    # what one would expect share or libexec in homebrew might be: pike
    # specific files, rather than shared libraries. we could approach this
    # in a similar fashion, but the result would be a really odd arrangement
    # for anyone remotely familar with standard pike installs.
    #
    # because there's no way to override the keg.link command, this formula
    # installs the whole pike install into prefix/libexec and then links the
    # man page and binary back into prefix/share and prefix/bin. not so
    # elegant, but that's the way brew works.
    system "make",  "install",
                    "prefix=#{libexec}",
                    "exec_prefix=#{libexec}",
                    "share_prefix=#{libexec}/share",
                    "lib_prefix=#{libexec}/lib",
                    "man_prefix=#{libexec}/man",
                    "include_path=#{libexec}/include",
                    "INSTALLARGS=--traditional"

    bin.install_symlink "#{libexec}/bin/pike"
    share.install_symlink "#{libexec}/share/man"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
