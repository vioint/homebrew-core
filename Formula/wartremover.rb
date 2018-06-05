class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.1.1.tar.gz"
  sha256 "4c789ee33ecff2b655bc839c5ebc7b20d581f99529f8f553628ed38d9615e553"
  revision 1
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d65bf6808a6683b8e41cfc167232590094433b6d316c19f800da2253d8cc2e" => :high_sierra
    sha256 "c7278d256a0bbedd1d1e7926768b8082898183fa7b18c7887340222b54cdf98e" => :sierra
    sha256 "e11fd32c7e9f8aab1bbb1da9bb13f01bb0015d0a5ba55bc2c5373af18364ea2d" => :el_capitan
  end

  depends_on "sbt" => :build
  depends_on :java => "1.8"

  def install
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover", :java_version => "1.8"
  end

  test do
    (testpath/"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
