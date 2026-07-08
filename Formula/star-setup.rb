class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.5.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "369dfb2bbefa5eee6905b75a69dd4f22042822a061fe48c865981c8698d2baf2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.5.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "a01844c9a95442f1ac43e3ddda774f31c850b1cb82900d2616e411dd66f899a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.5.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52cdbb7f13c0e23ea5f3657361e1541d818ba254ce2c2733e201f9ef213644b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.5.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "259aed7a6f6b659c609c483eca767df3af77489785ec433614b010e992b55a59"
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
