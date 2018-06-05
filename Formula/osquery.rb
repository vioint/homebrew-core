class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  url "https://github.com/facebook/osquery/archive/3.2.6.tar.gz"
  sha256 "54d49f00eae5907f0f0c065b0ea01ffc48a1c977366d9b67d0aa3913f387d7bd"

  bottle do
    cellar :any
    sha256 "c4c8f19053fff9bcc1547d0c3ec9a5b57548932f5fef19c90e30ceecb36f613f" => :high_sierra
    sha256 "23aadba95a5f4ec0f98888e0d3ef560800e8abde7a4617dc14e5d0716e60cdb9" => :sierra
  end

  fails_with :gcc => "6"

  # osquery only supports macOS 10.12 and above. Do not remove this.
  depends_on :macos => :sierra
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "python@2" => :build
  depends_on "augeas"
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lldpd"
  depends_on "librdkafka"
  depends_on "openssl"
  depends_on "rapidjson"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "thrift"
  depends_on "yara"
  depends_on "xz"
  depends_on "zstd"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "third-party" do
    url "https://github.com/osquery/third-party/archive/3.0.0.tar.gz"
    sha256 "98731b92147f6c43f679a4a9f63cbb22f2a4d400d94a45e308702dee66a8de9d"
  end

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/1.3.30.tar.gz"
    sha256 "7b5f9b6d4215069fb75d31db2c8ab06081ab27f59ee33d5bb428fec3e30723f1"
  end

  def install
    ENV.cxx11

    vendor = buildpath/"brew_vendor"

    resource("aws-sdk-cpp").stage do
      args = std_cmake_args + %W[
        -DSTATIC_LINKING=1
        -DNO_HTTP_CLIENT=1
        -DMINIMIZE_SIZE=ON
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_ONLY=ec2;firehose;kinesis;sts
        -DCMAKE_INSTALL_PREFIX=#{vendor}/aws-sdk-cpp
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"
    ENV["SKIP_DEPS"] = "1"

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"
    # Set the version
    ENV["OSQUERY_BUILD_VERSION"] = version

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp third-party]
    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"
      end
    end

    cxx_flags_release = %W[
      -DNDEBUG
      -I#{MacOS.sdk_path}/usr/include/libxml2
      -I#{vendor}/aws-sdk-cpp/include
    ]

    args = std_cmake_args + %W[
      -Daws-cpp-sdk-core_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-core.a
      -Daws-cpp-sdk-firehose_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-firehose.a
      -Daws-cpp-sdk-kinesis_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-kinesis.a
      -Daws-cpp-sdk-sts_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-sts.a
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=#{cxx_flags_release.join(" ")}
    ]

    (buildpath/"third-party").install resource("third-party")

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    (include/"osquery/core").install Dir["osquery/core/*.h"]
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    assert_match "platform_info", shell_output("#{bin}/osqueryi -L")
  end
end
