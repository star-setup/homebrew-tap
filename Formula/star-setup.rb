class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "68479a3eac47107f2255684d9ee9ae64d08400996a1894bd9b0985718dd324be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "49916751e5d1f25f14d32c593b27b2a8f098720506a766d89ed242c8e41968f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c991c61adb6baaada46160301bf6fe8b35eddf3bb543c00f97d486a904b10da1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "83f4d549ceb2a7314157da6592ae7360e5ae5ce1f01ed8e85ef04729d8a88692"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "star-setup" if OS.mac? && Hardware::CPU.arm?
    bin.install "star-setup" if OS.mac? && Hardware::CPU.intel?
    bin.install "star-setup" if OS.linux? && Hardware::CPU.arm?
    bin.install "star-setup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
