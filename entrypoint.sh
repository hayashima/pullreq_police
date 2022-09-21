#!/bin/sh -l

cd /pullreq_police
bundle install
bundle exec ruby main.rb "$INPUT_TOKEN" "$INPUT_REPO" "$INPUT_CURRENT_BRANCH" "$INPUT_RELEASE_BRANCH_REGEXP" "$INPUT_PR_TITLE" "$INPUT_PR_BODY" "$INPUT_PROTECTED"
