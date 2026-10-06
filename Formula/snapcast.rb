class Snapcast < Formula
  desc "Synchronous multiroom audio player (build with Airplay progress metadata)"
  homepage "https://github.com/snapcast/snapcast"
  # Built from the olekristensen fork's airplay-prgr-progress branch, which parses
  # shairport-sync's "prgr" (progress) metadata so Airplay streams expose the track
  # position and duration to clients. Submitted upstream as
  # https://github.com/snapcast/snapcast/pull/1557 — switch back to (or shadow) the
  # homebrew-core formula once a release containing it ships.
  url "https://github.com/olekristensen/snapcast/archive/40c6109f476997ad29a69dce69b521700d2f1c95.tar.gz"
  version "0.35.0"
  sha256 "8e83291fe65fb81d574f29ed386df93e62d0cdf11bcf27c9ffc958ecdd2bead2"
  license "GPL-3.0-or-later"
  revision 2

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "openssl@4"
  depends_on "opus"

  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    # REVISION is the source commit; `snapserver --version` reports it as "(rev 40c6109f)",
    # which distinguishes this build from the stock homebrew-core 0.35.0.
    system "cmake", "-S", ".", "-B", "build", "-DREVISION=40c6109f476997ad29a69dce69b521700d2f1c95", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "40c6109f", shell_output("#{bin}/snapserver --version")

    server_pid = spawn bin/"snapserver"
    sleep 2

    begin
      output_log = testpath/"output.log"
      client_pid = spawn bin/"snapclient", [:out, :err] => output_log.to_s
      sleep 10
      if OS.mac?
        assert_match version.to_s, output_log.read
      else
        # Needs Avahi (which also needs D-Bus system bus) which requires root
        assert_match "BrowseAvahi - Failed to create client", output_log.read
      end
    ensure
      Process.kill("SIGTERM", client_pid)
    end
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end
