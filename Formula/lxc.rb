class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.1.tar.gz"
  sha256 "bcfe2661d97af0dcc0ac5de8407b6e24de8615e6b7881bd4bf8e9c59fefc673f"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb90c8c8e24685de61dce14dc6c8519ceb5102ca6a609a0b96fa2a017383617f" => :high_sierra
    sha256 "26c2b8c5774990b231324a1245843d5e3e603b8bc64f9c8f259851973d92dfa7" => :sierra
    sha256 "97e5069a0562dbe27fa15df70b4677283683ff6a7f331bd979154c30677d60cd" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
