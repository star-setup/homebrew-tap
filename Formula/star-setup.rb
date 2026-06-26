class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "31aadba5d431b1385f68d2a459bd72ea9bcacd602ba0127d93a76e9154dbf51c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "c9c2681e94233c2c307af1efd4b15f690b5e605cf30da9a3550a993a00a06f3a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c238c4c87035c89fddae271f96de08f0120f192249cba4db6144ef09a1710996"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc9660e47ea3be0d435d04ff0bef916c3cf82302a6860eb140e228e4abc0d7e3"
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
