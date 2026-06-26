class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.1/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "933b7e84a8ad52657c7766f8b021485c2a0104af4222d1f2e96ca1e8e5e37470"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.1/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "f20d4b533d903022aad3e9424c77528cb8de89192dedbdc123ae0f95b21fb61d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.1/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c68704e509268fd64d5b5965935061a743e99580ed58ce91d0b04ae130652d08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.1/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e6e4e05e8f845eccd0590d8a18e6cfc2206568550892fe6d82262b77352e679"
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
