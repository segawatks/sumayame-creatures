#!/bin/bash
cd ~/Desktop/sumayame_entry || exit 1

# ロックファイルを自動削除
rm -f .git/HEAD.lock .git/index.lock .git/refs/heads/*.lock 2>/dev/null

# 初回だけ：gitの初期化とリモート設定
if [ ! -d .git ]; then
  git init -b main
fi
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "GitHubリポジトリのURLを貼り付けてEnter"
  echo "（例：https://github.com/ユーザー名/sumayame-entry.git）"
  read -p "> " REPO_URL
  git remote add origin "$REPO_URL"
  # GitHub側に先にファイルがある場合は取り込む
  git fetch origin main 2>/dev/null && git reset --soft origin/main 2>/dev/null
fi

# .DS_Store は上げない
grep -qx ".DS_Store" .gitignore 2>/dev/null || echo ".DS_Store" >> .gitignore
git rm -r --cached --quiet --ignore-unmatch .DS_Store fish/.DS_Store 2>/dev/null

git add .
git commit -m "update $(date '+%Y-%m-%d %H:%M')"
git push -u origin main
echo ""
echo "✅ Push完了！ 1〜2分後にGitHub Pagesに反映されます"
read -p "Enterキーで閉じる..."
