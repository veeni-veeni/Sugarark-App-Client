# Sugarark-App-Client

> SugarArk User App（Flutter） · 服务 daddy/baby 客户的端到端 App
> 主战场：iOS / Android（V1 不做桌面）

---

## 是什么

SugarArk User App = SugarArk 平台**面向客户（daddy/baby）**的移动 App。让客户在 App 内完成注册、视频认证、跟顾问咨询、看顾问推荐的 baby 卡片、跟 mutual match 三人引荐群沟通等全流程。

- **服务对象**: 平台付费客户（daddy / baby），**不是** advisor / admin
- **平台**: iOS / Android（移动是主战场，桌面 V1 不做）
- **导航形态**: 底部 Tab 栈式 shell（不是三栏）

详细使命见 [`docs/MISSION.md`](docs/MISSION.md)。

---

## 跟主仓的关系

```
github.com/veeni-veeni/sugarark            主仓（后端 + Web + 已有 Web/TG Mini App）
github.com/veeni-veeni/sugarark-staff-client Staff Flutter（顾问端，姊妹仓）
github.com/veeni-veeni/talkcore            IM 平台（只对接 OpenAPI，不动代码）
github.com/veeni-veeni/Sugarark-App-Client 本仓
```

本仓的所有架构决策遵循主仓 ADR：

- `sugarark/docs/crm/decisions/0015-user-app-same-agent-lazy-extraction.md` — 本仓存在的依据 + 跨仓协作模式
- `sugarark/docs/decisions/0011-sugarark-app-as-separate-repo.md` — App 独立仓决策
- `sugarark/docs/decisions/0012-flutter-for-sugarark-app.md` — 选 Flutter 的依据
- `sugarark/docs/decisions/0013-talkcore-as-app-im-substrate.md` — App 端 IM 走 talkcore
- `sugarark/docs/decisions/0014-app-auth-existing-jwt.md` — 复用现有 user JWT
- `sugarark/docs/decisions/0015-shared-backend-for-three-ends.md` — 三端共后端
- `sugarark/docs/decisions/0016-talkcore-webhook-handler-location.md` — webhook 位置
- `sugarark/docs/talkcore-platform-design.md` — 跨客户端接入指南（必读）

本仓只放 Flutter 专属决策（如本地状态管理选型 / 渲染策略），其它一律引用主仓。

---

## 后端依赖

User App Flutter 直连两组通道：

```
talkcore WS                直连 talkcore 服务
                           Token 来源: sugarark 后端 /api/v1/im/token
                           （跟 staff 同端点，但带 user JWT 鉴权）
                           
sugarark REST              业务数据（用户档案 / 匹配 / 推荐 / 视频 / 交友墙等）
                           端点命名空间: /api/v1/users/*  /api/v1/im/*  其它已有客户端点
                           认证: JWT_SECRET 签发的 user token (主仓 ADR-0014)
```

**铁律**: 客户端从不持有 talkcore Internal JWT / app_secret，IM Token 一律通过 `/api/v1/im/token` 端点取（详见 INVARIANTS）。

---

## 怎么跑（待 Phase 2.5 启动后填）

```bash
# Phase 2.5 启动时填入
flutter pub get
flutter run -d ios       # 或 android
```

---

## 文档结构（MAP v2 简版）

```
docs/
├── MISSION.md            本仓使命（短，引用主仓 ADR）
├── INVARIANTS.md         Flutter 编码红线（≤80 行）
├── STATUS.md             当前进度
├── BACKLOG.md            短期任务
├── OPEN_QUESTIONS.md     Flutter 专属待决问题
├── decisions/            Flutter 专属 ADR（其它引用主仓）
├── handoffs/             agent 交接记录
└── halt/                 阻塞 signal
```

每次进本仓动手前必读：[`AGENTS.md`](AGENTS.md) + [`CLAUDE.md`](CLAUDE.md) + [`docs/INVARIANTS.md`](docs/INVARIANTS.md) + [`docs/STATUS.md`](docs/STATUS.md)。

---

## 当前阶段

**Phase 0 — Bootstrap**：MAP 骨架已就位，代码尚未启动。Phase 2.5 启动 = 开始建 Flutter 工程脚手架（见主仓 BACKLOG Phase 2.5）。
