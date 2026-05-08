# OPEN_QUESTIONS — Sugarark-App-Client

> Flutter 子仓专属待决问题。**业务问题 / 跨仓问题** 不在这里，写到主仓 `sugarark/docs/crm/OPEN_QUESTIONS.md` 或 `sugarark/docs/OPEN_QUESTIONS.md`。
>
> 每条 ID 化（Q-Flutter-NNN），用户拍板后移到 RESOLVED 区，对应 ADR 写到 `docs/decisions/`。

---

## OPEN

### Q-Flutter-001: 状态管理选型（跟姊妹仓 staff 同步选）

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.1 启动前必决
- **倾向**: 跟姊妹仓 sugarark-staff-client 同方案 (riverpod 2.x)
- **理由**: 同 agent 维护两仓，技术栈一致 → 上下文复用、bug 修一处补两处
- **待用户拍板**: 是

### Q-Flutter-002: 路由方案（跟姊妹仓同步选）

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.1 启动前必决
- **倾向**: 跟 staff 同方案 (go_router) — 深链接 + 平台一致性好
- **待用户拍板**: 是

### Q-Flutter-003: 本地持久化方案（跟姊妹仓同步选）

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.2 启动前必决
- **倾向**: 跟 staff 同方案 (hive)
- **待用户拍板**: 是

### Q-Flutter-004: secure storage 包选型

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.2 启动前必决
- **倾向**: flutter_secure_storage (社区主流，iOS/Android 支持完善)
- **待用户拍板**: 是

### Q-Flutter-005: 底部 Tab 数量与命名

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.4 设计前必决
- **选项**:
  - A: 5 Tab (资料 / 推荐 / 交友 / 消息 / 我的)
  - B: 4 Tab (推荐 / 交友 / 消息 / 我的)，资料合并到"我的"
  - C: 3 Tab (推荐 / 消息 / 我的)，交友移到推荐 Tab 内
- **倾向**: B 或 A — 5 Tab 看着多但符合主仓 Web/TG 现有信息架构
- **待用户拍板**: 是 (跟主仓产品 owner 协商)

### Q-Flutter-006: 富消息卡片 (推荐 baby) 渲染框架

- **状态**: OPEN (依赖主仓 Q-006)
- **影响 Phase**: Phase 5
- **说明**: 主仓 Q-006 定义 schema_version=1 后，本仓如何渲染（跟 staff 仓共享渲染组件 vs 各自实现）
- **倾向**: 跟 staff 共享渲染组件 (lib/core/widgets/baby_card/) — 同一 schema 同一渲染
- **待主仓拍板优先**

### Q-Flutter-007: 测试策略

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.1 启动时定基线
- **倾向**: 跟 staff 同方案 (widget test 为主 + 关键 e2e)
- **待用户拍板**: 是

### Q-Flutter-008: WS 重连退避策略具体值（跟姊妹仓同步）

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.3
- **倾向**: 跟 staff 同方案 (1s / 2s / 5s / 15s / 30s 上限)
- **待用户拍板**: Phase 2.5.3 启动时

### Q-Flutter-009: 推送方案 (FCM + APNs)

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.7（推送 TASK-261 启动前必决）
- **选项**:
  - A: firebase_messaging (FCM) + iOS 走 FCM-APNs 桥
  - B: firebase_messaging (Android) + flutter_apns (iOS)
  - C: 自建 push 后端 + WebSocket 长连接（V1 不推荐）
- **倾向**: A — 单一 SDK 两端覆盖，社区维护稳定
- **跨仓影响**: 主仓需要落 push 服务（talkcore message.created webhook → 后端 push 出 → FCM/APNs）
- **待用户拍板**: 是

### Q-Flutter-010: 视频认证录制 SDK

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.7 (TASK-258)
- **选项**:
  - A: camera + 自封活体检测提示（不做真活体算法，用文字引导）
  - B: 接入第三方活体检测 SDK (合规 + 成本)
- **倾向**: A — V1 简单实现，跟主仓现行视频认证流程一致 (主仓现在也是人工审核+提示，没真活体)
- **待用户拍板**: 是

### Q-Flutter-011: 跟姊妹仓 staff 共享 UI 组件库的边界

- **状态**: OPEN
- **影响 Phase**: Phase 2.5.5+ (UI 实现期间)
- **说明**: lib/core/ 共享 IM + 协议层无争议；UI widget 哪些共享 (头像 / 输入框 / 消息气泡) 哪些各自实现 (Tab / 业务侧栏)，需要边做边定
- **倾向**: 复制粘贴 + adapt，等到 Phase 3+ 评估抽取（主仓 ADR-0015）
- **待用户拍板**: 否（执行 ADR-0015 即可）

### Q-Flutter-012: App 与 TG Mini App / Web 的 user 状态切换

- **状态**: OPEN
- **影响 Phase**: 未定
- **说明**: 同一 user 在 App / Web / TG Mini App 多端登录时，IM 消息推送给谁？只在线设备收？
- **跨仓影响**: 主仓需要决定多端 push 策略
- **待主仓拍板优先**

---

## RESOLVED

无（本仓刚启动）

---

## 模板

```markdown
### Q-Flutter-NNN: <问题标题>

- **状态**: OPEN | RESOLVED
- **影响 Phase**: ...
- **选项**:
  - A: ...
  - B: ...
- **倾向**: ...
- **取舍**: ...
- **待用户拍板**: 是 / 否
- **决议** (RESOLVED 时填): ... + 关联 ADR-NNNN
```
