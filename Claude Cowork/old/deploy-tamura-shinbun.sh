#!/bin/bash
# ============================================
# 田村新聞 自動デプロイスクリプト (Mac用)
# 毎朝 10:10 に cron から実行される
# ============================================

COWORK_DIR="/Users/kensuketamura/Desktop/DIVE/Claude Cowork"
TOKEN="nfp_ebQRRpPdyKjcibnjitr7NeMky1P5nGExc5dd"
SITE_ID="3ca24803-ddc8-4012-be63-4f29b3ea5d26"
LOG="/tmp/tamura-shinbun-deploy.log"

echo "========================================" >> "$LOG"
echo "$(date '+%Y-%m-%d %H:%M:%S') デプロイ開始" >> "$LOG"

# index.html が存在するか確認
if [ ! -f "$COWORK_DIR/index.html" ]; then
    echo "ERROR: index.html が見つかりません" >> "$LOG"
    exit 1
fi

# フォルダ全体をzip（index.html + archive.html + archives/フォルダ）
cd "$COWORK_DIR"
zip -r /tmp/tamura-deploy.zip index.html archive.html archives/ >> "$LOG" 2>&1

# Netlify へデプロイ
RESULT=$(curl -s \
  -H "Content-Type: application/zip" \
  -H "Authorization: Bearer $TOKEN" \
  --data-binary @/tmp/tamura-deploy.zip \
  "https://api.netlify.com/api/v1/sites/$SITE_ID/deploys")

DEPLOY_URL=$(echo "$RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('deploy_ssl_url', d.get('error','不明')))" 2>/dev/null)

echo "デプロイ結果: $DEPLOY_URL" >> "$LOG"
echo "$(date '+%Y-%m-%d %H:%M:%S') 完了" >> "$LOG"

# 一時ファイル削除
rm -f /tmp/tamura-deploy.zip

echo "✅ 田村新聞デプロイ完了: $DEPLOY_URL"
