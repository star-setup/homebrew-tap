class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.2/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "6b9ea6f4809774baacb3e0adc5695f9456189ff2b27720a42d2d1d2823e45ee1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.2/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "b75c3f4deab5aa0031e8949cb08827946857fd2a6987bfa648072c2e2f7c2d9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.3.2/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad670c863f3f486620241a88d81aecf6c80f95e42a44f439b7990632cb1c91b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.3.2/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ac41636000f71c639cefb2b003a13f8c0eaaae2fe2f90368aa03e6713abe771"
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
