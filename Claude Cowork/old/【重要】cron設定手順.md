# 田村新聞 自動デプロイ設定手順

## 全体の流れ

```
毎朝 10:04 → Claude が HTML 生成 → Coworkフォルダに index.html 保存
毎朝 10:10 → Mac の cron が deploy-tamura-shinbun.sh を実行 → Netlify を更新
     ↓
https://starlit-strudel-55b0ba.netlify.app が最新号に更新される
```

---

## cron の設定（1回だけ実施）

### 1. ターミナルを開く

### 2. crontab を編集
```bash
crontab -e
```

### 3. エディタが開いたら以下を追記
```
10 10 * * * /bin/bash "/Users/kensuketamura/Desktop/DIVE/Claude Cowork/deploy-tamura-shinbun.sh" >> /tmp/tamura-deploy.log 2>&1
```

### 4. 保存して終了
- vimが開いた場合：`i` で入力モード → 貼り付け → `Esc` → `:wq` → Enter
- nanoが開いた場合：貼り付け → `Ctrl+X` → `Y` → Enter

### 5. 確認
```bash
crontab -l
```
上記の行が表示されれば設定完了。

---

## 動作確認（手動テスト）

```bash
bash "/Users/kensuketamura/Desktop/DIVE/Claude Cowork/deploy-tamura-shinbun.sh"
```

成功すると `https://starlit-strudel-55b0ba.netlify.app` が更新される。

---

## ログ確認

```bash
cat /tmp/tamura-deploy.log
```

---

## URL（ブックマーク推奨）

https://starlit-strudel-55b0ba.netlify.app
