# tmux 笔记

- [tmux 笔记](#tmux-笔记)
  - [基本概念](#基本概念)
  - [创建 session](#创建-session)
  - [进入 session](#进入-session)
  - [脱离 session](#脱离-session)
  - [创建 window](#创建-window)
  - [拆分 window（创建 pane）](#拆分-window创建-pane)
  - [删除 session/window/pane](#删除-sessionwindowpane)
  - [其他指令](#其他指令)

> 这并不是一个完整的 tmux 学习笔记，只是非常简要的笔记和速查手册，完整内容还是直接看[tmux Github 文档](https://github.com/tmux/tmux/wiki/Getting-Started)

## 基本概念

<img src="https://raw.githubusercontent.com/fenglielie/notes_image/main/img/tmux2.webp"/>

tmux 为终端复用器，可以启动一系列终端会话，可以将会话和终端窗口分离：关闭终端窗口再打开，会话并不终止，而是继续运行在执行，这可以有效避免因网络波动等导致的会话中断，也便于开启多窗口任何。

tmux 在逻辑上存在三层概念: session（会话）> window（窗口）> pane（窗格）。

1. session
   - session 具有名称，可以自定义，或者使用索引作为名称
   - 远程登录时开启 tmux client 客户端，然后可以 attach 到一个 session
   - session 可以被一个或多个 client attach（相当于从多个设备同时登入），或者处于 detached 状态，只是在后台运行
   - session 可以包含一组 window：一个屏幕装不下了，把所有东西暂移出去，新建一个空的 window。在同一时刻只能呈现一个 current window
2. window
   - window 具有索引，同时也具有名称（默认名称是当前 active pane 运行的程序名）
   - window 可以被一个或多个 window 包含（通常只属于一个 window）
   - window 可以包含一组 pane，但是同一时刻只有一个 active pane（活跃的，光标所在的）
   - window 记录了其中的 pane 的布局规则
3. pane
   - pane 是最小单位，程序或指令在一个 pane 上运行，多个程序分别在多个 pane 同时运行

注意：

- tmux 使用的配置文件为`~/.tmux.conf`
- 可以使用命令输入具体 tmux 指令，也可以使用快捷键，tmux 的快捷键都需要使用一个固定前缀触发，默认前缀`prefix=ctrl+b`，可以修改为其他前缀，例如`ctrl+\`
- 不同设备同时打开一个 session，即多个 client 连接到同一个 session，可能会因为屏幕尺寸不同，出现显示错误
- 可以像 vim 一样，在`prefix`之后使用`:`然后键入指令，此时的指令不再需要输入`tmux`

## 创建 session

使用`new-session`可以创建 session，默认索引作为名称，也可以自定义名称，通常用`new`作为`new-session`的简写，`-s`通常是 session 名称选项

```
tmux new
tmux new -s session_name
```

注意 session 的名称不能重复，使用`-A`选项在不存在时自动创建，在已存在时自动进入

```
tmux new -A session_name
```

创建 session 可以附加命令，在默认 window 的默认 pane 执行 command 指令

```
tmux new [command]
```

创建 session 之后，可以指定 window 名称

```
tmux new -s session_name -n window_name
```

创建 session 可以直接挂到后台，而非自动 attach 到 session

```
tmux new -d
```

注意，不能在 session 内部创建 session，必须退出 tmux 进行。

## 进入 session

使用`attach`可以进入一个已存在的 session（attach），这里`attach`可以简写为`a`

```
tmux attach -t the_session
tmux a -t the_session
```

不指定 session 时，默认 attach 到最近的一个 session

```
tmux a
```

使用`-d`选项具有排他性：attach 到 session 之后，会使得其他 attach 到当前 session 的 client 断开

```
tmux a -d -t the_session
```

## 脱离 session

使用`detach`可以脱离 session，但是 session 仍然在后台运行（因此用脱离比退出更贴切）

```
tmux detach
```

**快捷键`prefix+d`脱离当前的 session**

## 创建 window

使用`new-window`可以创建 window，默认索引作为名称，也可以自定义名称，通常用`neww`作为`new-window`的简写，`-n`通常是 window 名称选项

```
tmux neww -n window_name
```

如果不在 session 中，则会在最近的 session 创建 window

使用`-d`在后台创建 window，但不会切换过去

```
tmux neww -d
```

**快捷键`prefix+c`创建新的 window 并切换**
**快捷键`prefix+n`切换到下一个 window**
**快捷键`prefix+2`切换到序号为 2 的 window**

## 拆分 window（创建 pane）

可以拆分当前 window 得到多个 pane，可以支持上下分割和左右分割

```
tmux split-window -v // 上下分割
tmux split-window -h // 左右分割
```

直接使用鼠标点击不同区域（需要在配置中开启鼠标），或者使用`prefix`加上方向键，可以让光标在不同 pane 之间切换。
直接使用鼠标拖动边，或者使用`prefix`加上 ctrl 方向键，可以调整 window 的布局。

**快捷键`prefix+z`临时放大当前的 pane 为全屏，再按一次恢复**

## 删除 session/window/pane

使用`kill-server`可以在 server 层面，直接删除所有 session

```
tmux kill-server
```

使用`kill-session`可以删除 session，可以指定名称，或者默认删除上一个 session

```
tmux kill-session
tmux kill-session -t session_name
```

使用`kill-window`可以删除当前 window 以及它的所有 pane，

```
tmux kill-window
```

**快捷键`prefix+&`可以删除当前 window**

使用`kill-pane`可以删除当前 pane，默认都是当前的 window/pane。

```
tmux kill-pane
```

**快捷键`prefix+x`删除当前 pane（光标所在的 active pane）**

`logout`和`exit` 也能直接退出并删除当前的 pane(如果只有一个 pane，则删除整个 window，如果只有一个 window，则删除整个 session)

## 其他指令

- 查询当前运行的所有 session `tmux ls`
  - 如果在 session 中查询，则列表中当前的 session 会标记 attached
- 重命名 session `tmux rename -t oldname newname`，同理可以重命名 window
  - 快捷键`prefix+$` 重命名当前 session
  - 快捷键`prefix+,` 重命名当前 window
- 查询并处理当前所有的 session/window/pane，以树的方式呈现
  - 进入有如下两组快捷键
    - 快捷键`prefix+w` 默认展开所有项
    - 快捷键`prefix+s` 默认只呈现 session 层信息，可以使用左右键展开或收起不同的层
  - 查询并移动到树的指定位置，然后回车即可完成切换；或者使用`q`撤销切换
  - 使用`x`可以删除指定的项，需要`y`确认
