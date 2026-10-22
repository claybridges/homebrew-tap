class GitFolder < Formula
  desc "Manage groups of git branches as folders"
  homepage "https://github.com/claybridges/git-folder"
  url "https://github.com/claybridges/git-folder/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b89826a1f39af0cd7f81b3192d41ae3e5577c6c937f8876ff48dc8aa1dfe929f"

  license "MIT"
  head "https://github.com/claybridges/git-folder.git", branch: "main"

  depends_on "go" => :build

  def install
    git_version = if build.head?
      described = Utils.safe_popen_read("git", "describe", "--tags", "--always", "--dirty").chomp
      described.empty? ? "main" : described
    else
      version.to_s
    end
    ldflags = "-s -w -X main.version=#{git_version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/git-folder"
    man1.install "git-folder.1"
    generate_completions_from_executable(
      bin/"git-folder", "completion", shells: [:zsh], shell_parameter_format: :none
    )
  end

  test do
    assert_match "usage: git folder", shell_output("#{bin}/git-folder --help 2>&1")
    refute_match "dev", shell_output("#{bin}/git-folder --version")
  end
end
