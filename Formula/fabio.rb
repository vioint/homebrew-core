class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.9.tar.gz"
  sha256 "25e3826f25fa4baf50f0a722bf080ebb47f23b5db6064e9f4af6247872f15b9d"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec131d7c669487df1dbfe48a0d2c675088954050d829172951178d333b0bc02f" => :high_sierra
    sha256 "6ba3c6d5df47d5f023f6ac83e0d0dfb3e77c7a98f25c2dcf9c8f70bdea4fad38" => :sierra
    sha256 "119a92b4a23b0b25929b792321aae2dc5e75527092076f312c448df363b8b274" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended

  def install
    mkdir_p buildpath/"src/github.com/fabiolb"
    ln_s buildpath, buildpath/"src/github.com/fabiolb/fabio"

    ENV["GOPATH"] = buildpath.to_s

    system "go", "install", "github.com/fabiolb/fabio"
    bin.install "#{buildpath}/bin/fabio"
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT = 8500
    FABIO_DEFAULT_PORT = 9999
    LOCALHOST_IP = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    if !port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 30
      else
        puts "Consul already running"
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 10
      assert_equal true, port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end
end
