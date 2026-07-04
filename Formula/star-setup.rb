class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.5/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "b3eff078859ab8d2e787520e6924d885680a96632ac09610fcd89f7a6ee6d087"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.5/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "87678b90c3fe62ef21488b90ee2f526f3a51ea5a777d8162a72a469828dfafdf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.4.5/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7eeda37ee9dcb66b05275825e7cff51b7b80638fc6c043273df5845d83a098f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.4.5/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3346e1f489c397403fe15115430b7f918f83e0f3d6dc57be9f84e2b1d61f887f"
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
