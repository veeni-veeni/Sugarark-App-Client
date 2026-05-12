# CLAUDE.md — Sugarark-App-Client

> Claude Code 进入本仓工作流时自动加载本文件。
> 本仓是主项目 sugarark 的 **User App Flutter 客户端子仓**，本文件只补 Flutter 子仓特定规则；主项目身份见 `sugarark/CLAUDE.md`，CRM 子模块规则见 `sugarark/docs/crm/CLAUDE.md`。

---

## 这是什么仓

```
不是:                                是:
─────────────────────              ─────────────────────
✗ 通用 Flutter 模板                  ✓ SugarArk User App (面向 daddy/baby 客户)
✗ Staff/CRM 顾问端                   ✓ 服务付费客户的端到端 App
✗ Admin 后台                         ✓ 客户在 App 内完成注册→认证→匹配→沟通
✗ talkcore 协议库                    ✓ talkcore 的客户端，调 sugarark 后端
✗ 独立技术决策中心                   ✓ 主仓 ADR 的执行端
```

服务对象：**平台付费客户（daddy / baby）**。
平台主战场：**iOS / Android**（V1 不做桌面端）。
导航形态：**底部 Tab + 栈式 push/pop**（不是三栏）。

**版本**: v0（设计阶段，代码尚未启动）
**最后更新**: 2026-05-08

---

## 进本仓动手前自问 5 题

```
1. 本仓是什么？是什么不是？        → 本文件 §"这是什么仓"
2. 当前阶段做什么？                → docs/STATUS.md
3. 有哪些"绝对不能违反"的？        → docs/INVARIANTS.md
4. 我要做的事被主仓 ADR 说过吗？   → sugarark/docs/decisions/README.md + sugarark/docs/crm/decisions/README.md
5. 我的改动会让 INVARIANTS 失效？  → 跑相关测试 / 人工 review
```

> 协作规则见 [AGENTS.md](AGENTS.md)。
> 待决问题清单见 [docs/OPEN_QUESTIONS.md](docs/OPEN_QUESTIONS.md)。

---

## 跟主仓 sugarark 的关系

```
主仓 sugarark                          本仓 Sugarark-App-Client
─────────────────────────             ──────────────────────────────
后端 + Web + TG Mini App                User App Flutter 客户端
ADR / INVARIANTS / MISSION 中心         本仓 ADR 仅 Flutter 专属
talkcore 集成层 (后端)                  talkcore 客户端 SDK 封装
签发 IM Token / Internal JWT            消费 IM Token，绝不持有 Internal JWT
schema / 业务表 / 业务规则               消费 API，不存重复业务真相
现有 user JWT 流                        复用 user JWT (主仓 ADR-0014)
```

**铁律**: 主仓的 ADR / INVARIANTS 对本仓有约束力。本仓不重复主仓决策，**只引用**。本仓只在以下场景写自己的 ADR：

- 选 Flutter 专属技术（状态管理 / 路由 / 持久化方案）
- 客户端渲染策略（消息列表虚拟化 / 图片缓存策略 / 视频播放）
- 平台差异化处理（iOS vs Android 推送 / 权限 / 文件选择）

涉及 IM 协议 / 后端契约 / 业务规则的 ADR 一律写到主仓 `sugarark/docs/decisions/` 或 `sugarark/docs/crm/decisions/`。

---

## 跟姊妹仓 sugarark-staff-client 的关系

按主仓 ADR-0015：两个 Flutter 仓**由同一 agent 维护**，采用 **lazy extraction** 模式。

```
共通部分 (lib/core/, 将来可能抽 shared package):
  ✓ talkcore SDK 封装 (协议层)
  ✓ WebSocket 连接管理 (重连/心跳/离线拉取)
  ✓ 消息渲染 (文字/图片/语音/视频/文件/系统消息)
  ✓ 富消息卡片 (baby_card schema_version=1, 双方都用同一 schema)
  ✓ 群聊基础 (mutual match 三人群)
  ✓ 频道渲染 (官方公告频道)
  ✓ 通用 UI (头像/输入框/emoji)

完全不同 (lib/user/, 本仓专属):
  ✗ 主导航: 底部 Tab (资料/推荐/交友/我的) — staff 是三栏 shell
  ✗ 业务流: 注册→认证→约会 — staff 是接待→匹配
  ✗ 后端业务端点: /api/v1/users/* — staff 是 /api/v1/advisor/*
  ✗ 登录方式: 多端 OAuth + 邮箱 + TG Mini App 共享 — staff 邮箱密码

跨仓协作:
  - lazy extraction 阶段用"复制粘贴 + adapt"，不直接 import
  - 影响两端的 ADR 写主仓
  - 仅本仓的 ADR 写本仓 docs/decisions/
```

---

## 技术栈（拟定，Phase 2.5 启动时定稿）

```
框架:    Flutter (stable channel)
语言:    Dart 3.x
平台:    iOS / Android (V1 不做桌面)
IM:      talkcore (通过 sugarark 后端签发的 IM Token，直连 WS)
HTTP:    dio / http (Phase 2.5 选)
状态管理: 待 Phase 2.5 ADR 选型 (倾向跟 staff 仓同方案)
路由:    go_router (拟定，跟 staff 同方案)
持久化:  hive (拟定，跟 staff 同方案)
媒体:    video_player / chewie / image_picker (Phase 2.5 选)
推送:    firebase_messaging + APNs (待主仓决策推送策略)
```

