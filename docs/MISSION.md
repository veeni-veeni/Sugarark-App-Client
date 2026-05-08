---
project: Sugarark-App-Client (User App Flutter)
parent_project: SugarArk
parent_module: main sugarark (not CRM, but uses some CRM-shared components like talkcore IM)
status: draft
locked_at: null
last_updated: 2026-05-08
---

# MISSION — Sugarark-App-Client

> 本仓的最小使命书。不重复主仓决策，**只记录本仓视角下的执行边界**。
> 主仓全景使命见 `sugarark/docs/MISSION.md`，CRM 子模块视角见 `sugarark/docs/crm/MISSION.md`（含本仓 Phase 2.5 在大图中的位置）。

---

## 1. 业务定位

**SugarArk User App** = SugarArk 平台**面向客户（daddy/baby）**的端到端移动 App。把客户的注册、视频认证、咨询顾问、看推荐 baby、跟 mutual match 引荐群沟通等动作集中到一个原生 App 中，跟 Web 站点 / TG Mini App 形成多端并存。

```
不是:                                是:
─────────────────────              ─────────────────────
✗ 通用 IM 客户端                     ✓ SugarArk 客户的端到端 App
✗ 顾问端 / Admin 后台                ✓ 仅服务 daddy/baby 客户
✗ talkcore 协议工具                  ✓ talkcore 的 user-side 客户端
✗ TG Mini App 替代                   ✓ Mini App 仍由主仓维护，本仓平行存在
✗ 桌面端 (V1)                        ✓ 仅 iOS / Android (主战场)
```

---

## 2. 核心用户

```
唯一目标用户: 平台付费客户 (daddy / baby)
当前规模:    数十人级
未来规模:    上千人级 (期望)

不服务:
  ✗ advisor (用 sugarark-staff-client)
  ✗ admin (用主仓 web 后台)
  ✗ agent / 内部员工
```

**典型一天**:
```
早上: 推送提醒 → 打开 App → 看消息中心
日间: 跟顾问聊天 → 看顾问推荐的 baby 卡片 → 表达 / 拒绝意向
约会前: 在三人引荐群跟对方 + 顾问沟通
随时: 浏览交友墙 / 看活动 / 看学院内容
认证日: 视频实名认证 (App 内录制 + 上传)
```

---

## 3. 平台 + 形态

```
平台主战场: 移动 (iOS / Android)
平台不做:   桌面 (V1 不做，可能永远不做)
单一代码库: 一份 Dart/Flutter 代码 2 端构建

shell 形态: 底部 Tab + 栈式 push/pop
              (跟姊妹仓 staff 的三栏 shell 完全不同)
Tab 拟定:   资料 / 推荐 / 交友 / 消息 / 我的 (Phase 2.5 ADR 定稿)
```

为什么不做桌面：客户使用场景以移动为主，桌面端用户用 Web / TG Mini App 已覆盖，新增桌面 = 浪费。

---

## 4. 跟主仓 sugarark 的关系

```
本仓依赖主仓:
  ✓ 后端 REST API (业务数据 + 客户操作)
     /api/v1/users/*      用户业务端点 (现有)
     /api/v1/auth/*       登录注册 (现有)
     /api/v1/dating/*     交友墙 (现有)
     /api/v1/im/*         IM Token / 平台级 IM 端点 (新, 主仓 Phase 1)
     其它已有客户端点      (matching / academy / events / videos ...)
  ✓ talkcore IM Token    通过 sugarark 后端签发，2 小时一签
  ✓ 业务规则 / 群行为 / 频道结构  全在主仓 ADR
  ✓ MISSION / INVARIANTS / BACKLOG 全景 全在主仓

本仓不依赖 talkcore 仓:
  ✗ 不直接调 talkcore OpenAPI (那是后端的事)
  ✗ 不持有 talkcore Internal JWT / app_secret
  ✗ 不重写 talkcore 协议
```

**直接引用的主仓 ADR**:
- `sugarark/docs/decisions/0011-sugarark-app-as-separate-repo.md` — 本仓存在的依据
- `sugarark/docs/decisions/0012-flutter-for-sugarark-app.md` — 选 Flutter
- `sugarark/docs/decisions/0013-talkcore-as-app-im-substrate.md` — App IM 走 talkcore
- `sugarark/docs/decisions/0014-app-auth-existing-jwt.md` — 复用 user JWT
- `sugarark/docs/decisions/0015-shared-backend-for-three-ends.md` — 三端共后端
- `sugarark/docs/decisions/0016-talkcore-webhook-handler-location.md` — webhook 位置
- `sugarark/docs/crm/decisions/0015-user-app-same-agent-lazy-extraction.md` — 同 agent + lazy extraction
- `sugarark/docs/crm/decisions/0007-wechat-work-style-groups.md` — 群行为 (本仓也要遵守)
- `sugarark/docs/crm/decisions/0009-minimal-conversation-meta.md` — sidecar 模式
- `sugarark/docs/crm/decisions/0010-external-users-not-in-groups.md` — 群成员限制

---

## 5. 当前阶段目标

> Phase 编号跟主仓 `sugarark/docs/crm/MISSION.md` 一致。

