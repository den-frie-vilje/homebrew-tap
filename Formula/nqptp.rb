class Nqptp < Formula
  desc "PTP timing daemon, companion to Shairport Sync for AirPlay 2"
  homepage "https://github.com/mikebrady/nqptp"
  # Pinned to the development branch (1.2.9-dev): macOS support
  # (mikebrady/nqptp#51 and the Darwin timing and thread-priority fixes)
  # is not in a release yet. Shared-memory interface version 11, matching
  # the shairport-sync formula in this tap. Move to the 1.2.9 tag once it
  # ships.
  url "https://github.com/mikebrady/nqptp/archive/0a88cd7ca9325f023ca5d891714695167672bdb9.tar.gz"
  version "1.2.9-dev"
  sha256 "9500ffa2d925f5d98e2e3c6231cd2ade787be2acc7bbcf874c9d10116b0a8388"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :macos # elsewhere nqptp must run as root; use upstream's installers

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"nqptp"]
    keep_alive true
    log_path var/"log/nqptp.log"
    error_log_path var/"log/nqptp.log"
  end

  def caveats
    <<~EOS
      nqptp listens on UDP ports 319 and 320, which macOS leaves free while
      its own AirPlay Receiver is off, and which a user process may bind;
      no sudo is needed. Keep it running for AirPlay 2:
        brew services start nqptp
    EOS
  end

  test do
    assert_match "smi11", shell_output("#{bin}/nqptp -V")
  end
end
