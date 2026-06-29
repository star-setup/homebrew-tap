class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.5/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "7a0e3d72d5ffd293130483fd100d3ca8a8b30c19e728e46a66caeb2a7e5e1d92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.5/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "e28ec44d9e09c538aad3c645cbea28d16b4f55bcb8b74e61d37f0a9c3aaaea8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.5/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "daf8d75ef300960ae2ee4c2136b953916829e91c61ee12d3c028fd2623aafff7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.5/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c6f90db2519c849fb8bc031a66363e6e591cd4fdb59206d4aaf069055476b092"
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
