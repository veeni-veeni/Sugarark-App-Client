# Sugarark-App-Client 不变量清单

> 进本仓动手前必扫一遍。≤80 行能扫完。
>
> 本清单只补 **User App Flutter 客户端子仓特有规则**。主项目不变量在 `sugarark/docs/INVARIANTS.md`，CRM 不变量在 `sugarark/docs/crm/INVARIANTS.md`，两者对本仓**仍然有约束力**。
>
> 无 ADR 的项标 `[来源: 2026-05-08 设计讨论, 待补 ADR]`。

## 项目本质（不变）

```
Sugarark-App-Client = SugarArk 平台面向 daddy/baby 客户的 Flutter App。
仅 iOS / Android (V1 不做桌面)。
跟 Web / TG Mini App 多端并存，三端共后端共 IM 流。
所有架构权威在主仓 sugarark；跟姊妹仓 staff 共享 IM core (lazy extraction)。
```

## ❌ 永远不做（Flutter 子仓特有）

| # | 规则 | 来源 |
|---|---|---|
| 1 | 在客户端硬编码 talkcore Internal JWT / app_secret / 任何 talkcore 平台密钥 | 主仓 CRM INVARIANT 5 |
| 2 | 客户端直接调 talkcore OpenAPI (要发消息走 talkcore WS, 业务操作走 sugarark REST) | 主仓 ADR-0013 |
| 3 | 客户端绕过 sugarark 后端拿 IM Token (必须走 `/api/v1/im/token` 端点) | 主仓 ADR-0013 / CRM INVARIANT 6 |
| 4 | 一个 user 同时持有多个 im_user 的 token (1:1 映射不可破) | 主仓 ADR-0009 |
| 5 | 改主仓 (sugarark) 任何文件 / schema / API 契约 (必须 HALT) | 本仓 AGENTS.md |
| 6 | 改 talkcore 仓任何代码 (必须 HALT) | 本仓 AGENTS.md |
| 7 | 改姊妹仓 sugarark-staff-client 任何文件 (走 OPEN_QUESTIONS) | 本仓 AGENTS.md |
| 8 | 在本仓重新做主仓已有的业务规则 (匹配 / 视频权限 / 交友墙状态机) | 主仓 CLAUDE.md |
| 9 | 把 phone_number / wechat_id 持久化到本地存储 | 主仓主项目 INVARIANTS |
| 10 | 把视频认证原文 / 用户照片原文 缓存到本地未鉴权位置 | 主仓主项目 INVARIANTS + 隐私 |
| 11 | 加桌面端 (mac/win) 构建支持 — V1 仅 iOS/Android | 主仓 ADR-0012 + 本仓 MISSION |
| 12 | 加 admin 视图 / advisor 视图 / 多频道 UI / Telegram/WhatsApp bridge 实现 | 主仓 ADR-0005,0006,0008 |
| 13 | 群聊渲染时含 advisor 身份成员而不显示标签 (跟 staff 端规则对偶) | 主仓 ADR-0007 |
| 14 | 客户端发消息时传 sender_id (sender 由 IM Token 决定) | 主仓 ADR-0003 |
| 15 | 引入 Flutter 之外的运行时 (RN / 原生壳) — V1 单一代码库 | 主仓 ADR-0012 |
| 16 | 自建 IM 协议 (用 talkcore，不另起炉灶) | 主仓 ADR-0013 |
| 17 | 实现 App 内支付 / 会员等级自动升降 (会员人工录入策略不变) | 主仓主项目 CLAUDE.md |
| 18 | 用 App 替代 TG Mini App / Web (并存策略，不替代) | 本仓 MISSION |
| 19 | 直接 import 姊妹仓 staff 代码 (lazy extraction 用复制粘贴) | 主仓 CRM ADR-0015 |
| 20 | 在客户端做敏感数据完整性校验取代后端校验 (年龄 18+ / mutual match 在后端) | 主仓主项目 INVARIANTS |

