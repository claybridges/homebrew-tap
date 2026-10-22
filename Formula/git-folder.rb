class GitFolder < Formula
  desc "Manage groups of git branches as folders"
  homepage "https://github.com/claybridges/git-folder"
  url "https://github.com/claybridges/git-folder/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b89826a1f39af0cd7f81b3192d41ae3e5577c6c937f8876ff48dc8aa1dfe929f"
  version "0.2.0"

  head "https://github.com/claybridges/git-folder.git", branch: "main"
  license "MIT"

  depends_on "go" => :build

  def install
    git_version = if build.head?
      Utils.safe_popen_read("git", "describe", "--tags", "--always", "--dirty").chomp.then { |v| v.empty? ? "main" : v }
    else
      version.to_s
    end
    ldflags = "-s -w -X main.version=#{git_version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/git-folder"
    man1.install "git-folder.1"
  end

  test do
    assert_match "usage: git folder", shell_output("#{bin}/git-folder --help 2>&1")
  end
end
