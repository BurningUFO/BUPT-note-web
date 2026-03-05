# BUPT Note Web

个人课程笔记网站仓库，基于 `MkDocs + Material for MkDocs`，通过 GitHub Actions 自动发布到 GitHub Pages。  
作者：`BurningUFO`

公网地址：
- `https://burningufo.github.io/BUPT-note-web/`

## 项目结构

- `docs/`: 网站内容（Markdown 笔记）
- `mkdocs.yml`: 站点配置、导航、主题
- `.github/workflows/ci.yml`: 自动部署工作流
- `scripts/publish.ps1`: 同步 + 构建 + 提交 + 推送脚本
- `scripts/sync-config.json`: 外部笔记目录映射配置
- `publish.bat`: 一键入口（Windows）

## 一键发布流程

在仓库根目录运行：

```powershell
.\publish.bat
```

脚本会按顺序执行：
1. 从外部源目录同步 `.md` 到 `docs/` 指定课程目录
2. 自动生成每个课程目录的 `README.md` 索引页
3. 本地构建检查（默认 `mkdocs build`）
4. `git add` + 自动提交
5. `git push` 到 `main`
6. GitHub Actions 自动发布到 Pages

## 常用命令

- 只同步，不提交不推送：

```powershell
.\publish.bat -SyncOnly
```

- 同步并提交，但不推送：

```powershell
.\publish.bat -NoPush
```

- 跳过本地构建检查：

```powershell
.\publish.bat -SkipBuild
```

- 使用严格检查（可能因外部文档缺失资源链接而失败）：

```powershell
.\publish.bat -StrictBuild
```

- 指定提交信息：

```powershell
.\publish.bat -Message "docs: update course notes"
```

## 外部笔记同步配置

编辑：
- `scripts/sync-config.json`

每个 `mapping` 对应一门课，关键字段：
- `source`: 外部笔记源目录（绝对路径）
- `target`: 本仓库内目标目录（通常是 `docs\xx-...`）
- `recurse`: 是否递归扫描子目录
- `deleteMissing`: 是否删除目标目录中已不存在于源目录的 `.md`
- `excludeFileNames`: 同步排除文件名（如 `prompt.md`）
- `readmeTitle`: 自动生成目录页标题

## 本地预览

```powershell
mkdocs serve
```

默认访问：
- `http://127.0.0.1:8000/`

## 发布说明

- 触发条件：推送到 `main` 或 `master`
- 发布命令：`mkdocs gh-deploy --force`
- Pages 分支：`gh-pages`

如果刚推送后公网地址未更新，通常等待 1-5 分钟即可。
