class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.0.tar.gz"
  sha256 "ef2255b867523d19eb0e9f3f5d0c943e67cca3609ab60a55193243694bec8069"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "021838198fb15335b4147b1bc935c6a55bc13cfd293e1312779c4d87f0e1be30" => :high_sierra
    sha256 "a081d7eb98b9fe888fa9cf0573fa9d909869a35300d1fd0eeb9ca4486dc878f5" => :sierra
    sha256 "435ba9218af1848ddb234de8a9a576912a2f78a8994871b3b6f5530f9dffebc7" => :el_capitan
  end

  option "with-libev", "Build libev plugin"

  deprecated_option "with-libev-plugin" => "with-libev"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args << "-DLCB_NO_TESTS=1" << "-DLCB_BUILD_LIBEVENT=ON"

    ["libev", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
