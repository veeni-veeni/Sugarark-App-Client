# STATUS — Sugarark-App-Client

> 本仓当前进度。每次 BACKLOG 状态变化时立即更新。

**最后更新**: 2026-05-08
**当前 Phase**: Phase 0 (Bootstrap, MAP 骨架)
**主仓联动 Phase**: 主仓 Phase 1 (后端 talkcore 接入) — 见 `sugarark/docs/crm/STATUS.md`
**姊妹仓状态**: sugarark-staff-client 同样 Phase 0 (Bootstrap)

---

## 当前在做

```
Phase 0: MAP v2 骨架就位
  ✓ README.md / CLAUDE.md / AGENTS.md
  ✓ docs/MISSION.md / INVARIANTS.md
  ✓ docs/STATUS.md / BACKLOG.md / OPEN_QUESTIONS.md
  ✓ docs/decisions/README.md (索引，本仓 ADR 暂为空)
  ✓ docs/handoffs/TEMPLATE.md
  ✓ docs/halt/README.md
```

---

## 已完成

| 日期 | 事项 | commit |
|---|---|---|
| 2026-05-08 | MAP v2 骨架 bootstrap | 待 commit |

---

## 进行中

无（Phase 2.5 待主仓 Phase 1 完成 + 姊妹仓 staff 仓 Phase 2 启动后再启动）

---

## 阻塞 / 待用户拍板

无 — 所有待决 Flutter 专属问题在 `docs/OPEN_QUESTIONS.md`。

---

## 下一步

启动条件（按主仓 ADR-0015 lazy extraction 模式）:
1. 主仓 Phase 1 后端 talkcore 接入稳定（identity_sync / im-token / webhook 三个 TASK 完成）
2. 姊妹仓 sugarark-staff-client Phase 2 已经跑出 `lib/core/` 雏形（IM 集成层有可复用代码）
3. 用户拍板进入 Phase 2.5

启动 Phase 2.5 时第一动作：
1. 解 OPEN_QUESTIONS Q-Flutter-001 (状态管理选型，倾向跟 staff 同方案) 写本仓 ADR
2. 解 Q-Flutter-002 (路由方案，倾向跟 staff 同方案) 写 ADR
3. 解 Q-Flutter-003 (持久化方案，倾向跟 staff 同方案) 写 ADR
4. 解 Q-Flutter-009 (推送方案 FCM/APNs) 写 ADR
5. 复制 staff 仓 lib/core/ 到本仓
6. 落 Phase 2.5.1 工程脚手架 (iOS/Android 构建跑通)

---

## 健康度

```
docs 健康:  绿 (MAP v2 骨架完整)
代码健康:   N/A (尚未启动)
测试健康:   N/A
跨仓边界:   绿 (未发生越界改动)
```
