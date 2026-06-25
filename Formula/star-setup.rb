class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.2.1/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "1d10b58b9a59a0ce371bbde7dedc8125e0c96cd9ccb6fac43539cf08a77a5f9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.2.1/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "ee945b7d875aad406ab3cab57e4b64cf15f911da1dfa1a6f9a38f30c398d89ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.2.1/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98aa72785f03e0e7a3b9a487f0ff62fefeba91201ff33879bd486f981792f954"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.2.1/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90e7a085ce9f2b83deaab7bc758ddf3609aaf1f99ed98edab829bed516d2f337"
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
