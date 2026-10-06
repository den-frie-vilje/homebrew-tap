class ShairportSync < Formula
  desc "AirPlay and AirPlay 2 audio player (build with AirPlay 2 for macOS)"
  homepage "https://github.com/mikebrady/shairport-sync"
  # Pinned to the development branch (5.6-dev-149): AirPlay 2 on macOS needs
  # changes that are not in a release yet -- the dns-sd backend advertising
  # _airplay._tcp (mikebrady/shairport-sync#2300), building without libuuid,
  # a CoreAudio backend (#2297) and cancellable condition waits (#2298).
  # Shadows homebrew-core's classic-AirPlay-only build. AirPlay 2 operation
  # needs nqptp (this tap) at the same shared-memory interface version, 11.
  # Move back to a release tag once 5.6 ships.
  url "https://github.com/mikebrady/shairport-sync/archive/3f7a7da5cd5f1431339a5dcb36d2ee763293fb59.tar.gz"
  version "5.6-dev-149"
  sha256 "53ff9236f386cf23b4b6737ab943ed701e6b78f1e047956e8c7aadc63a6947e3"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libconfig"
  depends_on "libgcrypt"
  # libplist also provides plistutil, which the AirPlay 2 build needs at build
  # time; xxd, the other build-time tool, ships with macOS.
  depends_on "libplist"
  depends_on "libsodium"
  depends_on "libsoxr"
  depends_on :macos # the Linux AirPlay 2 build (Avahi, libuuid) is untested here; use upstream's instructions
  depends_on "openssl@3"
  depends_on "popt"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-os=darwin
      --with-airplay-2
      --with-ssl=openssl
      --with-dns_sd
      --with-soxr
      --with-metadata
      --with-stdout
      --with-pipe
      --with-coreaudio
      --sysconfdir=#{pkgetc}
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      AirPlay 2 operation needs the nqptp daemon running:
        brew services start nqptp
      On macOS nqptp runs as your user; no sudo is needed. The Mac's own
      AirPlay Receiver must be off (System Settings > General >
      AirDrop & Handoff), or it holds port 7000 and the PTP ports.
    EOS
  end

  test do
    assert_match "AirPlay2", shell_output("#{bin}/shairport-sync -V")
  end
end
