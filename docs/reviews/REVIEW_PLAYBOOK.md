---
maintainer: codex
contributors: claude (via proposal only)
last-updated: 2026-05-13
status: stub
referenced-by:
  - docs/reviews/findings/
  - agents/reviewer.md
  - ~/.claude/refs/review-playbook-template.md
---

# Sugarark-App-Client Review Playbook

> 基于全局模板 `~/.claude/refs/review-playbook-template.md`。
> 本文件含 Flutter User App 特定边界 + checklist + invariant 候选。
>
> **主维护者：Codex（reviewer 角色）**——Claude 可提议但不直接大改。

## 状态：STUB

下次 Codex 跑 L3 review 时按全局模板填充本文件。

## 复用全局模板的部分

- L1-L4 review 层级 → 见全局 §1
- Priority P0/P1/P2/P3 → 见全局 §2
- Finding 模板（Status / Baseline）→ 见全局 §3
- 沉淀通道（≥2 次规则）→ 见全局 §4
- 通用 baseline 清单 → 见全局 §7

## Flutter User App 特定 L3 必查清单（待填）

### 项目本质
参考 `docs/MISSION.md` + `docs/INVARIANTS.md`。

### 项目特定边界（待 Codex 首次 L3 review 后填）

- IM Token 持久化策略
- 客户敏感字段缓存策略
- 跨平台行为一致性
- talkcore WS 重连 / 离线处理
- 视频认证录制 / 上传安全
- 推送 token 管理（FCM / APNs）

## Invariant / Test 候选

| 候选 | 类型 | 检查什么 |
|---|---|---|
| _（待填）_ | | |
