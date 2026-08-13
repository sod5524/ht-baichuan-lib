#!/bin/bash
set -e

# ⚠️ 安全要求：GitHub Personal Access Token 必须通过环境变量 GITHUB_TOKEN 提供，
#    严禁硬编码进脚本/提交到仓库（GitHub Push Protection 会拦截含 token 的提交）
POD_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep "s.version" "$POD_DIR/ht-baichuan-lib.podspec" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
REPO="sod5524/ht-baichuan-lib"

echo "=="
echo "== ht-baichuan-lib $VERSION 发布脚本"
echo "=="

cd "$POD_DIR"

# 1. 清理冗余文件
echo ">> 清理 .DS_Store / .gitkeep ..."
find . -name ".DS_Store" -delete 2>/dev/null || true
find . -name ".gitkeep"   -delete 2>/dev/null || true

# 2. 创建 .gitignore
cat > .gitignore <<'IGNORE'
.DS_Store
*.gitkeep
IGNORE

# 3. Git 初始化
if [ ! -d ".git" ]; then
  echo ">> git init ..."
  git init
fi

# 4. 添加、提交
echo ">> git add & commit ..."
git add -A
git commit -m "Release ht-baichuan-lib $VERSION" || echo "(nothing to commit)"

# 5. 打 tag
echo ">> git tag $VERSION ..."
git tag -d "$VERSION" 2>/dev/null || true
git tag "$VERSION"

# 6. 设置 remote 并推送（使用 SSH 认证，公钥 ~/.ssh/id_rsa.pub）
git remote remove origin 2>/dev/null || true

REMOTE_URL="git@github.com:$REPO.git"
echo ">> 使用 SSH 推送: $REMOTE_URL"
git remote add origin "$REMOTE_URL"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo ">> git pull --rebase (branch: $BRANCH) ..."
git pull --rebase origin "$BRANCH" 2>/dev/null || echo "(no remote changes or rebase failed, will force push)"

echo ">> git push (branch: $BRANCH) ..."
git push -u origin "$BRANCH" --tags --force

echo ""
echo "== 推送完成 =="
echo "Tag:  $VERSION"
echo "Repo: https://github.com/$REPO"