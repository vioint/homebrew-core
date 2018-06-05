class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/1.4.2.tar.gz"
    sha256 "5dfa5e3e2dc5b6b57c50370dcb234c6625fba64e4b10c8de197df90dd9cbb838"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/1.1.3.tar.gz"
      sha256 "09aa98d630710c2da74aebeda1eccc4e878bd8ececa1c3ad5464d6e777b44eb6"
    end
  end

  bottle do
    cellar :any
    sha256 "2debe96f92b885105e95f2e6b3e7001a09ed6fa402a0ea10ed6db06812141f3d" => :high_sierra
    sha256 "b1c363714f754a103b849e2d1bfbf9ee143c1c51652c6f611d79c5b9592c4c7c" => :sierra
    sha256 "6c9c205c5d8433fc312f26af8d4efbf4e47e605951c4d2b2409e9c07d3f5de5d" => :el_capitan
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on :arch => :x86_64
  depends_on "python@2"
  depends_on "openssl"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/f0/ba/860a4a3e283456d6b7e2ab39ce5cf11a3490ee1a363652ac50abf9f0f5df/ipaddress-1.0.19.tar.gz"
    sha256 "200d8686011d470b5e4de207d803445deee427455cd0cb7c982b68cf82524f81"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/49/c4/aa379256eb83469154c671b700b3edb42ae781044a4cd40ae92bff8259c7/tls_parser-1.2.1.tar.gz"
    sha256 "869ad3c8a45e73bcbb3bf0dd094f0345675c830e851576f42585af1a60c2b0e5"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c/typing-3.6.4.tar.gz"
    sha256 "d400a9344254803a2368533e4533a4200d21eb7b6b729c173bc38201a74db3f2"
  end

  resource "zlib" do
    url "https://zlib.net/zlib-1.2.11.tar.gz"
    mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  resource "openssl-legacy" do
    url "https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2e.tar.gz"
    sha256 "e23ccafdb75cfcde782da0151731aa2185195ac745eea3846133f2e05c0e0bff"
  end

  resource "openssl-modern" do
    url "https://github.com/openssl/openssl.git",
        :revision => "1f5878b8e25a785dde330bf485e6ed5a6ae09a1a"
  end

  def install
    venv = virtualenv_create(libexec)

    res = resources.map(&:name).to_set
    res -= %w[nassl openssl-legacy openssl-modern zlib]

    res.each do |r|
      venv.pip_install resource(r)
    end

    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      # openssl fails on parallel build. Related issues:
      # - https://rt.openssl.org/Ticket/Display.html?id=3736&user=guest&pass=guest
      # - https://rt.openssl.org/Ticket/Display.html?id=3737&user=guest&pass=guest
      ENV.deparallelize do
        mv "bin/openssl-legacy/include", "nassl_openssl_legacy_include"
        mv "bin/openssl-modern/include", "nassl_openssl_modern_include"
        rm_rf "bin" # make sure we don't use the prebuilt binaries
        (nassl_path/"bin/openssl-legacy/darwin64").mkpath
        (nassl_path/"bin/openssl-modern/darwin64").mkpath
        mv "nassl_openssl_legacy_include", "bin/openssl-legacy/include"
        mv "nassl_openssl_modern_include", "bin/openssl-modern/include"
        (nassl_path/"zlib-#{resource("zlib").version}").install resource("zlib")
        (nassl_path/"openssl-1.0.2e").install resource("openssl-legacy")
        (nassl_path/"openssl-master").install resource("openssl-modern")
        system "python", "build_from_scratch.py"
      end
      system "python", "run_tests.py"
      venv.pip_install nassl_path
    end
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
