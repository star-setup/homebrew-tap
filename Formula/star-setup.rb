class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo CMake ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "0c157863a262067a3a920c28d3d37e122a4f9f2020c5c89d385c83140b0bcdbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "bbd52026610efc241eda8a6eb9432489afa1861199c7d5d25934efb982461922"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1fc4e598e012b26a291fa05fbe4540b2935f6366edd2eafc7a7ac43372de4d04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c61d3468b06c4ce002054c360bbc4df538ff413f3ff44bcd5b0b090b8e8bbcb"
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
