class Hawg < Formula
  desc "Show badges for high CPU processes in macOS menu bar"
  homepage "https://github.com/dungle-scrubs/hawg"
  url "https://github.com/dungle-scrubs/hawg/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "PLACEHOLDER"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/Hawg" => "hawg"
  end

  service do
    run [opt_bin/"hawg", "--threshold", "200"]
    keep_alive true
    log_path var/"log/hawg.log"
    error_log_path var/"log/hawg.error.log"
  end

  test do
    assert_match "hawg", shell_output("#{bin}/hawg --version")
  end
end
