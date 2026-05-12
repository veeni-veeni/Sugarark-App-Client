# Terms — Sugarark-App-Client 领域术语表

> 项目领域语言。**变量名 / 函数名 / widget 名 / 文档**都用这套词。
>
> 主项目术语见 `sugarark/docs/terms.md`——本仓只补 Flutter / User App 特定术语。

## 核心术语（Flutter / User App 特定）

### 客户角色

- **Customer** — 终端客户（daddy / baby）。**避免**：user（太泛）
- **Daddy** — 男方客户（业务术语）
- **Baby** — 女方客户（业务术语）

### IM 集成（talkcore + sugarark backend）

- **IM Token** — 终端连 talkcore WS 的 token。**走 sugarark `/api/v1/im/token` 拿**，永不直接调 talkcore OpenAPI
- **IM User ID** — talkcore 端 user 镜像 ID（sugarark backend 创建后返回）
- **Conversation** — IM 会话（mutual match 后开）
- **System A** vs **System B** — 继承主仓概念（P2P 客户↔客户 / 客户↔advisor）

### 状态管理

- **Provider** / **Riverpod** / **Bloc** — 状态管理库（具体方案见 ADR）
- **State Notifier** — Riverpod 用 / **Cubit** — Bloc 用
- _避免_：把 controller / manager / handler 这种泛词混用

### Flutter 平台

- **Material** — Android / 跨平台默认风格
- **Cupertino** — iOS 原生风格
- **Platform-aware** — 同 widget 跨平台行为一致但视觉差异化

### 路由

- **GoRouter** / **Navigator 2.0** — 路由方案（具体见 ADR）
- **Deep Link** — 外部链接进 App 跳具体页

### 持久化

- **SecureStorage** — 敏感数据（token / refresh token）必用
- **SharedPreferences** — 普通设置（不能放 PII）
- **Hive** / **sqflite** — 复杂本地数据（如果有）
- _避免_：本地化 PII 字段（phone / wechat 不持久化）

## 不该出现的词

| ❌ 漂用语 | ✅ 正确 |
|---|---|
| user（指客户）| customer / daddy / baby |
| handler / controller / manager（泛词）| 用状态管理库名（StateNotifier / Cubit 等）|
| API（指 talkcore）| sugarark backend REST 或 talkcore WS（明确分清）|
| service（指 talkcore 服务）| sugarark backend / talkcore 平台（明确）|

## 关系图

```
Customer (Flutter App)
    ↓ Login + auth
sugarark backend (REST)
    ↓ 签发 IM Token
talkcore platform (WS)
    ↓ 收发消息
Conversation (mutual match 后开)
```

## 何时更新

- 写代码遇到新业务概念 → 加进来
- 主仓 terms.md 加了新术语 → 评估是否本仓也用
- 季度复读

## 跟其他文档的关系

- **MISSION**: 项目要做什么
- **INVARIANTS**: 不能违反的红线
- **MAP_PROFILE**: 协议强度配置
- **terms**（本文件）: 领域术语表
- **主仓 sugarark/docs/terms.md**: 主项目术语（本仓继承）
