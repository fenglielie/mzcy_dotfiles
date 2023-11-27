# Git 笔记

- [Git 笔记](#git-笔记)
	- [Git 必要配置](#git-必要配置)
	- [Git 基础操作](#git-基础操作)
		- [创建或获取项目](#创建或获取项目)
		- [添加快照](#添加快照)
		- [查看状态](#查看状态)
		- [移除已跟踪项](#移除已跟踪项)
		- [移动已跟踪项](#移动已跟踪项)
		- [提交快照](#提交快照)
		- [日志查看](#日志查看)
		- [命令别名](#命令别名)
		- [清理工作目录](#清理工作目录)
	- [Git 分支操作](#git-分支操作)
		- [分支基础](#分支基础)
		- [分支切换（checkout）](#分支切换checkout)
		- [分支切换（switch）](#分支切换switch)
		- [分支合并](#分支合并)
		- [分支变基](#分支变基)
		- [标签](#标签)
	- [Git 撤销原理](#git-撤销原理)
		- [reset](#reset)
		- [restore](#restore)
		- [checkout](#checkout)
	- [Git 撤销操作](#git-撤销操作)
		- [部分撤销（工作目录）](#部分撤销工作目录)
		- [部分撤销（index）](#部分撤销index)
		- [部分撤销（工作目录和 index）](#部分撤销工作目录和-index)
		- [整体撤销（工作目录）](#整体撤销工作目录)
		- [整体撤销（index）](#整体撤销index)
		- [整体撤销（工作目录和 index）](#整体撤销工作目录和-index)
		- [修正 commit](#修正-commit)
		- [回退 commit](#回退-commit)
	- [Git 底层原理](#git-底层原理)
		- [数据存储原理](#数据存储原理)
		- [index原理](#index原理)
		- [提交原理](#提交原理)
		- [分支原理](#分支原理)

> 这并不是一个完整的 Git 学习笔记，只是非常简要的笔记和速查手册，完整内容还是直接看 [Git 官方手册](https://git-scm.com/book/zh/v2)

<img src="https://raw.githubusercontent.com/fenglielie/notes_image/main/img/git-demo.png"/>

## Git 必要配置

首先，Git 配置分成三层，第一层是系统级，第二层是用户级，第三层是仓库级，通常会修改用户级的配置文件`~/.gitignore`。

添加用户名和邮箱，这是用于在提交信息上署名

```
git config --global user.name "xxxx"
git config --global user.email "xxxx@xx.com"
```

将默认分支设置为 main（由于历史原因，默认为 master）

```
git config --global init.defaultBranch main
```

指定编辑提交信息使用的编辑器，默认可能是 vim 或者 Nano（ctrl+x 退出）或者记事本

```
git config --global core.editor vim
```

如果在编辑提交信息时，突然想要取消，可以留下空的文本并退出编辑器，git 会拒绝没有提交信息的 commit。

除此之外，还有一些编码设置和换行符设置，当前使用的完整`.gitignore`配置文件如下

```
[user]
	name = xxx
	email = xxx@xx.com
[init]
	# 默认主分支名称
	defaultBranch = main
[core]
	# 默认编辑器
	editor = vim
	# 确保git正确显示中文信息
	quotepath = false
	# 在提交时将所有文本的换行符转换为LF，检出时不转换
	autocrlf = input
	# 检查文本的换行符，对于混合换行符的文件不允许提交
	safecrlf = true
[i18n]
	# 确保提交信息utf-8编码
	commitEncoding = utf-8
[gui]
	# 确保gui使用utf-8编码
	encoding = utf-8
```

## Git 基础操作

### 创建或获取项目

`git init`创建空仓库。

`git clone`从 URL 克隆现有仓库：

```
git clone https://github.com/libgit2/libgit2
git clone https://github.com/libgit2/libgit2 mylibgit
```

可以指定本地仓库的名称，缺省名称时使用与 URL 相同名称创建本地文件夹。

`git clone`实际上是一个相当于依次调用了如下命令：

1. 创建了一个新目录，并切换到新目录
2. `git init`初始化一个空的 Git 仓库
3. 根据 URL 添加一个（默认命名为 origin）远程仓库（`git remote add`）
4. 对远程仓库执行`git fetch`获取远程仓库的内容
5. 在本地创建与远程仓库的分支同名的本地分支，并将同名分支分别绑定
6. 执行`git checkout`将远程仓库的最新提交检出到本地的工作目录。

如果克隆的仓库过大，考虑网络原因，可以舍弃 git 的历史数据，使用`--depth 1`选项只会获取最新的提交版本。

如果在服务器搭建，通常会选择搭建裸仓库，裸仓库的名称习惯为`xxx.git`，此时的仓库相当于只是一个`.git/`文件夹，没有工作目录，例如

```
git init --bare xxx.git
```

### 添加快照

`git add`命令可以添加未记录的或已记录但发生变化的文件到 index

```
git add <filename>
```

可以添加路径的所有项，也支持通配符

```
git add <path>
git add .

git add *
```

但是这些做法非常不建议，因为这可能无意间添加大文件和垃圾文件到数据库中，即使撤销了`git add`，这些数据仍然存在于数据库中。

`git add`只会记录当前文本的快照，如果在`git add`之后进行了修改，那么必须再次执行`git add`才会把最新的快照保存到数据库，并更新 index。

`git add`做的一切都是为了下一次的正式提交做准备，在正式提交之后，index 就会被重置。

### 查看状态

`git status`是非常常用的命令，可以查看当前的状态，文件被 git 直接分成两类：

- 未跟踪的项
- 已跟踪的项

除此之外，`.gitignore`文件所匹配的项会被 git 直接忽略。状态信息包括：

- 工作目录和 index 的对比
  - 未追踪的项
  - 已追踪的项，未提交到 index 的变化（修改，重命名，删除等）
- index 和 HEAD 对应的提交版本的对比
  - 新追踪的项
  - 已追踪的项，提交到 index 的变化（修改，重命名，删除等）

如果`git status`信息过多，可以加选项`--short`(`-s`)得到更简短的状态信息：`D`代表删除，`A`代表添加，`M`代表修改，处于第一列对应 index 状态和 HEAD 的比较，处于第二列对应工作目录中的当前状态和 index 的比较，`??`代表未跟踪的项。
例如

```
 M README
MM Rakefile
A  lib/git.rb
M  lib/simplegit.rb
?? LICENSE.txt
```

除了简明的信息，还可以使用`git diff`直接显示它们具体的差异

- `git diff` 默认对比 index 和当前工作目录的差异
- `git diff --staged` 对比 HEAD 对应的提交版本和 index 的差异

也可以添加文件名，只显示指定文件的差异

```
git diff filename
git diff --staged filename
```

注：通常情况下，`--cached`和`--staged`是同义词，是别名的关系，但是对于某些命令，输出的结果略有不同。

### 移除已跟踪项

如果需要移除已经被 git 纳入版本控制的文件，单纯在文件系统中执行`rm`是不够的：此时 index 显示文件存在（基于上一次的提交版本），工作目录显示文件不存在，需要将修改反馈给 index，执行`git rm`

```
git rm filename
# or
git add filename
```

其中`git rm`会自动尝试删除工作目录中的文件，并记录这次移除，而`git add`只会记录这次变化行为。

`git rm`命令要求被删除的项保持 HEAD-index-工作目录三者一致，换言之，它不会在`git status`中被显示，此时才会允许`git rm`，具体行为逻辑如下：

- `git rm`会删除工作目录中的文件，并更新 index
- `git rm`如果加上`--staged`选项，则只更新 index，在其中记录某个文件被移除，不会在工作目录中操作
- 如果希望只在工作目录中移除，而不影响 index，直接使用`/bin/rm`

注意，如果被删除的项在 HEAD-index-工作目录存在任何差异，那么需要加入`-f`选项才能强制删除，这是为了防止数据丢失。

### 移动已跟踪项

如果需要移动已经被 git 纳入版本控制的文件，可以直接在文件系统中`mv`，这个操作会被 git 检测到并视作移动，但是并没有更新到 index。
执行`git mv`可以在移动的同时反馈给 index

```
git mv a b
```

等效于如下指令

```
mv a b
git rm a
git add b
```

### 提交快照

`git commit`可以提交一次正式快照，生成一个 commit 对象，并把当前分支和 HEAD 后移，commit 对象会指向前一个快照的 commit 对象，维护分支链表。

```
git commit

git commit -m "add something"
```

commit 对象需要一个非空的 message，git 会自动启动编辑器来输入 message，或者使用`-m`直接添加 message

使用`-a`可以在提交之前，对所有已追踪的项自动添加到 index，但是不会处理未被跟踪的项，相当于自动跳过了`git add`过程

```
git commit -a -m "add all files"
```

### 日志查看

`git log`可以查看提交日志，有如下常用选项：

- `--oneline`，简略输出，每一次提交的信息只占据一行
- `--graph`，分支绘图，会通过字符绘制分支的状态，包括合并等等
- `--all`，展示所有分支的日志，否则只会呈现当前分支的日志
- `-<n>`，例如`-3`查看最近的 3 次提交
- `--since=2.weeks` `--since="2020-01-01"` 可以在提交日志中按照时间或其他条件筛选
- `-S key_word` 可以在提交日志中筛选：含有字符串`key_word`的添加或删除的提交，可以用来关注某个关键词的修改历史
- `-p filename` 可以筛选指定文件的日志

例如

```
git log --oneline --graph --all -5
```

可以使用 HEAD 或者分支名，或者标签，指定对应的日志，也可以指定提交对象的哈希值，查看指定的一次提交

```
git log develop

git log 907e
```

### 命令别名

git 可以给常用的命令以及选项添加别名（不含`git`前缀），直接以字符串形式进行替换。

例如

```
git config --global alias.ci commit
```

这个别名设置使得`ci`被直接替换为`commit`，下面两个命令等效

```
git ci ...
git commit ...
```

例如

```
git config --global alias.last 'log -1 HEAD'
```

这个别名设置使我们可以使用下面的语句直接查看最后一次提交

```
git last
git log -1 HEAD
```

### 清理工作目录

删除当前目录下所有未被跟踪的文件，但是不含那些`.gitignore`匹配的文件

```
git clean
```

这个操作非常危险，因此通常需要`-f`强制确认，可以使用`-n`预演一遍，展示将要清理哪些文件

```
git clean -n
```

这个命令主要用于在编译或某些操作之后，工作目录产生了很多的垃圾临时文件，此时可以直接清理恢复工作目录。

## Git 分支操作

### 分支基础

git 的版本控制不是单一主线的，而是维持一个版本链表结构，特点如下：

- 链表的每一个结点代表一次正式提交
- 链表的每一个结点都有至少一个父结点，除了最初的结点，可能存在两个父结点
- 链表最新的一头通常需要一个指针来确定头部位置，这个指针就是**分支**，例如默认分支就是 main
- 链表可以有很多个分叉，链表的分叉也可能再次合并或分叉，每一个链表分叉的最新结点都通过一个分支定位，否则就处于游离状态
- 当前所处的状态通过**HEAD**指针标记，它是一个二级指针，通常指向一个分支，可以自由切换指向任何一个存在的分支，并操作这个分支的移动
- 提交会新建一个提交结点，并指向 HEAD 当前所间接指向的结点，然后 HEAD 指向的分支会前移到新结点上
- 链表中可能存在游离的结点：既没有结点指向它，也没有分支指向它。这可能由版本回撤导致，此时这个结点代表的版本数据仍然保存在数据库中，但是版本历史以及正常操作中无法直接获取，需要高级的命令才可以恢复数据

`git branch`可以创建分支，新的分支会指向当前 HEAD 所间接指向的提交结点

```
git branch branch_name
```

`-d`选项可以删除指定分支

```
git branch -d branch_name
```

如果希望列出所有的分支，直接使用`git branch`不带任何参数，如果加上`-v`选项则会更详细地列出分支以及指向的提交结点信息

```
git branch
git branch -v
```

这里默认只显示本地分支，如果希望显示远程分支，需要`-r`选项，或者使用`-a`选项显示本地分支和远程分支

```
git branch -a
```

注意：在尚未进行一次本地提交时，是不存在本地分支的。

### 分支切换（checkout）

`git checkout`可以切换分支，就是将 HEAD 指向另一个分支

```
git checkout branch_name
```

`-b`可以在切换时直接新建分支，如果分支已经存在，则操作失败，`-B`选项则会新建分支，如果已存在直接重置分支

```
git checkout -b branch_name
git checkout -B branch_name
```

`A->B`的分支切换具体内容是：

- 首先 HEAD 从`A`指向另一个分支`B`
- 然后基于分支指向的提交信息，**尝试**用`B`初始化 index 和工作目录
- **尝试**将`A`目前的未提交修改（包括在 index 的修改和在工作目录的修改），在新的 index 和工作目录中重演
- 检查是否可以无冲突地重演这些修改，如果可以则切换；否则可能造成数据损失，拒绝切换
- 换言之：切换前的 index 和工作目录并不要求是干净的，切换后的 index 和工作目录也不一定是干净的，成功的切换会保留这些可重演的修改

注意这里的切换和`git reset --hard`相比是安全无冲突的，**分支切换不会造成任何数据丢失**（除非加上强制进行切换的参数选项）：

- 切换会保证：未提交的更改都可以在`A->B->A`再次切换回来之后完全恢复，不会存在负面效果（按照我的理解）
- 对于暂存在 index 中或者仍然在工作目录中的修改，如果可以视作对切换之后状态的修改（类似于 rebase 的重演），那么仍然会保留，否则拒绝切换，几个例子：
  - 例如切换前后都有 a 文件，当前对 a 文件有未提交修改，切换后可以重演这里的修改行为，可以正常切换
  - 例如切换前有 a 文件，但是切换的目的地没有 a 文件，如果存在对 a 文件的未提交修改（无论是否暂存到 index），切换后无法重演这里的修改行为，那么切换会被拒绝
  - 例如切换前后都没有 a 文件，新建 a 文件（无论是否暂存到 index），可以正常切换

即便切换是数据安全的，但是还是建议在切换前后保持 index 和工作目录是干净的。

### 分支切换（switch）

`git switch`也可以切换分支，相当于把`git checkout`的一部分功能专门拆分出来了，例如

```
git switch branch_name
```

`-c`可以在切换时直接新建分支，如果分支已经存在，则操作失败，`-C`选项则会新建分支，如果已存在直接重置分支

```
git switch -c branch_name
git switch -C branch_name
```

这里的参数和`git checkout`略有不同，但是具体行为逻辑（对于 HEAD，index 和工作目录）是一样的。

### 分支合并

两个分支可以合并，将两条开发线的修改合并，假设 HEAD 指向的当前分支 main 指向结点 A，被合并的分支 test 指向结点 B，那么分支合并至少有以下几类情形：

1. 如果`A <- ... <- B`，那么就会执行**快进合并**，将 main 直接前移到 test，也指向 B
2. 如果`B <- ... <- A`，那么无事发生（视作 test 已经被 main 合并过了）
3. 其他情形下，需要考虑 A 和 B 的最早公共祖先为 C 结点，进行三分合并，此时以 C 为基准，如果只有一方修改了，那么接收这个修改，如果两方都进行了修改，视作冲突无法取舍
   1. 如果没有冲突，将会自动生成一个新结点 D，D 有两个父节点 A 和 B，分支 main 前移指向新的结点 D
   2. 如果存在冲突，那么就会进入冲突处理的特殊状态，冲突文件的状态为`unmerged`，可能因为两个分支都对它进行了修改（相比于公共祖先 C），需要手动修改这些冲突文件并清理标记，重新执行`git add`，此时 git 认为冲突处理完成，再执行`git commit`，然后和无冲突时一样生成新的提交结点

分支合并的命令如下

```
git checkout main
git merge test
```

这会将 test 分支合并到当前的 main 分支，如果可以快进合并就不会生成新的提交结点，否则生成新的提交结点并将 main 前移，而 test 不会移动。

如果在分支合并过程中发现了问题，可以取消这次合并，回到 merge 之前的状态

```
git merge --abort
```

我们可以直接筛选出相对于当前分支，已经合并过来的分支，或尚未合并过来的分支

```
git branch --merged
git branch --no-merged
```

### 分支变基

分支变基是相对于分支合并的另一种处理方式，由于分支的产生和分支合并会导致整个链表结构非常复杂，而分支变基则会以另一种简单近似线性的方法维护整个链表，同时也可以将两条开发线上的修改合并。

仍然考虑三分合并的例子，假设 HEAD 指向的当前分支 main 指向结点 A，被合并的分支 test 指向结点 B，A 和 B 的最早公共祖先为 C 结点，将 test 变基到 main，就是将从 C 到 B 的历次修改在 A 的基础上重演一遍，得到一系列新的提交结点，最终结点为 B'（test 指针也相应移动到 B'）

与合并不同，我们切换到 test 分支上进行变基操作

```
git checkout test
git rebase main
```

此时 main 还停留在原地，而 test 指向最前方的变基结果，还需要进行一个快进合并将 main 前移

```
git checkout main
git merge test
```

变基过程中同样也会出现冲突问题，解决方法为

1. 修改冲突文件
2. `git add`重新添加
3. `git merge --continue`继续变基

注意：

- 分支合并和变基最终结点的结果都是一样的，只不过链表和提交历史不一样了
- 如果一直采用变基而不是合并，那么在版本链表所有的分支都会指向一条主线的各个结点
- 变基后，原本 C 到 B 的那些结点不会被删除，但是通过正常方法无法访问，需要特殊的技巧

### 标签

标签包括两类：

1. 第一类是**轻量标签**，它实质上相当于一个不可变的分支，指向某一个 commit 对象。创建轻量标签

```
git tag v1.4-lw
```

2. 第二类是**附注标签**，它实质上一个独立的 tag 对象，它需要自带 message，指向某一个 commit 对象，或者其他对象。创建附注标签，需要`-a`选项，可以使用`-m`附带 message，否则 git 会启动编辑器

```
git tag -a v1.4 -m "version 1.4"
```

打标签在缺省时自动针对最近的一次提交，当然也可以使用哈希值指定历史上的任意一次提交

```
git tag v0.0 907e
```

查看所有标签，支持通配符筛选，不区分两类标签

```
git tag

git tag -l "v1.8.5*"
```

查看标签的实质

```
git show v1.0
```

对于轻量标签，会展示指向的 commit 对象信息；对于附注标签则会展示标签对象自身的信息，包括附加的 message

删除标签

```
git tag -d v1.0-lw
```

注：

- 附注标签会向数据库中添加一个对象，而轻量标签不会
- 虽然两类标签本质上不同，但是主要的针对标签的操作并不会区分它们；
- `git log`通常也可以查看到标签信息
- 标签操作都是在本地仓库的，在远程推送时并不会附带标签信息，需要额外的处理

```
# 推送单个标签的添加
git push origin v1.0

# 推送所有标签的添加
git push origin --tags

# 推送单个标签的删除
git push origin --delete v1.0
```

## Git 撤销原理

撤销操作在某些情形下是危险的，这指的不是 git 数据库中的内容丢失（这几乎很难办到），而是最新的修改可能丢失：

- 如果修改被正式提交了，那么即使回滚了版本，也可以通过哈希值或历史记录来恢复
- 如果使用`git add`添加到 index，那么即使撤回了，也可以通过哈希值或历史记录来恢复
- 如果修改没有添加到 index，那么这些本地修改确实有可能直接被 git 的某个切换操作或撤销操作覆盖，导致修改的丢失

### reset

`git reset`是一个非常重要的重置操作，包括三个级别：`--soft`，`--mixed`和`--hard`，其中`--hard`是最危险的，默认使用`--mixed`。

假设我们希望将`HEAD`指向的分支（例如 main）回滚到它指向的提交结点的父结点（记作`HEAD^`），那么可以进行三个级别的操作。（这里也可以回滚到其他的提交对象或分支上）

- `--soft` 最安全的重置（不影响 index 和工作目录，只是 HEAD 指向分支的移动）
  ```
  git reset --soft HEAD^
  ```
- `--mixed` 默认的重置（刷新 index，但是不影响工作目录）
  ```
  git reset HEAD^
  git reset --mixed HEAD^
  ```
- `--hard` 最危险的重置（刷新 index 和工作目录）
  ```
  git reset --hard HEAD^
  ```

实际行为具体如下：

- 将 HEAD 指向的分支移动指向上一个提交结点（`--soft`到此为止）
- 使用此提交的内容刷新 index（`--mixed`到此为止）
- 使用 index 的内容刷新工作目录（这会导致当前工作目录的最新更改丢失）（`--hard`到此为止）

通常`git reset`会对分支进行移动，附带用 HEAD 指向的提交快照对 index 进行刷新，但是我们也可以只利用它进行刷新操作：利用`--mixed`选项，使用 HEAD 指向的提交快照来刷新 index，这相当于撤销了所有的`git add`操作

```
git reset HEAD
```

除此之外，还可以指定对部分内容进行重置，例如重置单个文件，此时 HEAD 和分支都不会移动，可以用指定的提交版本（例如`HEAD^`）的快照刷新 index 中的对应文件，但是不影响工作目录的内容，也不允许指定模式（相当于`--mixed`）

```
git reset HEAD^ filename
git reset HEAD filename
```

### restore

除了`git reset`，还有一套功能略有重复的车系命令`git restore`，这个撤销命令默认不是全局的，必须指定具体的文件。虽然 git 会自动提示调用`git restore`，但是官网文档上显示这个命令是实验性的，因此命令的具体效果和参数可能发生变化，需要足够新的版本（大于 2.23 版本）

`git restore`命令与`git reset`最大的不同是，它永远不会将 HEAD 指向的分支移动到别的提交结点上，它只能基于当前提交结点或者某个特定提交结点或 index，用来刷新 index 或者工作目录。

关于刷新的参考源头：

- 在不使用`--staged`选项时，基于 index
- 在使用`--staged`选项时，基于当前 HEAD 指向的提交结点（因为这个选项意味着 index 也要被刷新）

还可以使用`--source=...`指定其他版本。

关于刷新的目的地通常包括 index 和工作目录：

- 默认情形只刷新工作目录，相当于使用`--worktree`（`-w`）
- 如果使用`--staged`（`-s`）选项，只刷新 index
- 如果使用`--staged`和`--worktree`，则刷新 index 和工作目录

除了指定刷新的源和目的地，还必须限制作用到具体文件上，而不是全部，例如下面的命令用 HEAD 刷新 index 的指定文件，相当于撤回了`git add`

```
git restore --staged filename
```

### checkout

除了上面最主要的两类撤销命令，还有一些命令也可以达到撤销的效果，例如`git checkout`。

如果`git checkout`没有加上分支名称，会被视为一种撤销操作，HEAD 不发生变化，但是可能将 index 和工作目录回撤到 HEAD 指向的状态。

对单个文件，撤销工作目录的修改，用 index 刷新工作目录的这个文件

```
git checkout -- filename
```

如果指定 HEAD，则会用 HEAD 的状态刷新 index 的这个文件，再用 index 刷新工作目录的这个文件

```
git checkout HEAD -- filename
```

注：`--`在 git 中通常用于区分选项和参数的消歧义，在其后的项不会被理解为参数，这里如果缺少`--`，filename 会被理解为分支名称

## Git 撤销操作

前文提供了很多种撤销相关的命令，其中值得注意的是`checkout`，它是经典版本中的一个非常重要的指令，但是它过于复杂，包含了太多相互无关的功能（分支切换，撤销操作），因此新版本中尝试将`git checkout`的功能拆分，引入了两个新命令：

- `git switch`专门负责分支切换
- `git restore`专门负责撤销

建议在能用`git switch`和`git restore`时优先使用它，遵从 git 提供的建议。

### 部分撤销（工作目录）

希望基于 index 的版本内容，部分刷新工作目录，舍弃工作目录当前的部分修改，可以有如下几种实现

1. （建议）基于`git restore`实现
   ```
   git restore filename
   ```
2. 基于`git checkout`当前分支实现，必须加上`--`，这个操作是老版本的建议，新版本建议是使用`git restore`。
   ```
   git checkout -- filename
   ```

### 部分撤销（index）

1. （建议）基于`git restore`实现，这里的`--staged`是必要的
   ```
   git restore --staged filename
   ```
2. 基于`git reset HEAD`实现
   ```
   git reset HEAD filename
   git reset filename
   ```

### 部分撤销（工作目录和 index）

1. （建议）基于`git restore`实现，这里的`--staged`和`--worktree`是必要的
   ```
   git restore --staged --worktree filename
   ```
2. 基于`git checkout`实现
   ```
   git checkout HEAD -- filename
   ```

### 整体撤销（工作目录）

`git restore`默认基于 index 刷新工作目录，但是需要加范围或文件名，可以使用`.`代表所有文件

```
git restore .
```

### 整体撤销（index）

1. `git reset`不添加文件名，撤销整个 index 的修改，默认是`--mixed`级别，默认基于 HEAD 进行刷新
   ```
   git reset --mixed HEAD
   git reset HEAD
   git reset
   ```
2. `git restore`需要加范围，加额外选项才能刷新 index
   ```
   git restore --staged .
   ```

### 整体撤销（工作目录和 index）

1. `git reset`在`--hard`级别可以对工作目录和 index 的刷新

   ```
   git reset --hard HEAD
   ```

2. `git restore`需要加范围，加额外选项才能刷新 index 和工作目录
   ```
   git restore --staged --worktree .
   ```

### 修正 commit

在进行了一次正式提交之后，如果发现某些内容遗漏，或者提交的 message 需要修改，可以使用`--amend`对上一次提交进行修正

```
git commit -m "last commit"
git add something_forgitten
git commit --amend
```

再次生成的提交会完全替换上一次的提交，上一次的提交不会出现在日志中。

注意：这个操作只建议在本地进行，如果已经推送到了远程仓库，那么重新添加一个提交更合适，否则会出现合并冲突。

### 回退 commit

`git commit`会生成新的提交对象，并移动 HEAD 和分支到最新的提交上，可以通过 Reset 实现撤销提交，回到上一次的提交状态

```
git reset --soft HEAD^
```

这里只是对 HEAD 和分支的移动，并没有用`HEAD^`的内容刷新 index 和工作目录。此时重新提交，或者对 index 进行处理后再提交，就达到了`git commit --amend`的效果。

## Git 底层原理

在`.git/`文件夹内部，包括一些基本的配置文件和一个基于哈希值的简易数据库`.git/object/`，以及关于配置文件的部分：

- `.git/config` 仓库级的 git 配置文件
- `.git/hooks/` 存储一些 Git 提供的钩子脚本，在特定行为的前后，对应的钩子会被自动调用
- `.git/logs/`和`.git/info/`，顾名思义是一些日志和辅助信息

还有几个在下文重点介绍。

### 数据存储原理

关于 git 内部的数据库`.git/object/`，有如下要点：

- git 对文件的保存都是基于单个文件的完整快照，而不是基于差异（这也导致 git 不适合大文件的版本控制），每一个文件快照在`git add`之后（而不是提交时）都会压缩和生成哈希值，然后以哈希值为索引存储到数据库之中，这种数据项称为 blob 对象
- git 的数据库中除了基本的 blob 对象（对应一个文件快照），还有体现目录结构的 tree 对象，以及代表一次提交的 commit 对象等，所有的项都以哈希值作为在数据库的索引，并且哈希值的前两个作为文件夹名称，剩下的作为实际的文件名，查找时不需要提供完整的哈希值，通常前六个数据就足够了
- git 的数据库除了这些原始的零散文件，还会不定期地进行自动的整理（在推送到远程时必然会先整理数据库），此时这些对象会被打包收集到`.git/object/pack/`中，一些打包信息在`.git/object/info/`，打包是数据库内部的优化行为，对外部没有影响
- git 可能因为某些撤销操作，产生悬挂对象（没有任何对象指向它），包括对`git add`的撤销，或者对正式提交后的回滚等，git 并不会自动删除这些悬挂对象，即使手动清理也不会删除它们。可以使用如下命令查询所有的悬挂对象
  ```
  git fsck --full
  ```

### index原理

Git 的一个核心概念是 index（缓冲区，暂存区），它在逻辑上位于工作目录和 git 版本控制之间，index 的实现是通过内部文件`.git/index`，它是二进制格式的文件，不可读。

index 可以被视作一个列表，列表里的每一条目包括：权限+哈希值+名称，可以通过`git ls-files --stage`命令查看，结果大致形如

```
100644 0c3acb5db2e121d819f1af9c0b97b8baaa12021b 0       a.txt
100644 1f482482efa7cc35d1dbab733e23a10c97a9364f 0       b.txt
100644 c830ea98d189c62bb530f061e2467e52da775b33 0       c/d.txt
```

查看到的结果可能是一个很大的列表，包括了所有的被 git 追踪的项，它们的最新快照的哈希值。这个命令显示最终每一层目录下的所有文件，但仍然可以理解为 index 中存在树结构。

index 是下一次提交时用于生成顶层 tree 对象的草稿（提交生成 commit 对象指向顶层的 tree 对象），但注意它记录的内容并不是当前相比于前一次 commit 的变化量，即使刚刚提交后`git status`显示完全干净时，index 也不是空的！它的列表仍然记录所有的项
。

在每一次执行`git add`之后，对应的快照会立刻存储到数据库中，生成相应的 blob 对象（必要时生成 tree 对象），然后更新 index：

- 对于新添加的文件，index 增加一个条目
- 对于修改的文件，index 修改哈希值为最新版本的
- 对于删除的文件，index 移除对应的条目

### 提交原理

使用`git commit`操作会基于 index 的内容生成本次提交所对应的顶层 tree 对象和 commit 对象，commit 对象会指向顶层 tree 对象。所有的 commit 对象会组成一个**版本链表**，这是 git 版本控制的核心数据结构。版本链表包括一个特殊的第一次提交的 commit，其他的 commit 对象都包括至少一个父对象（如果执行了 merge 操作则可能有两个父对象，但是它们不等价，执行 merge 时所在的 commit 对象是第一个父对象）

可以使用`git cat-file -p`加上哈希值来查看具体对象的内容（`-t`选项查看对象的类型），例如查看 commit 对象，得到的输出为

```
tree 0e9f335d73965f44ea4772ce4126ab219de247fd
parent a8ff675067ba137b5e833dc9cf3e2d2c8b3fcc11
author xxx <xxx@xx.com> 1699513896 +0800
committer xxx <xxx@xx.com> 1699513896 +0800

<message>
```

这表明 commit 对象除了记录提交的信息（时间，作者/提交者，提交 message），还记录了顶层的 tree 对象，以及版本链表中的 commit 父对象，这就是一次提交的全部：

- index 的作用就是下一次提交的顶层 tree 对象的草稿
- 下一次提交的其他信息（时间，作者/提交者）会自动生成
- 提交所需要的 message 需要手动输入

如果查看 commit 指向的顶层 tree 对象，就可以得到对应的提交版本中每一个项的快照的哈希值

```
100644 blob fd1240c913208228cc9e9f22d870da226ffc9b46    .gitattributes
100644 blob 1c83080acf461c2c9a4f7352fb6fbeb64347355c    .gitignore
100644 blob c4f6483460f1febf62ecbf25061f4bf3a8d022d8    .proxy
100644 blob d41cb88be2e0d0526e6c4afb41194ec841847073    README.md
040000 tree 148e0955c5cdb5fc31d7277e834147a13bc5ab09    backup
...
```

### 分支原理

分支和标签功能的内部实现以文件形式存储在`.git/refs/heads/`和`.git/refs/tags/`中，它们在逻辑上是指向版本链表的某个 commit 对象的指针，区别在于标签不可移动而分支可以，并且分支会随着提交（链表的延伸）自动前移到最新的 commit 对象。

例如在`.git/refs/heads/`通常有一个名为 main 的文件，代表主分支，它的内容只有一行，记录当前 main 分支指向的 commit 对象的哈希值，例如

```
5a0ca82eb0072623067f1d7dbd734354d72f9441
```

HEAD 是一个通常指向 branch 的指针（也可以直接指向标签，commit 对象或者其他，但这种游离的情况比较特殊且危险），HEAD 代表当前处于的位置，HEAD 在底层实现就是`.git/HEAD`，这个文本文件只有一行，记录的就是 HEAD 指向的 branch 的名称，例如

```
ref: refs/heads/main
```

执行 commit 操作后，会生成一个新的 commit 对象指向当前的 commit 对象，而 HEAD 指向的 branch（例如 main）则会前移到新的 commit 对象上。如果 HEAD 指向的不是一个 branch，例如指向一个标签，此时提交后并不会自动前移到新的 commit 对象，需要额外的特殊处理。

分支的合并和变基都是针对版本链表进行的操作，可以通过`git log --graph --all`进行检查。
