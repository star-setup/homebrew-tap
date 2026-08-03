class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.6.1/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "3d77004a15cad3cc9fd317846112685a24de5603ab696eb0fc297dd33fcae0d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.6.1/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "a349519edbb5b1622cdbbaf5f94db9284631eeb876d367ad21dba62afb5eb0db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.6.1/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "328a6bf7c0a89c06d10184bcda06065fda205d83500536b194384a65eec15a53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.6.1/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f0ff22fc1ba1430eaa40f1988bc8264e92687560557a5d97b78b91cc07260cd7"
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
