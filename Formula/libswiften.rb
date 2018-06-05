class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"
  revision 1

  bottle do
    sha256 "6aa48ae140c14532465fc4b875fc19fe339646d9b3ba141c6a030db873f07383" => :high_sierra
    sha256 "e0501ba8ac4d5f61fb1769d13595c1eb81d0126c2abb2181b5313dd3e42d642e" => :sierra
    sha256 "374fbcd5d163aeaeaee0ea17356df25244799c2b30d3e760dfc644f6e6c70e6a" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua@5.1" => :recommended

  deprecated_option "without-lua" => "without-lua@5.1"

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]

    args = %W[
      -j #{ENV.make_jobs}
      V=1
      linkflags=-headerpad_max_install_names
      optimize=1 debug=0
      allow_warnings=1
      swiften_dll=1
      boost_includedir=#{boost.include}
      boost_libdir=#{boost.lib}
      libidn_includedir=#{libidn.include}
      libidn_libdir=#{libidn.lib}
      SWIFTEN_INSTALLDIR=#{prefix}
      openssl=no
    ]

    if build.with? "lua@5.1"
      lua = Formula["lua@5.1"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}/lua-5.1"
      args << "lua_libdir=#{lua.lib}"
      args << "lua_libname=lua.5.1"
    end

    args << prefix

    scons *args
  end

  test do
    system "#{bin}/swiften-config"
  end
end
