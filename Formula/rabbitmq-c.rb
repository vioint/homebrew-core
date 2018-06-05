class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.9.0.tar.gz"
  sha256 "316c0d156452b488124806911a62e0c2aa8a546d38fc8324719cd29aaa493024"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "d95c6f2c892a815ac20fe9a57fac961c73390182abb748d95d5901a3cb45d7ab" => :high_sierra
    sha256 "b2c77dd791f014dfd33983394a369f97e23e0c4519d451b552322df9dced4081" => :sierra
    sha256 "892c266e4c6086c65b3e4cee8cf5116f59d682b178540ee3f78efeff1e9d912a" => :el_capitan
  end

  option "without-tools", "Build without command-line tools"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "popt" if build.with? "tools"
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DBUILD_API_DOCS=OFF"

    if build.with? "tools"
      args << "-DBUILD_TOOLS=ON"
    else
      args << "-DBUILD_TOOLS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
