class Boomerblaster < Formula
  desc "Silent disco for the open-plan office: cast from a phone, listen in sync in a browser"
  homepage "https://github.com/den-frie-vilje/boomerblaster"
  # The archive of the 0.2.0 commit; switch to the tag URL once the tag exists on GitHub.
  url "https://github.com/den-frie-vilje/boomerblaster/archive/8e6a79cd7e52589e47ada989e5e981d4c4717442.tar.gz"
  version "0.2.0"
  sha256 "8da247b5605ea559febf8573409e77a636425107f1d43ec7fde13b4998d31842"
  license "MIT"

  depends_on "librespot"
  depends_on "shairport-sync"
  depends_on "snapcast"

  def install
    bin.install "boomerblaster"
    pkgshare.install "listener/dist" => "listener"
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
