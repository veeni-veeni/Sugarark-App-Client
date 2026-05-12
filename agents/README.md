# Agents — Sugarark-App-Client

> 角色 prompt 文件。每个角色含 NORTH_STAR + 工作流 + 常见借口反驳。

## 6 角色

| 角色 | 文件 | 职责 |
|---|---|---|
| orchestrator | orchestrator.md | 拆任务 / 控范围 / 派 subagent |
| developer | developer.md | 实施 Flutter 业务代码 + UI + IM 集成 |
| reviewer | reviewer.md | 独立审查代码 / 复核 PR |
| tester | tester.md | 写测试 + 跑测试 + 验证 |
| security-auditor | security-auditor.md | 安全敏感 task 必跑（auth / token / PII / 视频） |
| strategic-reviewer | strategic-reviewer.md | MISSION lock / 大方向决策时挑战 scope |

## 主项目身份

详见 `sugarark/agents/`（主项目角色文档）。本仓只补 Flutter User App 子仓特定补充。
