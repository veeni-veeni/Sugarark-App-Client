# HALT signal 目录 — Sugarark-App-Client

> agent 遇到无法自决的情况时停一切，把 signal 写到这里。
> 文件名: `<YYYY-MM-DD-HHMMSS>-<reason-slug>.md`

## 何时 HALT（本仓特有）

- 主仓 ADR 与本仓实现冲突
- **想改主仓 (sugarark) 任何文件 / schema / API 契约** → 必须 HALT
- **想改 talkcore 任何代码** → 必须 HALT
- **想改姊妹仓 sugarark-staff-client 任何代码** → 必须 HALT
- ADR 与 INVARIANTS 冲突
- 方向问题（iOS vs Android 平台差异化怎么取舍）
- 取舍问题（性能 vs 简单 / 安装包大小 vs 功能）
- 测试连续失败 ≥ 3 次
- agent 间分歧无法自决
- 业务约束有歧义

## HALT 文件模板

```markdown
# HALT: <reason>

- 触发 agent: <orchestrator | developer | reviewer | tester>
- 时间: <ts>
- 关联 task / ADR: ...

## 情况描述
<发生了什么，为什么自决不了>

## 跨仓影响（重要）
- 是否需要改主仓 sugarark?
- 是否需要改 talkcore?
- 是否需要改姊妹仓 sugarark-staff-client?

## 我尝试过的解决方案
1. ...
2. ...

## 选项 + 取舍

| 选项 | 优 | 劣 |
|---|---|---|
| A | ... | ... |
| B | ... | ... |

## 我的倾向
<A，因为 ...>

## 等待用户
<具体需要用户拍板什么>
```

## 处理流程

1. 主 agent 进本仓 / 接 task 前**必扫此目录**未处理 signal
2. 有未处理 → **先处理这些**，后做其它
3. 处理后 `mv` 到 `docs/halt/resolved/<ts>-<reason>.md` 并加「resolved」节
4. 如果 HALT 导致 INVARIANTS 或主仓 ADR 调整，对应文档同步更新
