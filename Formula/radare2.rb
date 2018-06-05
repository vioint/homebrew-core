class CodesignRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    FileUtils.mktemp do
      FileUtils.cp "/usr/bin/false", "radare2_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "org.radare.radare2", "--dryrun", "radare2_check"
    end
  end

  def message
    <<~EOS
      org.radare.radare2 identity must be available to build with automated signing.
      See: https://github.com/radare/radare2/blob/master/doc/macos.md
    EOS
  end
end

class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"

  stable do
    url "https://radare.mikelloc.com/get/2.6.0/radare2-2.6.0.tar.gz"
    sha256 "6653d5f7d10850a288abeea1ad892e2e6e0981e40bb58296d3b27ccfd88e7713"

    resource "bindings" do
      url "https://radare.mikelloc.com/get/2.6.0/radare2-bindings-2.6.0.tar.gz"
      sha256 "b97b256c99398d3bfc4d0b588a63814c95a028f8bb404c2512f1644b935ed824"
    end

    resource "extras" do
      url "https://radare.mikelloc.com/get/2.6.0/radare2-extras-2.6.0.tar.gz"
      sha256 "bcc68f3facf4e977146a797d39722d0416195d4fbc835c62fcabe8b2055a94ba"
    end
  end

  bottle do
    sha256 "568b3e06a3c5ceb6ab5f22430029d1666967b2c42df642f93b715d446c13ab9a" => :high_sierra
    sha256 "c6b1f6cce416f2c89451406efc43791a3cef1e8369cc363dd64977ea9c5b06f7" => :sierra
    sha256 "06110fce1d5980fec9cca188ea5c1ad308cd5cc65cd2be200ef9fbb828cd1d45" => :el_capitan
  end

  head do
    url "https://github.com/radare/radare2.git"

    resource "bindings" do
      url "https://github.com/radare/radare2-bindings.git"
    end

    resource "extras" do
      url "https://github.com/radare/radare2-extras.git"
    end
  end

  option "with-code-signing", "Codesign executables to provide unprivileged process attachment"

  depends_on "pkg-config" => :build
  depends_on "valabind" => :build
  depends_on "swig" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl"
  depends_on "yara"

  depends_on CodesignRequirement if build.with? "code-signing"

  # These three patches update the buildsystem to fix linking libr2 with openssl.
  # The first two are merged upstream, and the third has been submitted.
  # https://github.com/radare/radare2/pull/10188
  patch do
    url "https://github.com/radare/radare2/commit/3752d992f3140806ea1d513739b6f23addf52df1.patch?full_index=1"
    sha256 "ac0642a49603e572ef033c2f7c3225775b6996147bd7c7052d595b41edfdffca"
  end

  patch do
    url "https://github.com/radare/radare2/commit/2ca2a0ae1565e89ed4c49813f05190c610fb37f1.patch?full_index=1"
    sha256 "5081a33e2af8483b035fc698c1814c1a68741aa793c5ccb60faa844343829c66"
  end

  patch do
    url "https://github.com/Homebrew/formula-patches/raw/12d117bea567c5811a7bf1a70ccd0777ecb10997/radare2/fix_openssl_build.patch"
    sha256 "d952e048e8551017419520d29d75f988463155c2a79d89e2613423bbd9e91fd3"
  end

  def install
    # Build Radare2 before bindings, otherwise compile = nope.
    system "./configure", "--prefix=#{prefix}", "--with-openssl"
    system "make", "CS_PATCHES=0"
    if build.with? "code-signing"
      # Brew changes the HOME directory which breaks codesign
      home = `eval printf "~$USER"`
      system "make", "HOME=#{home}", "-C", "binr/radare2", "macossign"
      system "make", "HOME=#{home}", "-C", "binr/radare2", "macos-sign-libs"
    end
    ENV.deparallelize { system "make", "install" }

    # remove leftover symlinks
    # https://github.com/radare/radare2/issues/8688
    rm_f bin/"r2-docker"
    rm_f bin/"r2-indent"

    resource("extras").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./configure", "--prefix=#{prefix}"
      system "make", "all"
      system "make", "install"
    end

    resource("bindings").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # Language versions.
      perl_version = `/usr/bin/perl -e 'printf "%vd", $^V;'`
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the correct Cellar
      # paths.
      inreplace "libr/lang/p/Makefile", "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
      # fix build, https://github.com/radare/radare2-bindings/pull/168
      inreplace "libr/lang/p/Makefile",
      "CFLAGS+=$(shell pkg-config --cflags r_core)",
      "CFLAGS+=$(shell pkg-config --cflags r_core) -DPREFIX=\\\"${PREFIX}\\\""
      inreplace "Makefile", "LUAPKG=", "#LUAPKG="
      inreplace "Makefile", "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
      make_install_args = %W[
        R2_PLUGIN_PATH=#{lib}/radare2/#{version}
        LUAPKG=lua-#{lua_version}
        PERLPATH=#{lib}/perl5/site_perl/#{perl_version}
        PYTHON_PKGDIR=#{lib}/python2.7/site-packages
        RUBYPATH=#{lib}/ruby/#{RUBY_VERSION}
      ]

      system "./configure", "--prefix=#{prefix}"
      ["lua", "perl", "python"].each do |binding|
        system "make", "-C", binding, *make_binding_args
      end
      system "make"
      system "make", "install", *make_install_args
    end
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
