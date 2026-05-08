# Architecture Decision Records (ADR) — Sugarark-App-Client

每条架构决策一份文件。文件名 `NNNN-short-kebab-title.md`，编号严格递增，
不复用、不删除（被替代的改 status: superseded）。

**本仓只放 User App Flutter 客户端专属决策**（状态管理 / 路由 / 持久化 / 推送 / 视频认证 SDK / iOS Android 平台差异化）。

业务规则、API 契约、IM 协议、跨两个 Flutter 仓的决策一律写到主仓 `sugarark/docs/decisions/` 或 `sugarark/docs/crm/decisions/`。

---

## 索引

> 暂无本仓 ADR — Phase 2.5.1 启动时首批 ADR 落地。

| # | 标题 | 状态 | 作者 | 日期 |
|---|---|---|---|---|
| _(empty)_ |  |  |  |  |

### Phase 2.5.1 启动时预期写入

```
ADR-0001  状态管理选型 (Q-Flutter-001, 倾向跟 staff 同方案)
ADR-0002  路由方案 (Q-Flutter-002, 倾向跟 staff 同方案)
ADR-0003  本地持久化方案 (Q-Flutter-003, 倾向跟 staff 同方案)
ADR-0004  secure storage 选型 (Q-Flutter-004)
ADR-0005  底部 Tab 数量与命名 (Q-Flutter-005)
ADR-0006  测试策略基线 (Q-Flutter-007)
ADR-0007  WS 重连退避具体值 (Q-Flutter-008)
ADR-0008  推送方案 FCM + APNs (Q-Flutter-009)
ADR-0009  视频认证录制 SDK (Q-Flutter-010)
```

---

## 引用的主仓 ADR (本仓不复述)

```
sugarark/docs/decisions/0011-sugarark-app-as-separate-repo.md
sugarark/docs/decisions/0012-flutter-for-sugarark-app.md
sugarark/docs/decisions/0013-talkcore-as-app-im-substrate.md
sugarark/docs/decisions/0014-app-auth-existing-jwt.md
sugarark/docs/decisions/0015-shared-backend-for-three-ends.md
sugarark/docs/decisions/0016-talkcore-webhook-handler-location.md

sugarark/docs/crm/decisions/0007-wechat-work-style-groups.md
sugarark/docs/crm/decisions/0009-minimal-conversation-meta.md
sugarark/docs/crm/decisions/0010-external-users-not-in-groups.md
sugarark/docs/crm/decisions/0011-ai-takeover-auto-reply.md
sugarark/docs/crm/decisions/0012-calendar-and-reminders.md
sugarark/docs/crm/decisions/0014-keep-advisor-endpoints-deprecate-im-parts.md
sugarark/docs/crm/decisions/0015-user-app-same-agent-lazy-extraction.md
```

---

## 状态机

```
proposed   提议中，等用户/另一 agent 评审
accepted   已通过，正在或已经实施
superseded 被某新 ADR 替代（指明 NNNN）
deprecated 不再适用
rejected   提议被拒，留作历史避免反复评估
```

---

## 模板

```markdown
# NNNN <标题>

- **状态**: proposed | accepted | superseded by NNNN | deprecated | rejected
- **日期**: YYYY-MM-DD
- **作者**: claude | codex | <human>
- **相关**: 引用的主仓/本仓 ADR / commit / issue / PR

## 背景
为什么要做这件事。

## 决定
选了什么。

## 考虑过的替代方案
- A: ... → 不选因为 ...
- B: ... → 不选因为 ...

## 后果
**正面**: ...
**负面 / 取舍**: ...
**反向退出条件**: ...
```
