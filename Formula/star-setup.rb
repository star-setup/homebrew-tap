class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.4.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.6/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "7bd1e4bef00adf1bab96d817402bb97b42dff89e345d208d1c5d7329ceed4d0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.6/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "1e00640b55bc62f2f6c6d79ece7b3b1f9e4769ca8ee0d958699be5eaa7e447c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.6/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f08c56fe83e61cc9fbbe7634a58ecbf3741c3769fdd999b4305c4a12bc4915cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.6/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34e6cf3f208c1fcc5090edf65c581918d0dba227f5a9601f6d55069d098547dd"
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