---

## 数据架构铁律（Flutter 子仓特有）

### Token 流向

```
✅ user JWT: 登录时 POST /api/v1/auth/login (现有端点)，存安全存储
✅ IM Token: 启动时 GET /api/v1/im/token (user JWT 鉴权)，2 小时一签
✅ 仅持有 IM Token + user JWT，绝不持有 talkcore Internal JWT / app_secret
❌ 不在客户端代码里硬编码任何 talkcore secret
❌ 不让 IM Token / user JWT 存到不安全位置（明文 SharedPreferences 等）
```

### Sender 身份

```
✅ 当前 user 的 im_user_id 由 IM Token 决定，客户端不传 sender_id
✅ 同一 user 在 App / Web / TG Mini App 多端登录用同一 im_user_id
❌ 不实现"用户匿名代发"
❌ 不让一个 user 同时扮演多个 im_user
```

### conversation 渲染

```
✅ 群聊渲染时，若成员含 advisor 身份，UI 显示"含顾问"标签 (跟 staff 端逻辑对偶)
✅ phone_number / wechat_id 在客户端展示前由后端按 mutual match 状态过滤
✅ 不显示 matchmaker_notes (那是顾问私有，本仓客户根本拿不到)
❌ 不缓存上述敏感字段到本地持久化
```

### 隐私 + 合规

```
✅ 视频认证 / 实名信息一律走主仓现有流程 (本仓只做 UI 上传 + 状态查询)
✅ 媒体上传走 sugarark 现有 /api/uploads/* 鉴权路径
❌ 不直接暴露 /uploads/ 路径
❌ 不在本地存任何敏感图片 / 视频原文 (用平台缓存 + 鉴权 URL)
```

---

## 范围控制（V1）

### Phase 2.5 (User App V1) 明确做

```
✓ Flutter 工程脚手架 (iOS + Android 构建跑通)
✓ User 登录 + JWT 持久化 (复用现有 /api/v1/auth/login)
✓ talkcore IM Token 拉取 + 续签
✓ talkcore WS 连接 + 重连 + 离线消息拉取
✓ 底部 Tab 主导航 (资料/推荐/交友墙/消息/我的)
✓ 用户档案查看与编辑
✓ 视频认证流程 UI (录制 / 上传 / 状态查询)
✓ 顾问推荐的 baby 卡片接收 + 渲染
✓ 跟顾问 1v1 聊天 + 顾问推荐 baby 富消息接收
✓ Mutual match 三人引荐群参与
✓ 唯一官方公告频道 (强制订阅，只读)
✓ 交友墙列表 + 详情 + 申请 (调现有 /api/v1/dating/*)
✓ 会员等级权限 UI 适配 (Free / Basic / Premium / Elite)
```

### Phase 2.5 明确不做

```
✗ 桌面端 (V1 只做 iOS / Android)
✗ admin 视图 / advisor 视图
✗ 多频道 / 频道订阅 UI
✗ 业绩数据 / 内部统计
✗ Telegram/WhatsApp bridge 实现 (主仓 ADR-0008)
✗ 自动客服 / Bot / AI 自动回复 (主仓 ADR-0011, V1 之后)
✗ 音视频通话
✗ talkcore 协议层重写
✗ TG Mini App 替代 (Mini App 由主仓单独维护)
✗ App 内支付 (会员等级人工录入，跟主仓现行策略一致)
```

---

## 工作流约定

### 用户写"开始"或"继续"时

```
1. 读本文件 + AGENTS.md + docs/INVARIANTS.md
2. 看 git log 最近提交
3. 检查 docs/halt/ 未处理 signal
4. 检查主仓 sugarark/docs/crm/STATUS.md 是否在 Phase 2.5
5. 确认本仓任务范围
6. 询问"接下来做 X，对吗？" 等用户确认
```

### 跨仓边界

任何要改主仓 (`sugarark/`) 文件 / schema / API 契约的需求 **必须 HALT**。
任何要改 talkcore (`talkcore/`) 代码的需求 **必须 HALT**。
任何要改姊妹仓 sugarark-staff-client 代码的需求 → 在本仓 OPEN_QUESTIONS 提，由 agent 切换上下文处理（不在本仓内决定）。

---

## 一句话总结

> **本仓是 SugarArk 的 User App Flutter 客户端，主战场移动端 (iOS/Android)，跟姊妹仓 staff 共享 IM 集成层 (lazy extraction)。**
> **所有架构权威在主仓 sugarark；本仓只做 Flutter 专属技术选型 + 渲染实现。**
> **绝不在客户端持有 talkcore Internal JWT；绝不重写 talkcore 协议；绝不引入业务真相源。**

---

## v5.2 协议升级（2026-05-13）

本仓现已对齐 MAP v5.2：

- **进项目第一动作**：按 Checkpoint A 5 问（取代 v3 5 题自检）
- **完成前**：Checkpoint B 6 问 + verify-before-claim（必粘 stdout）
- **交接**：Checkpoint C 5 项 handoff（简版）
- **Review / 修复 finding / 复审时**必读：`docs/reviews/REVIEW_PLAYBOOK.md`

详见：
- 全局协议：`~/.claude/CLAUDE.md`（v5.2）
- 本仓配置：`docs/MAP_PROFILE.md`（default_mode: standard）
- 全局模板：`~/.claude/refs/{map-profile,task-card,review-playbook}-template.md`
