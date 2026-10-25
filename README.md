# dsh-wechat-media-turbo

给 [`dsh-wechat-media`](https://github.com/wjh-ux/dsh-wechat-media) 的微信聊天层：**鲸鱼娘·大肥鱼**人设 + 接梗规则 + 精简工具集 + 短回复约定。

本包不含运行时代码，只提供一个 Cordis 组合层（bundle）：注册 agent preset `whale-lean`，并把 `wechat-media` 行挂到它上面。

## 实测

本机 macOS，`deepseek-flash` / `reasoningEffort=max`，8 条微信语料，`reply:false` 不出站：

| 指标 | standard（基线） | whale-lean | 变化 |
|---|---:|---:|---:|
| 平均响应 | 1413 ms | 1022 ms | −27.7% |
| p50 | 1475 ms | 1049 ms | −28.9% |
| 首轮提示词 token | 5781 | 5283 | −8.6% |
| 8 轮提示词总量 | 50,099 | 43,892 | −12.4% |
| 8 轮输出 token | 846 | 253 | −70.1% |
| 平均回复字数 | 46 | 35 | −23.4% |
| 人设一致性 | 0/5 | 5/5 | |
| 接梗 | 0/5 | 5/5 | |

完整报告（逐条延迟、对话对照、rubric、限制）见 [REPORT.md](./REPORT.md)，原始数据在 [bench/](./bench)。

## 改了什么

| 项目 | 标准 preset | whale-lean |
|---|---|---|
| 人设 | `You are a coding agent...` | 鲸鱼娘·大肥鱼（语气 + 接梗 + 心声 + 硬规则） |
| preset 插件行 | 32 | 18 |
| 工具类行 | 20 | 10 |
| 技能目录 / skill 工具 | 有 | 移除（微信闲聊用不上，省掉大段 catalog） |
| 子 agent / workflow | 有 | 移除（schema 大，微信场景少用） |
| goal 工具 | 有 | 移除 |
| present（GUI 专用） | 有 | 移除 |
| 回复约定 | 无 | 先结论后吐槽；闲聊 ≤60 字；闲聊不调工具；不输出标题/表格 |

保留：文件读写与搜索、bash/pwsh、后台任务、定时任务、web 搜索、todo、ask_user、计划模式、上下文压缩。微信桥自己的发送文件 / 发图工具不受影响。

## 安装

### 从本仓库构建

```sh
git clone https://github.com/bigfatdsh/dsh-wechat-media-turbo.git
cd dsh-wechat-media-turbo
./pack.sh
```

然后把打印出来的 tgz 路径交给插件管理器：

```
plugin_manager install_bundle target=file:<abs>/dsh-wechat-media-turbo-0.1.0.tgz
```

### 已在本机安装

`desktop` profile 里装的是 `file:` 指向本机 tgz 的 bundle；重新安装或升级用同一条命令即可。

安装后 **重启 DSH**（或让桥开新会话）才会用新 preset：preset 在 agent 创建时挂载，已存在的微信会话保持原来的 `standard`。会话里发 `/new` 也能切。

## 回退

`plugin_manager remove_bundle target=dsh-wechat-media-turbo`，重启即可。这个包不改 `dsh-wechat-media` 的任何文件，只覆盖它的组合层配置。

## 限制

- 覆盖 `wechat-media` 行 config 时整段替换，因此这里显式保留了 `baseUrl` / `botType`；升级 `dsh-wechat-media` 若新增 config 字段，需要同步加进 `cordis.patch.yml`。
- 人设/接梗质量取决于所配模型；数据是单次测量，看均值与 p50，不要看单条。
- 基线首轮命中了共享前缀缓存、`whale-lean` 首轮没有，这组对比对基线有利。

## 致谢与许可

「大肥鱼」是社区对 DeepSeek 的二次创作鲸鱼娘形象。本项目的提示词参考了 MIT 许可的 [dafeiyu-persona](https://github.com/ERUIHNIYHBKBNF/dafeiyu-persona)，在其基础上压缩，并加入接梗词表、省时约定与微信场景规则。

本项目 MIT，见 [LICENSE](./LICENSE)。
