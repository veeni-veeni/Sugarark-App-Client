# Out of Scope — 永不做归档（Sugarark-App-Client）

> "永远不该考虑"的想法归档。跟 `docs/changes/archived/`（CR rejected）不一样。

## 怎么用

```bash
echo "<想法 + 为什么永远不做>" > docs/.out-of-scope/<YYYY-MM-DD>-<slug>.md
```

## 跟其他目录的区别

| 目录 | 用途 | 复活路径 |
|---|---|---|
| `docs/changes/archived/` | CR rejected / superseded | 立新 CR |
| `docs/.out-of-scope/` | 永远不做 | **没有**——MISSION 改了才考虑 |
| `docs/halt/` | agent 自决不了 → 等用户 | 用户处理后归档 |

## 本仓特定例子（永不做的）

- 不在客户端硬编码 talkcore 平台密钥
- 不在客户端直连 PostgreSQL（必经 sugarark backend）
- 不实现 admin 后台功能（不同 JWT / 不同角色）
- 不持久化 phone_number / wechat_id 到本地存储
