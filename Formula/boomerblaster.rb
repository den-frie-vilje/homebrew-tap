class Boomerblaster < Formula
  desc "Silent disco for the open-plan office: cast from a phone, listen in sync in a browser"
  homepage "https://github.com/den-frie-vilje/boomerblaster"
  # The archive of the v0.1.0 commit; switch to the tag URL once the tag exists on GitHub.
  url "https://github.com/den-frie-vilje/boomerblaster/archive/12d91fe6a2317725d11e1a6e7c7ceab774036e1d.tar.gz"
  version "0.1.0"
  sha256 "6c7ec1c514c8868a390a5a025fc299c293ed5308c4a63227f0be8302ad5b2277"
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