## ✅ 永远要做（Flutter 子仓特有）

| # | 规则 | 来源 |
|---|---|---|
| 1 | user JWT + IM Token 存到平台 secure storage (keychain / android keystore) | [来源: 2026-05-08 待补 ADR] |
| 2 | IM Token 过期前主动续签 (剩余 < 5 分钟时刷新) | 主仓 CRM INVARIANT |
| 3 | WS 断线后指数退避重连 (1s / 2s / 5s / 15s / 30s 上限) | [来源: Phase 2.5.3 待补 ADR] |
| 4 | 离线期间未拉取的消息在重连后按 server_msg_id 顺序补全 | 主仓 CRM INVARIANT 13 |
| 5 | 所有跟主仓 API 交互按 v1ResponseWrapper 包装格式解析 | 主仓 ADR-0014 / CRM ADR-0014 |
| 6 | 同一 user 在 App / Web / TG Mini App 多端登录用同一 im_user_id | 主仓 ADR-0013 |
| 7 | 群聊渲染时按主仓 ADR-0007 规则显示成员身份标签 | 主仓 ADR-0007 |
| 8 | 推荐 baby 富消息卡片按 schema_version=1 框架渲染 (跟 staff 同 schema) | 主仓 OPEN_QUESTIONS Q-006 |
| 9 | lib/core/ 放共享 IM 集成代码 (将来 lazy extraction) | 主仓 CRM ADR-0015 |
| 10 | 视频认证素材上传走 sugarark 现有鉴权 /api/uploads 路径 | 主仓主项目 CLAUDE.md |
| 11 | 媒体显示用鉴权 URL，禁止暴露 /uploads/ 直链 | 主仓主项目业务约束 |
| 12 | 涉及主仓 / talkcore / 姊妹仓的改动一律走主仓 ADR / OPEN_QUESTIONS | 本仓 AGENTS.md |
| 13 | commit 消息带 `[claude]` / `[codex]` / `[human]` 标签 + 关联 ADR/TASK | AGENTS.md |
| 14 | 任何架构变更先写 ADR proposed → 用户裁决 → 改 INVARIANTS → 才动代码 | AGENTS.md |

## 📐 设计目标（性能 / UX）

| # | 目标 | 备注 |
|---|---|---|
| 1 | Flutter 冷启动 < 3s (移动) | 性能基线 |
| 2 | 消息发送 → 顾问收到 < 500ms (含 sugarark proxy + talkcore 一跳) | 主仓 CRM 设计目标 |
| 3 | 推送到达率 > 90% (FCM + APNs) | 用户留存 |
| 4 | 视频上传支持断点续传 / 进度可见 | 视频认证 UX |
| 5 | iOS / Android 核心交互行为一致 | UX 一致性 |

## 🔄 遇到这些情况的标准动作

| 场景 | 动作 |
|---|---|
| 想改主仓 / talkcore 代码 | HALT → docs/halt/ → 等用户 |
| 想改姊妹仓 staff 代码 | HALT → docs/halt/ → 等用户切上下文 |
| 想推翻主仓 ADR | 不在本仓决定 → 在主仓提新 ADR |
| 看到 IM Token / Internal JWT 出现在客户端代码 | 立刻挑战 / 修 / 写 INVARIANT |
| 看到敏感字段被持久化 | 立即修 |
| 不确定 / 方向问题 | HALT signal |

## 何时更新

- 新 accepted 主仓 ADR 影响本仓约束 → 加一行
- 本仓自己的新 ADR (Flutter 专属) → 加一行
- 季度复读

**本文件不超过 80 行（当前约 78 行）**。超了说明蒸馏失败，重组。

---

> 借口反驳总册：`~/.claude/refs/anti-rationalization.md`（v4.6 归集为全局元规则文件，本 INVARIANTS 只留核心红线）。
