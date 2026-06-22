class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo CMake ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "e4b3dc71e2bb9aebc3b87793a22c32cf5dc97f7258ae1108de87c81666b07ae7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "e20456d1d048410a54e92b0d1b702c7862da86b9b9bf95669f5801d7634dfd3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93daa4569543be33bdfe8026f75674d9a90ae4c55af90fdc1b0be00696154edb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.1.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0351b08e855a4d1f3dcebfd1f185fdf9b8c3e4c29f354f76fe2f1e150940b304"
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
