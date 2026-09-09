class Docksteady < Formula
  desc "Keeps a macOS multi-monitor arrangement steady for identical displays"
  homepage "https://github.com/den-frie-vilje/docksteady"
  url "https://github.com/den-frie-vilje/docksteady/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "359fa4fb22abec5e8e9c2f5e87503fe15f4d0cd1ad4289346b07a98beecd206d"
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
