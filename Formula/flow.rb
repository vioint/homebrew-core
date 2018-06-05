class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.73.0.tar.gz"
    sha256 "cfef40febb8db41a8d3c7f8d3da27e5ecbcda59d87a91d76e31d460c064c723c"

    # Fix compilation with OCaml 4.06 (again - we did this for 0.68 too)
    # Can delete with v0.74.0 deploy
    # Upstream commit 24 May 2018 "Fix lwt type annotation for OCaml 4.06"
    patch do
      url "https://github.com/facebook/flow/commit/6ad707a.patch?full_index=1"
      sha256 "d21a5325e0b56b884a71178388c08da7712be894090b2a940012cd8a69673ff8"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc91a77bc4aa922bc10501b825d3587dc2792f0b97ef6e40c304e023f7282976" => :high_sierra
    sha256 "4853273b9074c451321ca89bbe8fe203a4b05bd86e0d854da56d59024df8f90f" => :sierra
    sha256 "f3be8efe6cdb1bc68c4c40ee62637a17d74cbb2fc06063480bf57c88fa2e6818" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
