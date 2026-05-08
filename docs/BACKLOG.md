# BACKLOG — Sugarark-App-Client

> 本仓任务清单。Phase 编号跟主仓 `sugarark/docs/crm/MISSION.md` 一致。
> **铁律**: 没填「验证命令」字段的任务**不能进 IN_PROGRESS**。

---

## Active

无（Phase 2.5 待主仓 Phase 1 + 姊妹仓 Phase 2 部分稳定后启动）

---

## Phase 2.5 — User App Flutter V1（占位，待启动时细化）

### TASK-251: 工程脚手架 + iOS/Android 构建跑通

- **状态**: PLANNED
- **依赖**: 主仓 Phase 1 部分完成 (im-token 端点可用) + 姊妹仓 staff Phase 2.1 完成 (lib/core 雏形可复制)
- **依赖**: 本仓 ADR-0001/0002/0003 (跟 staff 同方案)
- **描述**: flutter create + iOS/Android 平台目录配置 + 通用结构 (lib/core, lib/user, lib/shell)
- **验收标准**:
  - [ ] `flutter run -d ios` 跑出空白带 logo 页
  - [ ] `flutter run -d android` 跑出空白带 logo 页
  - [ ] `flutter build ios --no-codesign` 成功
  - [ ] `flutter build apk --debug` 成功
  - [ ] 仓库目录结构符合本仓 ADR-0001~0003
  - [ ] lib/core/ 已从 staff 仓复制粘贴 IM 集成代码 (主仓 CRM ADR-0015)
- **验证命令**: `flutter test && flutter build ios --no-codesign && flutter build apk --debug`

### TASK-252: User 登录 + JWT 持久化

- **状态**: PLANNED
- **依赖**: TASK-251
- **依赖**: 主仓 `/api/v1/auth/login` 已存在 (主仓现有)
- **验收标准**:
  - [ ] 邮箱+密码登录页
  - [ ] 拿到 user JWT 后存到 secure storage
  - [ ] 启动时自动恢复登录状态
  - [ ] 登出清空 secure storage
- **验证命令**: 待 Phase 2.5.2 启动时定 e2e + 单测

### TASK-253: IM Token 拉取 + 续签

- **状态**: PLANNED
- **依赖**: TASK-252
- **依赖**: 主仓 `/api/v1/im/token` 端点上线
- **验收标准**:
  - [ ] 启动时调 `/api/v1/im/token` (用 user JWT) 拿到 IM Token
  - [ ] 过期前 5 分钟自动续签
  - [ ] 续签失败时回退到登录页
- **验证命令**: 待 Phase 2.5.3 启动时定

### TASK-254: talkcore WS 连接 + 重连 + 离线消息

