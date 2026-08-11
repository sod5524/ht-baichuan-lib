#!/bin/bash
set -e

POD_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep "s.version" "$POD_DIR/ht-baichuan-lib.podspec" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
REMOTE_URL="https://github.com/sod5524/ht-baichuan-lib.git"

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

# 3. Git 初始化（如果还没有）
if [ ! -d ".git" ]; then
  echo ">> git init ..."
  git init
fi

# 4. 添加、提交
echo ">> git add & commit ..."
git add -A
git commit -m "Release ht-baichuan-lib $VERSION" || echo "(nothing to commit)"

# 5. 打 tag（先删除旧 tag 再重建，避免冲突）
echo ">> git tag $VERSION ..."
git tag -d "$VERSION" 2>/dev/null || true
git tag "$VERSION"

# 6. 设置 remote 并推送
echo ">> git remote ..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"

echo ">> git push ..."
git push -u origin main --force --tags

echo ""
echo "== 推送完成 =="
echo "Repo: $REMOTE_URL"
echo "Tag:  $VERSION"
echo ""
echo "后续步骤:"
echo "  1. pod trunk register 你的邮箱 '你的名字'    # 首次需注册"
echo "  2. pod trunk push ht-baichuan-lib.podspec --allow-warnings"
echo "     (注意: Masonry 编译问题可能导致验证失败)"