# tmux笔记


- [tmux笔记](#tmux笔记)
  - [基本概念](#基本概念)
  - [创建session](#创建session)
  - [进入session](#进入session)
  - [脱离session](#脱离session)
  - [创建window](#创建window)
  - [拆分window（创建pane）](#拆分window创建pane)
  - [删除session/window/pane](#删除sessionwindowpane)
  - [其他指令](#其他指令)

> 这并不是一个完整的tmux学习笔记，只是非常简要的笔记和速查手册，完整内容还是直接看[tmux Github文档](https://github.com/tmux/tmux/wiki/Getting-Started)


## 基本概念


<img src="https://raw.githubusercontent.com/fenglielie/notes_image/main/img/tmux2.webp"/>


tmux为终端复用器，可以启动一系列终端会话，可以将会话和终端窗口分离：关闭终端窗口再打开，会话并不终止，而是继续运行在执行，这可以有效避免因网络波动等导致的会话中断，也便于开启多窗口任何。

tmux在逻辑上存在三层概念: session（会话）> window（窗口）> pane（窗格）。

1. session
   * session具有名称，可以自定义，或者使用索引作为名称
   * 远程登录时开启tmux client客户端，然后可以attach到一个session
   * session可以被一个或多个client attach（相当于从多个设备同时登入），或者处于detached状态，只是在后台运行
   * session可以包含一组window：一个屏幕装不下了，把所有东西暂移出去，新建一个空的window。在同一时刻只能呈现一个current window
2. window
   * window具有索引，同时也具有名称（默认名称是当前active pane运行的程序名）
   * window可以被一个或多个window包含（通常只属于一个window）
   * window可以包含一组pane，但是同一时刻只有一个active pane（活跃的，光标所在的）
   * window记录了其中的pane的布局规则
3. pane
   * pane是最小单位，程序或指令在一个pane上运行，多个程序分别在多个pane同时运行


注意：

* tmux使用的配置文件为`~/.tmux.conf`
* 可以使用命令输入具体tmux指令，也可以使用快捷键，tmux的快捷键都需要使用一个固定前缀触发，默认前缀`prefix=ctrl+b`，可以修改为其他前缀，例如`ctrl+\`
* 不同设备同时打开一个session，即多个client连接到同一个session，可能会因为屏幕尺寸不同，出现显示错误
* 可以像vim一样，在`prefix`之后使用`:`然后键入指令，此时的指令不再需要输入`tmux`



## 创建session

使用`new-session`可以创建session，默认索引作为名称，也可以自定义名称，通常用`new`作为`new-session`的简写，`-s`通常是session名称选项
```
tmux new
tmux new -s session_name
```
注意session的名称不能重复，使用`-A`选项在不存在时自动创建，在已存在时自动进入
```
tmux new -A session_name
```

创建session可以附加命令，在默认window的默认pane执行command指令
```
tmux new [command]
```

创建session之后，可以指定window名称
```
tmux new -s session_name -n window_name
```

创建session可以直接挂到后台，而非自动attach到session
```
tmux new -d
```

注意，不能在session内部创建session，必须退出tmux进行。


## 进入session

使用`attach`可以进入一个已存在的session（attach），这里`attach`可以简写为`a`
```
tmux attach -t the_session
tmux a -t the_session
```
不指定session时，默认attach到最近的一个session
```
tmux a
```
使用`-d`选项具有排他性：attach到session之后，会使得其他attach到当前session的client断开
```
tmux a -d -t the_session
```

## 脱离session

使用`detach`可以脱离session，但是session仍然在后台运行（因此用脱离比退出更贴切）
```
tmux detach
```
**快捷键`prefix+d`脱离当前的session**


## 创建window

使用`new-window`可以创建window，默认索引作为名称，也可以自定义名称，通常用`neww`作为`new-window`的简写，`-n`通常是window名称选项
```
tmux neww -n window_name
```
如果不在session中，则会在最近的session创建window

使用`-d`在后台创建window，但不会切换过去
```
tmux neww -d
```

**快捷键`prefix+c`创建新的window并切换**
**快捷键`prefix+n`切换到下一个window**
**快捷键`prefix+2`切换到序号为2的window**

## 拆分window（创建pane）

可以拆分当前window得到多个pane，可以支持上下分割和左右分割
```
tmux split-window -v // 上下分割
tmux split-window -h // 左右分割
```

直接使用鼠标点击不同区域（需要在配置中开启鼠标），或者使用`prefix`加上方向键，可以让光标在不同pane之间切换。
直接使用鼠标拖动边，或者使用`prefix`加上ctrl方向键，可以调整window的布局。

**快捷键`prefix+z`临时放大当前的pane为全屏，再按一次恢复**



## 删除session/window/pane

使用`kill-server`可以在server层面，直接删除所有session
```
tmux kill-server
```

使用`kill-session`可以删除session，可以指定名称，或者默认删除上一个session
```
tmux kill-session
tmux kill-session -t session_name
```

使用`kill-window`可以删除当前window以及它的所有pane，
```
tmux kill-window
```
**快捷键`prefix+&`可以删除当前window**

使用`kill-pane`可以删除当前pane，默认都是当前的window/pane。
```
tmux kill-pane
```
**快捷键`prefix+x`删除当前pane（光标所在的active pane）**


`logout`和`exit` 也能直接退出并删除当前的pane(如果只有一个pane，则删除整个window，如果只有一个window，则删除整个session)


## 其他指令

* 查询当前运行的所有session `tmux ls`
  * 如果在session中查询，则列表中当前的session会标记attached
* 重命名session `tmux rename -t oldname newname`，同理可以重命名window
  * 快捷键`prefix+$` 重命名当前session
  * 快捷键`prefix+,` 重命名当前window
* 查询并处理当前所有的session/window/pane，以树的方式呈现
  * 进入有如下两组快捷键
    * 快捷键`prefix+w` 默认展开所有项
    * 快捷键`prefix+s` 默认只呈现session层信息，可以使用左右键展开或收起不同的层
  * 查询并移动到树的指定位置，然后回车即可完成切换；或者使用`q`撤销切换
  * 使用`x`可以删除指定的项，需要`y`确认
