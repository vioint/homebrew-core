class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.8/src/haproxy-1.8.9.tar.gz"
  sha256 "436b77927cd85bcd4c2cb3cbf7fb539a5362d9686fdcfa34f37550ca1f5db102"

  bottle do
    cellar :any
    sha256 "5f12cff473eb09ee9f82f8be1bb92011f9ce982eeb05b1f6f4cadae7ed9b1d7d" => :high_sierra
    sha256 "e122c57eea95d605f20103957be26aca0d0ab7f9d578658fcaa81dc56b6b457f" => :sierra
    sha256 "a5cadba2f84db696b3d2e9c322ef065ae4e9474693017b29cfefed109a23fb2f" => :el_capitan
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua" => :optional

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    if build.with?("lua")
      lua = Formula["lua"]
      args << "USE_LUA=1"
      args << "LUA_LIB=#{lua.opt_lib}"
      args << "LUA_INC=#{lua.opt_include}"
      args << "LUA_LD_FLAGS=-L#{lua.opt_lib}"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options :manual => "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/haproxy</string>
          <string>-f</string>
          <string>#{etc}/haproxy.cfg</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/haproxy.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/haproxy.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
