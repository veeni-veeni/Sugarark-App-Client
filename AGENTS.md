# AGENTS.md — Sugarark-App-Client 多 AI 协作规范

> 本仓的所有 AI 工作遵循 MAP v2 协议。主项目 (sugarark) AGENTS.md 在 `sugarark/AGENTS.md`，CRM 子模块 AGENTS.md 在 `sugarark/docs/crm/AGENTS.md`，**本文件不覆盖那两个**，只补 User App Flutter 子仓特有约定。

---

## 进本仓工作流第一件事（每次会话开始必做）

按 3 层信息架构读：

**第 1 层（身份 + 不变量，每次必读）：**
1. `CLAUDE.md`（本仓身份，本目录）
2. `docs/INVARIANTS.md`（≤80 行 do/don't 清单）
3. `sugarark/docs/INVARIANTS.md`（主项目不变量，约束本仓）
4. `sugarark/docs/crm/INVARIANTS.md`（CRM 不变量，部分约束本仓的 IM 部分）

**第 2 层（当前状态 + 计划，每次必读）：**
5. `docs/STATUS.md`（本仓当前状态）
6. `docs/BACKLOG.md`（本仓任务清单）
7. `docs/OPEN_QUESTIONS.md`（待用户决策的 Flutter 问题）
8. `git log --oneline -20`（最近活动）

**第 3 层（按需读）：**
9. `sugarark/docs/crm/MISSION.md`（CRM 子模块全景，含 Phase 2.5 视图）
10. `sugarark/docs/talkcore-platform-design.md`（跨客户端接入指南，必读一次）
11. 跟当前任务相关的主仓 ADR（`sugarark/docs/decisions/README.md` + `sugarark/docs/crm/decisions/README.md`）
12. 本仓 Flutter 专属 ADR（`docs/decisions/README.md`，目前为空）

---

## 5 题自检（动手前必答）

```
1. 本仓是什么？是什么不是？        → CLAUDE.md §"这是什么仓"
2. 当前阶段做什么？                → docs/STATUS.md
3. 有哪些"绝对不能违反"的？        → docs/INVARIANTS.md (本仓) + sugarark/docs/INVARIANTS.md (主项目)
4. 我要做的事被主仓 ADR 说过吗？   → 主仓 ADR 索引 (主仓 + CRM)
5. 我的改动会让 INVARIANTS 失效？  → 自检 + reviewer 复核
```

---

## 三种角色

```
implementer  实现某个 BACKLOG 条目 / Flutter UI / 集成层
              → 做完更新 STATUS.md + 写 handoff
proposer     提议 Flutter 专属决策 (状态管理 / 路由 / 渲染策略)
              → 写本仓 ADR (status: proposed)，等用户裁决
reviewer     review 别 agent 的提议或代码
              → 在 ADR / handoff 加评估，给同意/反对意见
```

跨仓事务（涉及主仓代码 / API 契约 / talkcore 协议）→ **不在本仓自决**，HALT 转主仓。
跨姊妹仓事务（影响 sugarark-staff-client）→ 在本仓 OPEN_QUESTIONS 提，等 agent 切到 staff 仓处理。

---

## ADR 工作流

### 哪些决策写在本仓 vs 主仓 vs 姊妹仓

```
写本仓 docs/decisions/ (本仓 Flutter 专属):
  ✓ 状态管理库选型 (倾向跟姊妹仓同方案)
  ✓ 路由方案
  ✓ 持久化方案
  ✓ 推送方案 (FCM + APNs)
  ✓ 视频播放 / 媒体处理
  ✓ iOS vs Android 平台特定差异化

写主仓 sugarark/docs/decisions/ 或 sugarark/docs/crm/decisions/:
  ✗ 业务规则 / 审批流 / 群行为 / 频道结构
  ✗ talkcore 协议接入方式 / IM Token 签发流程
  ✗ API 契约 / 命名空间 / 字段定义
  ✗ 影响 staff + user app 两端的决策
  ✗ User App 跟 Web/TG Mini App 共存策略

写姊妹仓 sugarark-staff-client/docs/decisions/:
  ✗ 跟本仓无关的 staff 专属决策

写 talkcore 仓 (跟本仓无关):
  ✗ talkcore 内部协议 / 多租户机制
```

### 状态机

```
proposed   提议中，等用户/另一 agent 评审
accepted   已通过，正在或已经实施
superseded 被新 ADR 替代
deprecated 不再适用
rejected   被拒，留作历史
```

---

## 提交代码的纪律

### 分支命名约定

跟主仓节奏一致，所有本仓 commit 必须在 `feat/*` 分支上，**不直接提交到 main**：

```
feat/app-bootstrap         初始 MAP 骨架 (本仓首次)
feat/app-shell             Phase 2.5 底部 Tab shell
feat/app-im-integration    Phase 2.5 talkcore IM 集成
feat/app-<feature>         其它各 feature 一支
```

