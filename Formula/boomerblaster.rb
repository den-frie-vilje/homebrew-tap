class Boomerblaster < Formula
  desc "Silent disco for the open-plan office: cast from a phone, listen in sync in a browser"
  homepage "https://github.com/den-frie-vilje/boomerblaster"
  url "https://github.com/den-frie-vilje/boomerblaster/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  depends_on "librespot"
  depends_on "shairport-sync"
  depends_on "snapcast"

  def install
    bin.install "boomerblaster"
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
      `brew services start boomerblaster` is an alternative to `boomerblaster start`.
      Before brew uninstall, stop the background job:
        boomerblaster stop
    EOS
  end

  test do
    assert_match "boomerblaster", shell_output("#{bin}/boomerblaster version")
  end
end