- **状态**: PLANNED
- **依赖**: TASK-253
- **复用**: 从 staff 仓复制粘贴 lib/core/ws/* 代码
- **验收标准**:
  - [ ] WS 用 IM Token 握手
  - [ ] 网络断开自动重连 (1s/2s/5s/15s/30s 退避)
  - [ ] 离线消息按 server_msg_id 顺序补齐
- **验证命令**: 待定（人为断网测试）

### TASK-255: 底部 Tab shell + 路由

- **状态**: PLANNED
- **依赖**: TASK-254
- **验收标准**:
  - [ ] 底部 Tab (资料/推荐/交友/消息/我的)
  - [ ] 路由用 go_router (拟定，跟 staff 同方案)
  - [ ] 深链接支持 (push 通知点击 → 对应 Tab + 详情)
- **验证命令**: 待定

### TASK-256: 用户档案查看 + 编辑

- **状态**: PLANNED
- **依赖**: TASK-255
- **验收标准**:
  - [ ] 查看自己档案 (调 GET /api/v1/users/me)
  - [ ] 编辑基础信息 + 照片
  - [ ] 编辑伴侣偏好 (partner_preferences JSONB)
  - [ ] 视频认证状态展示
- **验证命令**: 待定 (e2e)

### TASK-257: 跟顾问 1v1 聊天 + baby 卡片接收

- **状态**: PLANNED
- **依赖**: TASK-254, TASK-255
- **验收标准**:
  - [ ] 顾问发起的 1v1 聊天能收发消息
  - [ ] 接收顾问推荐 baby 富消息卡片 (schema_version=1)
  - [ ] 卡片渲染 + "感兴趣"/"不感兴趣" 操作 (调主仓 /api/v1/matching/* 现有端点)
- **验证命令**: 待定

### TASK-258: 视频认证流程 UI

- **状态**: PLANNED
- **依赖**: TASK-256
- **验收标准**:
  - [ ] App 内录制视频 (含活体检测提示)
  - [ ] 上传到 sugarark 鉴权 /api/uploads/ (走主仓现有流程)
  - [ ] 状态查询 + 通知
  - [ ] 不在本地缓存视频原文
- **验证命令**: 待定 (含 iOS / Android 双端)

### TASK-259: Mutual match 三人引荐群 + 公告频道

- **状态**: PLANNED
- **依赖**: TASK-254, TASK-257
- **验收标准**:
  - [ ] mutual match 触发后自动加入三人引荐群
  - [ ] 群聊渲染按主仓 ADR-0007 规则显示成员身份
  - [ ] 强制订阅唯一官方公告频道，只读
- **验证命令**: 待定

### TASK-260: 交友墙列表 + 详情 + 申请

- **状态**: PLANNED
- **依赖**: TASK-255
- **复用**: 主仓 /api/v1/dating/* 现有端点
- **验收标准**:
  - [ ] 列表 (按对立性别过滤，主仓现有规则)
  - [ ] 详情 + 申请
  - [ ] 我的帖子 + 我的申请
  - [ ] 会员等级权限 UI 适配 (Free / Basic / Premium / Elite)
- **验证命令**: 待定

### TASK-261: 推送 (FCM + APNs)

- **状态**: PLANNED
- **依赖**: TASK-254
- **依赖**: 本仓 ADR Q-Flutter-009 (推送方案)
- **验收标准**:
  - [ ] FCM (Android) + APNs (iOS) 接入
  - [ ] talkcore 消息触发推送 (走主仓后端 push 服务)
  - [ ] 推送点击深链到对应会话
- **验证命令**: 待定

---

## Phase 5 — 推荐 baby 富消息卡片渲染（联动主仓 Phase 5）

### TASK-501: 富消息卡片 schema_version=1 框架渲染（user-side）

- **状态**: PLANNED
- **依赖**: 主仓 Phase 5 + Q-006 解决 + 姊妹仓 staff TASK-501
- **复用**: 跟 staff 同 schema，渲染组件可能复用
- **验收标准**: 待 Phase 5 启动时拆分

---

## Phase 5.5 — 日历/闹钟 UI（联动主仓 ADR-0012）

### TASK-551: 日历视图 + 客户端提醒 UI

- **状态**: PLANNED
- **依赖**: 主仓 ADR-0012 落实 schema + API
- **验收标准**: 待启动时拆分

---

## Phase 6 — AI 自动回复 UI（V1 之后，联动主仓 ADR-0011）

### TASK-601: AI 接管提示 UI

- **状态**: DEFERRED (V1 之后)
- **说明**: 客户端只显示"顾问当前由 AI 接管"等提示，不做实际 AI 逻辑

---

## Deferred / Rejected

### TASK-DEF-001: App 内支付

- **状态**: DEFERRED
- **理由**: 主仓现行策略是会员人工录入，本仓不做 App 内购

### TASK-REJ-001: 桌面端 (mac/win)

- **状态**: REJECTED
- **理由**: 客户使用场景以移动为主，桌面用 Web / TG Mini App 已覆盖

---

## 命名约定

```
TASK-25x  Phase 2.5
TASK-3xx  Phase 3 (本仓暂无 Phase 3，主仓 Phase 3 是 staff 接待池)
TASK-5xx  Phase 5
TASK-55x  Phase 5.5
TASK-6xx  Phase 6
TASK-DEF  Deferred
TASK-REJ  Rejected
```
