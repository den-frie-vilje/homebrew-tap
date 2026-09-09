class Docksteady < Formula
  desc "Keeps a macOS multi-monitor arrangement steady for identical displays"
  homepage "https://github.com/den-frie-vilje/docksteady"
  url "https://github.com/den-frie-vilje/docksteady/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "086bacf11bb6213bc54802fd44da7f0ca462479aea650d5f6445b3ace2fe575a"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64
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
      Before brew uninstall, remove the schedule and wake trigger:
        docksteady disarm
    EOS
  end

  test do
    assert_match "docksteady", shell_output("#{bin}/docksteady version")
  end
end
