class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.3/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "7fc52f1e5437fc94720edffa538a2303173b9e5ce6f034a97094d830c504e9a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.3/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "ca508d5e7416e8d526a2b8a61c3438a184c6fa860f436bcaa0dc22823e452809"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.3/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "36d71a15ddfcfa7412937cd5a3c137bb1a67e0c6774fb6ec087adc2e7384344f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.3/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "933022083d6c5ffe90e9677f6785f3787781966d6729a0e46493e9f7ffc1573b"
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
