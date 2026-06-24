class StarSetup < Formula
  desc "Lightweight CLI to clone, configure, and wire single or multi-repo CMake ecosystems"
  homepage "https://github.com/star-setup/core"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.2.0/star-setup-aarch64-apple-darwin.tar.xz"
      sha256 "b5e002ab5531c173aad85d771136b043c12596be610d7f36473171e673a899b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.2.0/star-setup-x86_64-apple-darwin.tar.xz"
      sha256 "cf67a8921532db3e185ca6d422626cdacdc9a4c4556496359a79644714fa965e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/star-setup/core/releases/download/v0.2.0/star-setup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc8ec58197b0a9b5d1ffa479e9f1a9cd1631e808d52b65d29edeec997e15511f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/star-setup/core/releases/download/v0.2.0/star-setup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa972520940d05988a47be25185cf8631c262a23667aa199219a8cebed2fb7e2"
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
