class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.19.0.tar.gz"
  sha256 "a08f5890b4a62e8f8a9440e1b9242bfe01d226461290fe4a483e982558f7fe8b"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65425644a05e9fffd2f274293b27c9adafcec89ccde2ffc9091e9a2702d0d6fe" => :high_sierra
    sha256 "13c0cc22dc3012dabfc94c27cb35eb2059c191c7cfb68107d4013ff0bd6a2683" => :sierra
    sha256 "b2c171bafb37cc03bc6aa5de7a5b852d437ec4507d4c6f1aaf627e30f8a98966" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    cd "src/github.com/immortal/immortal" do
      system "dep", "ensure"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
