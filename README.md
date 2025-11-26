# Claude Code + Codex 协作开发环境

> 🚀 3步配置，5分钟上手，让AI协作开发变得简单。
> **现已完美支持 Windows (PowerShell), macOS 和 Linux!**

## 📋 快速开始

### 🖥️ Windows 用户 (PowerShell)

我们为 Windows 用户提供了专门的 PowerShell 自动化脚本，支持自动识别 Codex 路径并配置环境。

1. **运行安装脚本**
   在 PowerShell 中执行：
   ```powershell
   .\install.ps1
   ```
   *脚本会自动完成以下操作：*
   * ✅ 检测 Node.js, Python 等依赖
   * ✅ 自动定位 Codex 可执行文件 (支持 NPM 全局安装路径)
   * ✅ 生成适配 Windows 的配置文件
   * ✅ 创建 `.claude` 数据目录结构

2. **配置命令行版 (Claude CLI) [可选]**
   如果您使用终端版的 `claude`，请运行以下命令将工具注册到全局：
   ```powershell
   # 注册 Codex (请根据实际安装路径调整)
   claude mcp add codex "C:\Users\YourName\AppData\Roaming\npm\node_modules\@openai\codex\vendor\x86_64-pc-windows-msvc\codex\codex.exe" mcp-server --scope user

   # 注册其他工具
   claude mcp add sequential-thinking npx.cmd -- -y @modelcontextprotocol/server-sequential-thinking --scope user
   claude mcp add shrimp-task-manager npx.cmd -- -y mcp-shrimp-task-manager --scope user
   claude mcp add code-index uvx code-index-mcp --scope user
   ```

### 🍎 macOS / � Linux 用户

1. **运行一键安装**
   ```bash
   ./install.sh
   ```

2. **选择配置类型**
   脚本会提供三种配置选项：
   - **简单配置**：基础协作功能 (Codex + Thinking)
   - **标准配置**：完整开发环境 (+ 任务管理 & 代码索引)
   - **高级配置**：企业级功能 (+ 浏览器调试 & 联网搜索)

---

## 🛠️ 核心功能与工具链

本环境集成了以下强大的 MCP (Model Context Protocol) 工具：

### 1. � Sequential Thinking (深度思考)
- **作用**：让 AI 在编码前进行深度逻辑推理和步骤规划。
- **使用场景**：遇到复杂算法、架构设计或难以定位的 Bug 时。
- **指令示例**：`"请使用 sequential-thinking 分析这个问题"`

### 2. � Codex (代码核心)
- **作用**：OpenAI 提供的强大代码分析与生成引擎。
- **能力**：
  - 代码库扫描与检索
  - 复杂逻辑设计
  - 自动化代码审查
- **指令示例**：`"请用 codex 扫描当前目录结构"`

### 3. 🦐 Shrimp Task Manager (任务管理)
- **作用**：用于长任务的规划、拆解和状态追踪。
- **优势**：确保 AI 在长对话中不会"迷路"，清晰记录已完成和待办事项。
- **指令示例**：`"创建一个任务计划来实现登录功能"`

### 4. 🔍 Code Index (代码索引)
- **作用**：建立本地代码索引，实现毫秒级代码搜索。
- **指令示例**：`"搜索所有引用了 User 类的地方"`

---

## � 使用指南

### 方式一：Claude Desktop (图形界面)
1. 打开 Claude 桌面应用。
2. 在聊天框输入 `/available-tools` 验证工具是否加载。
3. 直接拖入文件或描述需求，AI 会自动调用工具。

### 方式二：Claude CLI (命令行)
1. 在终端输入 `claude` 启动。
2. 输入 `/mcp list` 查看工具状态。
3. 适合快速文件操作、Git 提交和脚本编写。

---

## 🔍 常见问题 (Windows)

**Q: 运行 `install.ps1` 提示权限错误？**
A: 请先运行 `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` 允许脚本执行。

**Q: Claude CLI 提示 "No MCP servers configured"？**
A: CLI 和 Desktop 的配置是隔离的。请参考上文 "配置命令行版" 章节，使用 `claude mcp add --scope user` 命令手动注册工具。

**Q: Codex 路径找不到？**
A: 推荐使用 NPM 全局安装 Codex。安装脚本会自动在 `%APPDATA%\npm\node_modules` 下查找。如果使用 VSCode 插件版，请手动指定路径。

---

## � 目录结构说明

所有工具产生的数据都会保存在项目根目录的 `.claude/` 文件夹中：
```text
.claude/
├── shrimp/         # 任务管理数据
├── codex/          # Codex 分析缓存
├── context/        # 上下文记录
└── logs/           # 操作日志
```

## 🤝 贡献
欢迎提交 Issue 或 PR 改进 Windows 脚本支持！

## 📄 许可证
MIT License