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

## 首次运行（你装好 Flutter 之后）

> 当前仓库已含 `lib/` Dart 代码 + `pubspec.yaml`，但 **未** 包含 `ios/` `android/` 等原生 scaffold 目录——交付时本机没装 Flutter SDK。下面命令会让 `flutter create` 自动生成原生壳，**不会覆盖** `lib/` 和 `pubspec.yaml`。

```bash
cd Sugarark-App-Client

# 1. 生成 ios / android 原生 scaffold (V1 不做桌面)
flutter create --org com.sugarark --project-name sugarark_app_client \
  --platforms=ios,android .

# 2. 拉依赖
flutter pub get

# 3. 跑代码生成（Riverpod / json_serializable，目前仅占位，不阻塞首次运行）
dart run build_runner build --delete-conflicting-outputs

# 4. 启动后端（在另一个终端，主仓 sugarark）
#    cd ../sugarark && npm run dev
#    默认监听 http://localhost:3001

# 5. 跑应用（按平台二选一）
flutter run -d ios         # iPhone / Simulator (主战场)
flutter run -d android     # Android

# 自定义后端地址（部署时切到 sugarark.com 域名）：
flutter run -d ios --dart-define=API_BASE_URL=https://api.sugarark.com

# 6. 跑测试
flutter test
```

后端 baseUrl 用 `--dart-define=API_BASE_URL=…` 覆盖；不传时默认 dev `http://localhost:3001`，定义在 [`lib/core/api/api_endpoints.dart`](lib/core/api/api_endpoints.dart)。

### 当前 V1 范围

- User 邮箱密码登录 → 主仓 `/api/v1/auth/login` (复用现有 user JWT，主仓 ADR-0014)
- JWT 双 token 持久化（access + refresh）到 `flutter_secure_storage`
- Dio 拦截器自动 401 → refresh → 重放，refresh 失败强制登出
- 启动页 → 路由根据 AuthState 自动跳 `/login` 或 `/chat`
- 主壳 = 4-tab 底部导航（聊天 / 推荐 / 档案 / 通知），每 tab 仅占位
- 登录页底部"还没账号？前往网页注册"按钮 deep-link 到 `https://sugarark.com/register`
  （**App ADR-0003 V1 不做 App 内注册**，统一走 Web）
- talkcore IM Token service 已就位（`/api/v1/im/token`），WS 客户端 Phase 2.5.3 实现

### V1 不在 App 内做的事（重要）

- ❌ App 内注册 — 走 Web `https://sugarark.com/register` (ADR-0003)
- ❌ 桌面端 — 仅 iOS / Android
- ❌ App 内支付 — 会员等级仍由人工录入
- ❌ 视频认证录制流程 — Phase 2.5.7
- ❌ talkcore WS 实际连接 — Phase 2.5.3
- ❌ 推送注册 (`/users/me/push-tokens`) — 端点已定，UI/SDK 接入是 Phase 2.5.3 之后
- ❌ 注销账号 (`DELETE /users/me`) — Apple 5.1.1 必需，UI 是后续 task

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

**Phase 1 — Flutter scaffold 已就位**：4-tab 底部导航 + 登录 + JWT 持久化 + IM Token service 已实现（占位 tab，业务流待 Phase 2.5+ 接入）。本机交付时未装 Flutter SDK，所以 `ios/` `android/` 原生壳由首次运行 `flutter create` 自动生成。

