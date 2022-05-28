# luogu-bash

洛谷刷题辅助脚本，可以方便地给源代码进行储存、管理和执行。

## 用法

```bash
luogu <subcommand> [...]
```

### 子命令

```bash
new <number>	创建一个新的源代码
delete <number>	删除现有源代码
cd <number>	切换到指定源代码的路径并打开新的bash
show [number]	显示源代码目录 (使用 nautilus)
edit [number]	编辑源代码、输入
code [number]	用 Visual Studio Code 打开工作区
complie	[number]编译当前目录下的源代码
run [number]	运行当前目录下的源代码并输出到out文件
rrun [number]	先complie再run
help		显示此消息
```

## 安装

1. 创建一个 `luogu` 文件夹（可以是其他名字），作为源代码存库
2. 将 `luogu.bash` `luogu-completion.bash` 保存在 `luogu` 内
3. 执行 `chmod +x luogu.bash` 和 `chmod +x luogu-completion.bash` 给脚本授予执行权限
4. 在 `~/.bash_aliases` 内添加以下内容
```bash
LUOGU_PATH=/home/ye_tianshun/桌面/luogu（luogu的文件夹）
alias "luogu"="$LUOGU_PATH/luogu.sh"
if [ -f "$LUOGU_PATH/luogu-completion.bash" ]; then
        "$LUOGU_PATH/luogu-completion.bash"
fi
```
5. 用 `source ~/.bash_aliases` 加载脚本
6. 在 `bash` 内输入 `luogu` 并按两下 Tab 键，输入 `luogu help` 以检验脚本是否安装成功

<!-- hello dream! -->
