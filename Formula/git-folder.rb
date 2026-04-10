class GitFolder < Formula
  desc "Manage groups of git branches as folders"
  homepage "https://github.com/claybridges/git-folder"
  url "https://github.com/claybridges/git-folder/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "23664cc3d494b6e7a1a1077f8e22b9b6bf6e519ce62a83f9e821e5c4ec1558f4"
  version "0.1.0"

  head "https://github.com/claybridges/git-folder.git", branch: "main"
  license "MIT"

  depends_on "go" => :build

  def install
    git_version = Utils.safe_popen_read("git", "describe", "--tags", "--always", "--dirty").chomp
    git_version = "main" if git_version.empty?
    ldflags = "-s -w -X main.version=#{git_version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/git-folder"
    man1.install "git-folder.1"
  end

  test do
    assert_match "usage: git folder", shell_output("#{bin}/git-folder --help 2>&1")
  end
end
