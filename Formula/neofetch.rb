class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/4.0.2.tar.gz"
  sha256 "3cd4db97d732dd91424b357166d38edccec236c21612b392318b48a3ffa29004"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dbb8cac5cec6d907af333f10ef6cfac4c2accdc59ee007a6f6a810228544659" => :high_sierra
    sha256 "2dbb8cac5cec6d907af333f10ef6cfac4c2accdc59ee007a6f6a810228544659" => :sierra
    sha256 "2dbb8cac5cec6d907af333f10ef6cfac4c2accdc59ee007a6f6a810228544659" => :el_capitan
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
