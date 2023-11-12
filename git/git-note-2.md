# Git远程操作

> 草稿，尚未完成

## 基础操作

### 查询远程仓库

使用`git remote`可以查看当前的远程仓库名称，例如origin
```
git remote
```
加上`-v`选项查看更具体的，每一个远程仓库对应的URL
```
git remote -v
```
如果需要获取远程仓库的详细信息，可以使用如下命令
```
git remote show origin
```
它显示的信息类似于
```
* remote origin
  Fetch URL: git@xxx.git
  Push  URL: git@xxx.git
  HEAD branch: main
  Remote branch:
    main tracked
  Local branch configured for 'git pull':
    main merges with remote main
  Local ref configured for 'git push':
    main pushes to main (up to date)
```
这里还会显示`git pull`和`git push`的具体行为，如果使用`git clone`克隆得到的本地仓库，那么这就是克隆完成的默认结果，将本地的main分支和origin/main绑定。

远程仓库具有独立的HEAD，以及远程分支（名称为`<remote>/<branch>`），都保存在`.git/refs/remotes/`中，与本地的HEAD和分支不同，这些远程的对象只是可读的，本地只是记录了最近一次网络通讯时获取的远程仓库的状态，并且`git status`以及其他操作不会自动从网络获取更新信息，因此所提示的远程仓库的信息很可能是过时的，只有特殊的几个命令才会进行网络访问。


### 添加远程仓库

使用`git remote add`可以添加远程仓库
```
git remote add origin url
```
使用`git remote rename`可以对远程仓库重命名
```
git remote rename pb paul
```
使用`git remote remove`可以移除远程仓库
```
git remote remove origin
```

刚刚添加了远程仓库之后，远程仓库状态为
```
* remote origin
  Fetch URL: git@xxx.git
  Push  URL: git@xxx.git
  HEAD branch: main
  Remote branch:
    main new (next fetch will store in remotes/origin)
```
执行一次拉取`git fetch`之后，远程仓库状态变为
```
* remote origin
  Fetch URL: git@xxx.git
  Push  URL: git@xxx.git
  HEAD branch: main
  Remote branch:
    main tracked
```


### 克隆远程仓库

使用`git clone`可以克隆现有的远程仓库
```
git clone url
```

克隆之后的远程仓库的默认名称为origin，远程仓库状态为
```
* remote origin
  Fetch URL: git@xxx.git
  Push  URL: git@xxx.git
  HEAD branch: main
  Remote branch:
    main tracked
  Local branch configured for 'git pull':
    main merges with remote main
  Local ref configured for 'git push':
    main pushes to main (up to date)
```



### 拉取远程仓库

最基础的拉取远程仓库的命令是`git fetch`，它的作用是将指定的远程仓库的所有数据都下载到本地
```
git fetch origin
```
使用`--all`选项可以拉取所有远程仓库。仓库名称缺省时，如果本地的当前分支绑定了对应的远程仓库，则拉取它们，否则默认尝试拉取名为origin的远程仓库
```
git fetch
```

需要专门的选项才会拉取所有的标签
```
git fetch --tags
```

除此之外，还有`git pull`命令，它会在`git fetch`的基础上，自动尝试合并到当前分支
```
git pull
```
但是可以通过选项或者设置将`git pull`的附加行为从merge更改为rebase。


### 推送远程仓库

推送到远程仓库主要使用的命令为`git push`，需要明确三个信息：本地分支，远程仓库，以及远程分支名称
```
git push <远程仓库名称> <本地分支名称>:<远程分支名称>
```
例如
```
git push origin main:main
```


通常需要为当前分支指定一个远程仓库以及远程分支，使用`--set-upstream`或者简称`-u`
```
git push --set-upstream origin main
git push -u origin main
```
这个操作将当前的本地分支的**上游分支**设置为`origin/main`，下次再执行`git push`就会自动进行推送。


## 底层原理
