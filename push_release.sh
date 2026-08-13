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

# 7. 验证远端分支与 tag 是否推送成功
echo ""
echo "== 验证 Git 推送结果 =="
sleep 2
BRANCH_OK=$(git ls-remote --heads origin "$BRANCH" 2>/dev/null | grep -c "refs/heads/$BRANCH")
TAG_OK=$(git ls-remote --tags origin "$VERSION" 2>/dev/null | grep -c "refs/tags/$VERSION")
if [ "$BRANCH_OK" -ge 1 ] && [ "$TAG_OK" -ge 1 ]; then
  echo "✅ 分支 $BRANCH 与 tag $VERSION 已确认存在于远端"
else
  echo "❌ 远端验证失败 (branch 命中: $BRANCH_OK, tag 命中: $TAG_OK)"
  echo "   请检查网络或 GitHub 仓库权限后重试"
  exit 1
fi

# 8. pod trunk push 发布到 CocoaPods
echo ""
echo "== pod trunk push 发布 $VERSION =="
pod trunk push "$POD_DIR/ht-baichuan-lib.podspec" --skip-import-validation --allow-warnings
PUSH_RC=$?
if [ "$PUSH_RC" -ne 0 ]; then
  echo "❌ pod trunk push 失败 (exit $PUSH_RC)"
  echo "   常见原因：libarclite 未补全 / 网络无法连接 github.com:443 / 验证编译报错"
  exit 1
fi

# 9. 验证 trunk 发布结果
echo ""
echo "== 验证 trunk 发布 =="
sleep 3
if pod trunk info ht-baichuan-lib 2>&1 | grep -qE "^- $VERSION"; then
  echo "✅ ht-baichuan-lib $VERSION 已成功发布到 CocoaPods Trunk"
else
  echo "❌ 未能确认 $VERSION 出现在 trunk，请手动检查: pod trunk info ht-baichuan-lib"
  exit 1
fi

echo ""
echo "== 发布完成 =="
echo "Tag:    $VERSION"
echo "Repo:   https://github.com/$REPO"
echo "Trunk:  https://cocoapods.org/pods/ht-baichuan-lib"