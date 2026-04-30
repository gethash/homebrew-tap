class Boozle < Formula
  desc "Fullscreen PDF presenter with auto-advance, spiritual successor to Impressive"
  homepage "https://github.com/gethash/boozle"
  url "https://github.com/gethash/boozle/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "db766c02c19468329269c6f334c4521669d3c7e700b0f55304c685ee0084804e"
  license "Apache-2.0"
  head "https://github.com/gethash/boozle.git", branch: "main"

  depends_on "go" => :build

  # macOS: Cocoa, Metal, and OpenGL come from Xcode CLT — no extra deps.
  # Linux: Ebiten's CGO layer needs Mesa + X11 extension headers.
  on_linux do
    depends_on "mesa" => :build
    depends_on "libxcursor" => :build
    depends_on "libxi" => :build
    depends_on "libxinerama" => :build
    depends_on "libxrandr" => :build
    depends_on "libxxf86vm" => :build
    depends_on "libxkbcommon" => :build
    depends_on "pkg-config" => :build
  end

  def install
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    ldflags = [
      "-s", "-w",
      "-X", "main.version=v#{version}",
      "-X", "main.commit=homebrew",
      "-X", "main.date=#{build_date}",
    ]
    system "go", "build",
           "-trimpath",
           "-ldflags", ldflags.join(" "),
           "-o", bin/"boozle",
           "./cmd/boozle"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/boozle --version")
    assert_match "no PDF given", shell_output("#{bin}/boozle 2>&1", 2)
  end

  livecheck do
    url :stable
    strategy :github_latest
  end
end
