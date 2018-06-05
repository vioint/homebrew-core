require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.6.tar.gz"
  sha256 "134e8a163745c66b3cc0835c85d3a0546247a15e877d1ce6f9a76d7ab2d47c49"

  bottle do
    cellar :any_skip_relocation
    sha256 "95dfc6ca140fd7c21b86c573ce80a6ea71f3cb65b3c9df52260ea28917a0fc6f" => :high_sierra
    sha256 "734207c20ff2f6cd4bd8da118505934751dd01e5048325d9c8173a6fea03373c" => :sierra
    sha256 "54a452e71fe56d394f8baf086c79eb0dc55f5fd3f7a27dfad82a4ea528eb0036" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
    end

    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
