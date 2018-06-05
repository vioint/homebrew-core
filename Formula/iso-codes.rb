class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iso-codes/iso-codes_3.79.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/i/iso-codes/iso-codes_3.79.orig.tar.xz"
  sha256 "cbafd36cd4c588a254c0a5c42e682190c3784ceaf2a098da4c9c4a0cbc842822"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :high_sierra
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :sierra
    sha256 "cf5cafde9f48d495c89e65fbc616a555a74d77799ba3300b9bf72486decca6d3" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "python"
  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    pkg_config = Formula["pkg-config"].opt_bin/"pkg-config"
    output = shell_output("#{pkg_config} --variable=domains iso-codes")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
