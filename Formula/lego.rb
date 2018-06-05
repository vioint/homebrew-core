class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.0.1.tar.gz"
  sha256 "2ff71e9d67c9b49a1a0c4e2244241af69e4d42b09d7c41bae582a0dc555e33de"

  bottle do
    cellar :any_skip_relocation
    sha256 "f479f3752c94a3ec6592698925686fb8ed215d13b7210b66ae7b6c50565385dd" => :high_sierra
    sha256 "29dad74958b2799553a699fe544d48c414ed02e1ebf2b67bd912740f22d59623" => :sierra
    sha256 "06452881b46e6f9711313a5ff84429d437d83b3f1234cae370cacc9a3e4d66c7" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xenolf/lego").install buildpath.children
    cd "src/github.com/xenolf/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
