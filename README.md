# 👮‍♂️プルリク警察

このアクションはリリースブランチに対しての変更を検知して、開発ブランチまでその変更を反映させるプルリクを作成します。

## Inputs

## `repo`
**Required** リポジトリ名。  

## `token`
**Required** トークン。  

## `current_branch`
**Required** マージされたリリースブランチ。  

## `release_branch_regexp`
**Required** リリースブランチ検索用正規表現。  
デフォルトは`^release-\d+\.\d+\.\d+\.\d+$`

## `pr_title`
**Required** プルリクのタイトル。  
デフォルトは`リリースブランチの変更を検知しました`

## `pr_body`
プルリクの本文。

## `protected`
プロテクトブランチに絞り込むかどうか。

## 使用例

```.github/workflows/main.yml
on:
  pull_request:
    branches:
      - 'release-**'
    types: [closed]

jobs:
  pullreq_police:
    runs-on: ubuntu-latest
    if: github.event.pull_request.merged == true
    name: pullreq police
    steps:
      - name: Extract branch name
        shell: bash
        run: echo "branch=${GITHUB_REF#refs/heads/}" >> $GITHUB_OUTPUT
        id: extract_branch
      - name: pullreq_police
        id: pullreq_police
        uses: hayashima/pullreq_police@1.0.0
        with:
          repo: ${{ github.repository }}
          token: ${{ secrets.GITHUB_TOKEN }}
          current_branch: ${{ steps.extract_branch.outputs.branch }}
          release_branch_regexp: '^release-\d+\.\d+\.\d+\.\d+$'
          pr_title: 'リリースブランチの変更を検知しました'
          pr_body: '速やかにマージしてください。'
          protected: true
```
