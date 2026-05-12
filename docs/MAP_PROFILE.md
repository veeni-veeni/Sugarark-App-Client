# MAP Profile — Sugarark-App-Client

> 本项目对全局 MAP v5.2 协议的强度配置。
> 全局协议见 `~/.claude/CLAUDE.md`。模板见 `~/.claude/refs/map-profile-template.md`。

## 默认模式

default_mode: **standard**

**理由**：sugarark User App Flutter 客户端（iOS / Android）。面向 daddy/baby 终端客户，涉及客户认证 / IM Token / 视频认证 / 支付——但前端不直接持有数据库 / SQL / multi-tenant。standard 起步，敏感场景自动升 strict。

## Fast Path 允许场景

fast_path_allowed:
  - docs-only（README / handoff / spec 文档）
  - tests-only
  - typo / comment 修复
  - UI 文案 / i18n 字典补充
  - 单 widget 视觉微调（颜色 / 间距 / 字号，不改交互）

**显式不允许 Fast Path**：
  - 任何 lib/ 业务逻辑
  - 任何 sugarark backend API 调用代码
  - talkcore IM 集成代码
  - 认证 / token 处理代码
  - 客户敏感字段渲染逻辑

## 必须升 strict 的场景（strict_required_when）

任一命中 → 任务级别自动升 **architecture** 或 **security**：

  - **User JWT** 处理（JWT_SECRET 客户端持久化策略）
  - **IM Token** 签发 / 缓存 / 刷新（必走 sugarark `/api/v1/im/token`）
  - **talkcore WebSocket** 连接 / 重连 / 断线处理
  - **客户敏感字段** 显示 / 缓存（mutual match 前 phone/wechat 不可见）
  - **视频认证** 录制 / 上传（WebRTC + 美颜 + 原相机双轨）
  - **会员等级** 显示 / 升级流程
  - **支付** 流程（App 内付费 / 客户端支付回调）
  - **跨平台部署** 配置（iOS / Android 任一通道）
  - **本地存储敏感数据**（Hive / SharedPreferences / SecureStorage 涉及 PII）
  - **sugarark backend OpenAPI 契约** 任何对接改动

## 项目红线（提示用 — 详细见 INVARIANTS）

project_red_lines:
  - **客户端硬编码 talkcore Internal JWT / app_secret** → 永不
  - **直接调 talkcore OpenAPI** → 永不（业务操作走 sugarark REST，发消息走 talkcore WS）
  - **phone_number / wechat_id 持久化本地** → 永不
  - **改主仓 sugarark / talkcore / staff-client 文件** → 必 HALT
  - **改 sugarark backend API 契约** → 必 HALT + 走主仓 CR
  - **绕过 sugarark 后端拿 IM Token** → 永不
  - **18+ 校验** 不可绕（继承主仓约束）

详见 `docs/INVARIANTS.md`（≤80 行本仓特有）+ 继承 `sugarark/docs/INVARIANTS.md` + `sugarark/docs/crm/INVARIANTS.md`。

## Review 强度

review_default:
  trivial: skip
  normal: L1（Claude 内部 reviewer subagent）
  architecture: L2 / L3（用户调 Codex 如可用）
  security: L3 + Codex 复审（必跑）

## CR 强度

cr_strictness:
  trivial: 不开 CR
  normal: 轻量 CR 4 块
  architecture: 完整 5 维度 + ADR
  security: 完整 5 维度 + ADR + 安全 13 条

## 协作配置（v5.2）

coordination:
  wip_file: disabled

  enable_when:
    - multi_agent
    - parallel_development（如用户跟 Claude 同时改本仓）

## 跨仓边界

Sugarark-App-Client **是子仓**，主项目身份继承 `sugarark/CLAUDE.md`：

- 主项目业务 INVARIANTS（18+ / mutual match / audit_logs / 三套 JWT / 视频权限）**继承**
- 本仓只补 Flutter 子仓特定红线（PII 缓存策略 / IM Token 持久化 / 跨平台一致性）
- 改 sugarark backend OpenAPI 契约 / talkcore 协议 → 必 HALT + 走主仓 CR
- 改姊妹仓 sugarark-staff-client → 走 OPEN_QUESTIONS（不直接动）

## 何时更新本文件

- 加新平台（如桌面 / Web）→ 重评强度
- 加新业务能力（如支付 / 客服）→ 重评 strict_required_when
- 主仓 sugarark 接入新 backend 契约 → 同步本文件
- 每季度复读
