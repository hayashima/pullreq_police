require 'octokit'

# コマンドライン引数から取得
github_token, repo, current_branch, release_branch_regexp, title, body, protected = ARGV

client = Octokit::Client.new(access_token: github_token)

all_branches = []
# 100件ずつしか取得できないので取得できなくなるまでループさせる
loop.with_index(1) do |_, page|
  branches = client.branches(repo, per_page: 100, page: page, protected: protected).map(&:name)
  all_branches += branches
  break if branches.size < 100
end

# リリースブランチの正規表現に合致するものだけに絞り、リリース番号でソートする
i = 0
release_branches = all_branches.select { |branch_name| branch_name.match?(release_branch_regexp) }
                               .sort_by { |v| [*v.scan(/\d+/).map(&:to_i), i += 1] }

index = release_branches.index(current_branch)
exit(1) if index.nil? # indexがnilになることは基本的にありえないので異常系で終了させる

# リリース番号的に次のブランチを取得、なければデフォルトブランチを取得
to_branch = release_branches[index + 1] || client.repo(repo).default_branch
# プルリクを作成
client.create_pull_request(repo, to_branch, current_branch, title, body)