- [ ] **Phase 2.5: User App Flutter V1** (本仓主线，5-7 周)
  - Phase 2.5.1: 工程脚手架 + iOS/Android 构建跑通
  - Phase 2.5.2: User 登录 + JWT (复用现有 /api/v1/auth/login)
  - Phase 2.5.3: talkcore IM Token + WS 连接 (复制粘贴 staff 仓 core/)
  - Phase 2.5.4: 底部 Tab shell + 路由
  - Phase 2.5.5: 用户档案查看 + 编辑
  - Phase 2.5.6: 跟顾问 1v1 聊天 + baby 卡片接收
  - Phase 2.5.7: 视频认证流程 UI
  - Phase 2.5.8: Mutual match 三人群 + 公告频道
  - Phase 2.5.9: 交友墙 + 推荐流
- [ ] **Phase 5: 推荐 baby 富消息卡片** (主仓 Q-006 框架, 跟 staff 同 schema)
- [ ] **Phase 5.5: 日历/闹钟提醒 UI** (主仓 ADR-0012)
- [ ] **Phase 6: AI 自动回复 UI** (V1 之后, 主仓 ADR-0011)

**总开发量估计**: 约 8-10 周（本仓主线 + 跨 Phase 联动；复用 staff 仓 IM core 后预计省 25-35%）

**Phase 2.5.1 完成的验收命令** (待落地后定):
```
# flutter test
# flutter build ios --no-codesign
# flutter build apk --debug
# (Phase 2.5.1 ADR 落地时定稿)
```

---

## 6. 技术架构概览

```
┌──────────────────────────────────────────────────────────┐
│ User App Flutter (本仓)                                  │
│ iOS / Android (V1 不做桌面)                              │
│                                                          │
│ lib/core/    talkcore IM 集成 (从 staff 仓复制粘贴)      │
│ lib/user/    User 业务专属 (Tab 导航/档案/认证/交友墙)   │
│ lib/shell/   底部 Tab + 栈式 shell                       │
└──────┬─────────────────────────────────────┬─────────────┘
       │ talkcore WS                          │ sugarark REST
       │ (消息收发, 直连, 用 IM Token)         │ (业务数据 + 客户操作)
       ▼                                      ▼
┌──────────────────────────┐     ┌────────────────────────┐
│ talkcore                 │     │ sugarark backend       │
│ ─ 多租户 IM              │     │ /api/v1/users/*        │
│ ─ tenant=sugarark        │◀────│ /api/v1/auth/*         │
│ ─ 不动它的代码           │ Open│ /api/v1/dating/*       │
└──────────────────────────┘ API │ /api/v1/im/*           │
                                  │ 其它已有客户端点        │
                                  └────────────────────────┘
```

---

## 7. 跟其它客户端的关系

```
SugarArk 客户向客户端 (V1 多端并存):
  ✓ 主仓 Web 站点 (现有，sugarark/public/*)
  ✓ 主仓 TG Mini App (现有)
  ✓ 本仓 Flutter App (新, Phase 2.5)

多端并存策略:
  - 三端共后端 (主仓 ADR-0015)
  - 三端共 IM 流 (talkcore 一处真相, ADR-0013)
  - 三端用同一 user JWT 流 (ADR-0014)
  - 用户在某端登录后另一端独立，但 IM 状态共享
  - V1 不做"扫码迁移"等跨端切换 UI

跟姊妹仓 sugarark-staff-client:
  - 同一 agent 维护 (主仓 ADR-0015)
  - lazy extraction 共享 lib/core/ IM 集成代码
  - 业务流完全不同 (advisor vs daddy/baby)
```

---

## 8. 明确不做的事

```
本仓 V1 不做:
  ✗ 桌面端 (mac/win)
  ✗ admin 视图 / advisor 视图
  ✗ 多个频道 / 频道订阅 UI
  ✗ App 内支付 (会员人工录入策略不变)
  ✗ Telegram/WhatsApp bridge 实现
  ✗ AI 自动回复实际逻辑
  ✗ 音视频通话
  ✗ 重写 talkcore 协议 / 自建 IM
  ✗ 业务真相源 (用户/匹配/推荐数据全经后端 API)
  ✗ TG Mini App 替代 (Mini App 仍由主仓单独维护)
  ✗ 直接读取主仓 schema / DB
```

---

## 9. 关键约束

| 类别 | 约束 |
|---|---|
| 业务隔离 | 单一 sugarark 业务，不为 veeni / talksoo 留接口 |
| 团队 | 1 人 agent 同时维护本仓 + sugarark-staff-client (主仓 ADR-0015) |
| 跨仓边界 | 不改主仓 / 不改 talkcore / 不改姊妹仓代码，违反必 HALT |
| 身份铁律 | 客户端不持有 talkcore Internal JWT，IM Token 走 `/api/v1/im/token` |
| 数据铁律 | 不在客户端持久化 phone/wechat/敏感图片 / 视频原文 |
| 部署 | 跟主仓节奏，feat/app-* 分支 → main → 发版 (App Store / Play) |
| 隐私 | 视频认证素材本地不留，App 缓存仅鉴权 URL |

---

## 10. 关联仓库

```
github.com/veeni-veeni/sugarark            主仓
github.com/veeni-veeni/sugarark-staff-client Staff Flutter (姊妹仓)
github.com/veeni-veeni/talkcore            IM 平台 (只读)
github.com/veeni-veeni/Sugarark-App-Client 本仓
```

---

## 11. 变更日志

| 日期 | 变更 | 关联 |
|---|---|---|
| 2026-05-08 | 初版骨架 (MAP v2 简版) | 主仓 ADR-0011 ~ 0016 + CRM ADR-0015 |
