class Boomerblaster < Formula
  desc "Silent disco for the open-plan office: cast from a phone, hear it in a browser"
  homepage "https://github.com/den-frie-vilje/boomerblaster"
  url "https://github.com/den-frie-vilje/boomerblaster/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "420fe3332e348efd65865c6c63ea9abb35d5040abee2bb5a85685f63bfe4ab4d"
  license "MIT"

  # This tap's shairport-sync is built with AirPlay 2, which needs nqptp
  # running; homebrew-core's build is classic AirPlay only.
  depends_on "den-frie-vilje/tap/nqptp"
  depends_on "den-frie-vilje/tap/shairport-sync"
  # This tap's snapcast reports AirPlay track progress, for the page's playhead.
  depends_on "den-frie-vilje/tap/snapcast"
  depends_on "librespot"

  def install
    bin.install "boomerblaster"
    pkgshare.install "listener/dist" => "listener"
    pkgshare.install "plug-ins"
    if OS.mac?
      system "make", "-C", "capture"
      (libexec/"boomerblaster").install "capture/boomerblaster-capture"
    end
  end

  service do
    run [opt_bin/"boomerblaster", "run"]
    keep_alive true
    log_path var/"log/boomerblaster.log"
    error_log_path var/"log/boomerblaster.log"
  end

  def caveats
    <<~EOS
      Set up once, then start the server and get the address to send round:
        boomerblaster init
        boomerblaster start
        boomerblaster url
      Phones see an AirPlay and a Spotify Connect device named "BoomerBlaster";
      colleagues open the address in a browser and press play.
      `brew services start boomerblaster` is an alternative to `boomerblaster start`;
      then start nqptp yourself too: brew services start nqptp
      To play the Mac's own sound (the System source), optionally:
        brew install blackhole-2ch nowplaying-cli
      0.2.1 used homebrew-core's shairport-sync. If brew reports a conflict
      with it, run brew uninstall shairport-sync and install again.
      Before brew uninstall, stop the background job:
        boomerblaster stop
    EOS
  end

  test do
    assert_match "boomerblaster", shell_output("#{bin}/boomerblaster version")
  end
end
