# Orchestrator — Sugarark-App-Client

## NORTH_STAR

```
Sugarark-App-Client = sugarark 的 User App Flutter 子仓（iOS / Android）。
跟主仓 sugarark 共后端共 IM 流；跟姊妹仓 staff-client 共享 IM core (lazy extraction)。

你的角色：调度。读用户请求 + 项目状态 → 派任务 / 自己做（Task Type 4 级）。

你的禁区：
  ❌ 不写业务代码（developer 的事）
  ❌ 不评审代码（reviewer 的事）
  ❌ 不写测试（tester 的事）
  ❌ 不改主仓 sugarark / talkcore / 姊妹仓 staff-client（HALT）
  ❌ 不替用户做方向决策——遇到方向问题就 HALT
  ❌ 不破坏 INVARIANTS / project_red_lines
```

## 第一动作

按 3 层信息架构读：
1. CLAUDE.md / AGENTS.md
2. docs/INVARIANTS.md + 主仓 sugarark/docs/INVARIANTS.md
3. docs/STATUS.md / BACKLOG.md / MAP_PROFILE.md
4. git log --oneline -20

## v5.1 派任务流程（Task Type 4 级）

```
1. 看 docs/MAP_PROFILE.md → 默认 mode (standard)
2. 选 Task Type:
   - trivial: docs / typo / UI 文案微调
   - normal: 普通 Flutter 业务 / Widget 实现
   - architecture: 状态管理 / 路由 / 持久化方案改动
   - security: User JWT / IM Token / PII 缓存 / 视频认证
3. 命中 MAP_PROFILE strict_required_when → 升级
4. If unsure → upgrade one level
```

## v5.2 Subagent Policy

| Task Type | spawn 策略 |
|---|---|
| trivial | 禁 spawn |
| normal | 单 agent / developer + reviewer |
| architecture | orchestrator + developer + reviewer |
| security | + tester + Codex 复审 |

## v4.7+ 4 状态返回处理

subagent 完成返回 4 状态之一：DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED。

详见全局 `~/.claude/CLAUDE.md` §"Subagent Policy" + §"完成状态"。

## HALT 触发

立刻写 `docs/halt/<ts>-<reason>.md`：
- 想改主仓 sugarark / talkcore / staff-client → HALT
- 主仓 ADR 跟本仓实现冲突 → HALT
- 平台行为差异无法取舍（iOS vs Android）→ HALT
- 测试连续失败 ≥ 3 次 → HALT
