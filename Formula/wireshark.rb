class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  stable do
    url "https://www.wireshark.org/download/src/all-versions/wireshark-2.6.1.tar.xz"
    mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.6.1.tar.xz"
    sha256 "ab6e5bbc3464c956347b8671ce8397950ad5daff3bf9964c967d495f4ddbcd88"

    # Fix header includes for Qt 5.11.
    # TODO: Committed upstream, remove on next .z release.
    patch do
      url "https://github.com/wireshark/wireshark/commit/b8e8aa87f43c12ad564426b3359f593305cd45a1.patch?full_index=1"
      sha256 "39ff775cabc2cc31d8c2152b78a0b05a0a7686fd3b5dd0807d359493c3681c9a"
    end
  end

  bottle do
    sha256 "0b3c8f3dec1fb90c9704d7009adcb09281491583eb92fc3f38e1210d6ef895b0" => :high_sierra
    sha256 "ec69fa058d4d165234182069940a20f8b6b9a08898818854eec88c4890ca69e3" => :sierra
    sha256 "cbd0649938676719180cf30b2c8932e7d49f400e302978a5e8719a33b37d0502" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-qt", "Build the wireshark command with Qt"
  option "with-headers", "Install Wireshark library headers for plug-in development"
  option "with-nghttp2", "Enable HTTP/2 header dissection"

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "lua@5.1"
  depends_on "libsmi" => :optional
  depends_on "libssh" => :optional
  depends_on "nghttp2" => :optional
  depends_on "qt" => :optional

  def install
    args = std_cmake_args + %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua@5.1"].opt_include}/lua-5.1
      -DLUA_LIBRARY=#{Formula["lua@5.1"].opt_lib}/liblua5.1.dylib
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
    ]

    if build.with? "qt"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
      args << "-DENABLE_QT5=OFF"
    end

    if build.with? "libsmi"
      args << "-DENABLE_SMI=ON"
    else
      args << "-DENABLE_SMI=OFF"
    end

    if build.with? "libssh"
      args << "-DBUILD_sshdump=ON" << "-DBUILD_ciscodump=ON"
    else
      args << "-DBUILD_sshdump=OFF" << "-DBUILD_ciscodump=OFF"
    end

    if build.with? "nghttp2"
      args << "-DENABLE_NGHTTP2=ON"
    else
      args << "-DENABLE_NGHTTP2=OFF"
    end

    system "cmake", *args
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark" => "wireshark"
    end

    if build.with? "headers"
      (include/"wireshark").install Dir["*.h"]
      (include/"wireshark/epan").install Dir["epan/*.h"]
      (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
      (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
      (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
      (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
      (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
      (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
      (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
    end
  end

  def caveats; <<~EOS
    This formula only installs the command-line utilities by default.

    Wireshark.app can be downloaded directly from the website:
      https://www.wireshark.org/

    Alternatively, install with Homebrew-Cask:
      brew cask install wireshark

    If your list of available capture interfaces is empty
    (default macOS behavior), install ChmodBPF:

      brew cask install wireshark-chmodbpf
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
