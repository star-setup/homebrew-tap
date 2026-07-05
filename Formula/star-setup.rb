class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.4.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.9/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "52faf21793cfb6564215a010f43122427b9249072d3d0cfb88e87088767011fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.9/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "21bd475e8048b77fb6c12a8e32e9a8d1093fc61c00956fd341694eaf828ab51e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.9/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "402cba7bb8fdb45a921af1d5564ce32eea5a5fb492038d72480b7698dc776b86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.9/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d81e05cd1ed2d6f0897d04f6f9e18edbb0c47621e52474047b4d147983300c8f"
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
