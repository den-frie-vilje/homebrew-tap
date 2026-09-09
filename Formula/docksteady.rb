class Docksteady < Formula
  desc "Keeps a macOS multi-monitor arrangement steady for identical displays"
  homepage "https://github.com/den-frie-vilje/docksteady"
  url "https://github.com/den-frie-vilje/docksteady/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c15ed4a06ba40e0294790d63202278c58a75649cea9e9bef29b15ee4f5c0d1b0"
  license "MIT"

  depends_on :macos
  depends_on "sleepwatcher"

  def install
    bin.install "docksteady"
  end

  def caveats
    <<~EOS
      docksteady also needs displayplacer:
        brew install jakehilborn/jakehilborn/displayplacer
      and sleepwatcher running, for enforcement on wake:
        brew services start sleepwatcher
      Then, docked with both panels attached and arranged correctly:
        docksteady init
    EOS
  end

  test do
    assert_match "docksteady", shell_output("#{bin}/docksteady version")
  end
end
