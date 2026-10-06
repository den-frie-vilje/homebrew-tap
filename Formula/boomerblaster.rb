class Boomerblaster < Formula
  desc "Silent disco for the open-plan office: cast from a phone, hear it in a browser"
  homepage "https://github.com/den-frie-vilje/boomerblaster"
  # The archive of the 0.2.1 commit; switch to the tag URL once the tag exists on GitHub.
  url "https://github.com/den-frie-vilje/boomerblaster/archive/0389ad1afe67f05523cc99cbcf7e0d8d9efb319a.tar.gz"
  version "0.2.1"
  sha256 "d474f35ad6a6447b090e36649c8c12ce4d9b791c09c3ea1670b2cb4cdb52294f"
  license "MIT"
  revision 1

  # This tap's shairport-sync is built with AirPlay 2, which needs nqptp
  # running; homebrew-core's build is classic AirPlay only.
  depends_on "den-frie-vilje/tap/nqptp"
  depends_on "den-frie-vilje/tap/shairport-sync"
  depends_on "librespot"
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