### Commit 标签

每次 commit 第一行带 agent 标识：

```
[claude] feat(shell): bottom-tab navigation scaffold
[codex]  fix(im): WS reconnection backoff
[human]  docs: clarify token persistence rule
```

### Commit 关联

涉及主仓 ADR 的 commit 必须在消息体引用：

```
Refs sugarark/ADR-0011 (sugarark-app as separate repo)
Refs sugarark/ADR-0012 (Flutter for sugarark-app)
Refs sugarark/ADR-0015 (User App + Staff same agent)
Refs TASK-25x (本仓 BACKLOG)
```

### 改动范围

**一个 commit 一件事**：不混"实现 feature X" + "顺便重构 Y" + "改 typo"。

---

## HALT 触发条件

立刻停一切，写 `docs/halt/<timestamp>-<reason>.md` 通知用户：

- 主仓 ADR 与本仓实现冲突
- 想改主仓 (sugarark) 任何文件 → 必须 HALT
- 想改 talkcore 任何代码 → 必须 HALT
- 想改姊妹仓 sugarark-staff-client 任何文件 → 必须 HALT (走 OPEN_QUESTIONS)
- 业务约束有歧义（向主仓提 OPEN_QUESTIONS）
- iOS / Android 平台间行为差异不知如何取舍
- 测试连续失败 ≥ 3 次

---

## 跟姊妹仓 sugarark-staff-client 的协作

按主仓 ADR-0015：两个 Flutter 仓由**同一 agent 维护**，采用 **lazy extraction** 模式。

```
Phase 2.5 (本仓 V1) 启动时:
  - 复制 staff 仓 lib/core/ 的 talkcore IM 集成代码
  - adapt 到 user 业务上下文 (业务侧栏 / 输入辅助 / 通知策略)
  - 允许两边略微 diverge

Phase 3+ 评估抽取:
  - 重叠度 ≥70% 且变更频率低 → 抽 sugarark-flutter-core 共享 package
  - 重叠度 <70% 或一方频繁变 → 不抽，各自维护
```

跨两个 Flutter 仓的决策（共享代码模式 / 协议变更）→ ADR 写主仓。

---

## 当前 agent 自报身份

| Agent | 身份 | 主要负责 |
|---|---|---|
| Claude | Anthropic Claude Sonnet 4.5+ | 设计 / 主要实施 / orchestrator |
| Codex | OpenAI Codex | 备用实施 / reviewer |
| Human | 用户本人 | 方向决策 / ADR 裁决 / final review |

---

## 模板版本

本文件 v1，对齐全局 MAP v2，参照 `sugarark/docs/crm/AGENTS.md` 和姊妹仓 `sugarark-staff-client/AGENTS.md`。

---

## v5.2 升级（2026-05-13 同步全局 MAP 协议）

本仓现已对齐 MAP v5.2 全套：

- **docs/MAP_PROFILE.md** —— 项目强度配置（default_mode: standard）
- **docs/terms.md** —— 领域术语表（v4.7）
- **docs/.out-of-scope/** —— 永不做归档（v4.7）
- **docs/changes/** —— CR 协议 v4.0 + v5.1 4 级分流
- **docs/bugs/** —— bug 蓄水池（v4.4）
- **docs/reviews/REVIEW_PLAYBOOK.md** —— review 方法论（v4.9，stub 待 Codex 填）
- **docs/retros/** —— Phase 完成必跑 /retro
- **agents/** —— 6 角色（orchestrator / developer / reviewer / tester / security-auditor / strategic-reviewer）
- **docs/handoffs/TEMPLATE.md** —— Checkpoint C 简版（v5.1）

### Task Type 4 级（v5.1）

每个 task 开工前先按 Checkpoint A 选 Task Type：
- **trivial**: docs / typo / UI 文案微调（8 条全满足）
- **normal**: 普通 Flutter 业务 / Widget 实现
- **architecture**: 状态管理 / 路由 / 持久化方案
- **security**: User JWT / IM Token / PII 缓存 / 视频认证

详见全局 `~/.claude/CLAUDE.md` §"Task Type 4 级分级"。

### Subagent Policy（v5.2）

| Task Type | spawn 策略 |
|---|---|
| trivial | 禁 spawn |
| normal | 单 agent / developer + reviewer |
| architecture | orchestrator + developer + reviewer |
| security | + tester + Codex 复审 |

### 跨仓约束（v5.2 重申）

- 改主仓 sugarark → HALT + 主仓 CR
- 改 talkcore → HALT
- 改姊妹仓 staff-client → OPEN_QUESTIONS
- 改本仓 → 按 v5.2 流程

## 模板版本

本文件 v2，对齐全局 MAP **v5.2**（2026-05-13）。
