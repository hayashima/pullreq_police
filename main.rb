require 'octokit'

# コマンドライン引数から取得
github_token, repo, current_branch, release_branch_regexp, title, body, protected = ARGV

client = Octokit::Client.new(access_token: github_token)

all_branches = []
# 100件ずつしか取得できないので取得できなくなるまでループさせる
loop.with_index(1) do |_, page|
  branches = client.branches(repo, per_page: 100, page: page, protected: protected).map(&:name)
  break if branches.size == 0

  all_branches += branches
end

# リリースブランチの正規表現に合致するものだけに絞る
release_branches = all_branches.select { |branch_name| branch_name.match?(release_branch_regexp) }

# 万が一でもリリースブランチ以外で実行されないように条件分岐
if release_branches.include? current_branch
  # リリース番号が現在より大きいものの中で最小のもの、なければ開発ブランチを取得
  to_branch = release_branches.select(&current_branch.method(:<)).min || client.repo(repo).default_branch
  # プルリクを作成
  client.create_pull_request(repo, to_branch, current_branch, title, body)
end
