# Handoff Template

> 每次 agent 会话结束前必写，给下个 agent / 未来的自己看。
> 文件名: `<YYYY-MM-DD-HHMMSS>-<from-role>-to-<to-role>.md`

---

# Handoff: <from-role> → <to-role>

- **日期**: YYYY-MM-DD HH:MM:SS
- **From**: <agent identifier>
- **To role**: orchestrator | developer | reviewer | tester | user
- **关联 ADR**: ADR-NNNN（本仓）/ sugarark/ADR-NNNN（主仓）
- **关联 BACKLOG 项**: TASK-25x

## 我做了什么

- 实施了 ...（commit hash）
- 写了 ADR ...（status: proposed/accepted）
- 跑了测试: ...

## 当前状态

- ✅ 已完成: <list with commit hashes>
- 🔄 进行中: <file paths, % done>
- ⏸️ 阻塞: <blocker>

## 验证输出（必填）

```
$ <BACKLOG 里那条验证命令>
<真实 stdout/stderr — 必须粘原文，不接受"已通过"等文字声明>
```

命令失败 → 写在「阻塞」，**不要**标记任务完成。

## 你接下来要做什么

明确输入:
- ...

验收标准:
- ...

红线（不能改）:
- ...

## 我没解决但你要知道的事

- 副作用: ...
- 边界情况未覆盖: ...
- 可能违反的 INVARIANT: （请检查）...

## 跨仓影响

- 主仓 sugarark 是否需要联动改动？
- talkcore 是否需要联动改动？
- 姊妹仓 sugarark-staff-client 是否需要联动改动？

## 测试状态

- invariants 自检: 绿/红
- 单测: 绿/红
- iOS 构建: 绿/红
- Android 构建: 绿/红
- e2e: 绿/红/没跑
