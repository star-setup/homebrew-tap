class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.3/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "4c8cf56aba6552a6a54d339fef11670de7b5a3bf1037cb79b1c9a1dcf8724f83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.3/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "93fbd48e98c708b81a67b2b00bc194fc6bfb6bb1c7d81714b1377f12afa3497f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.3/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77f0b75f085f33657c0ec97bf4c0396902df400e8c447f88fb5cb277a6e197c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.3/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff40c112fefcade1aab37bd60826d9e82c82450d6b671ada4d14ab801a5ed628"
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
