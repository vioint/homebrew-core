class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/73/25/a3bf7e0cf24652c29066059da74acb12847f09fbab8006dc0f3443e7f661/dxpy-0.255.0.tar.gz"
  sha256 "9c2b8ea8733f44d4545d6bc4c517b3453731a9d39744ee8b31e0e8b3279f94ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "48357e83d567558cf150ddaa507a598b45c31e167b2fcf5e0e205fd87cf9c483" => :high_sierra
    sha256 "905b16b0fcead773a409ce49c2286492e297bed020c82a58667dbaa29d41eb94" => :sierra
    sha256 "8e0d50f6317371201396407024cf78e059fe28fe075ca06d4cb7ebc5aea33130" => :el_capitan
  end

  depends_on "python@2"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/26/79/ef9a8bcbec5abc4c618a80737b44b56f1cb393b40238574078c5002b97ce/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/0f/4d/26a937988e2633aa9f1d5268aa3782afaee9a482c6c6f221fc1e1ae58862/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/8d/73/b5fff618482bc06c9711e7cdc0d5d7eb1904d35898f48f2d7f9696b08bef/futures-3.0.4.tar.gz"
    sha256 "19485d83f7bd2151c0aeaf88fbba3ee50dadfb222ffc3b66a344ef4952b782a3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/69/c0d8e9b9f8a58cbf71aa4cf7f27c27ee0ab05abe32d9157ec22e223edef4/psutil-3.3.0.tar.gz"
    sha256 "421b6591d16b509aaa8d8c15821d66bb94cb4a8dc4385cad5c51b85d4a096d85"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/54/d561347dbfa0a1eeaf49a005da5fd71c0a0be8e4e2676f14775dd0097430/python-dateutil-2.3.tar.gz"
    sha256 "2db67d8832f19332908b4b9644865ced34087919702140862093e347e95730e4"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/21/57/57c47169c651534014a9852ec690fc0893bab2f67e24d6dab3c945522e7d/python-magic-0.4.6.tar.gz"
    sha256 "903d3d3c676e2b1244892954e2bbbe27871a633385a9bfe81f1a81a7032df2fe"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/d6/69/0f5723c5784317278866891546c5fe4521dc404600df504651e9c934fd0d/ws4py-0.3.2.tar.gz"
    sha256 "48a4e005496a60081f74ca130ce55603ff87e1507483535acf902b94761bda8b"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/c5/80/b25d549ae4bf4f3e9635a331b759ffca2de4dd8a78dc5106d1ca92f5d08d/xattr-0.6.4.tar.gz"
    sha256 "f9dcebc99555634b697fa3dad8ea3047deb389c6f1928d347a0c49277a5c0e9e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
