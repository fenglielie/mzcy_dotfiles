" 显示行号，这里默认关闭
" set number
" 关闭vi兼容模式，这个实际上是默认的
set nocompatible

" 设置立刻生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 改变title
set title

"在回车时根据上一行自动决定使用tab或替换为空格
set smarttab
"显示文件中已经存在的Tab的宽度
set tabstop=4
"插入新的Tab时替换为连续空格
set expandtab
"插入新的Tab时替换的空格数
set softtabstop=4
"自动缩进的单位宽度
set shiftwidth=4
"要求自动缩进保持单位宽度的整数倍
set shiftround

"关于缩进
set autoindent
set copyindent
set preserveindent
set cindent

"关闭错误信息响铃
set noerrorbells
"关闭使用可视响铃代替呼叫
set novisualbell
"置空错误铃声的终端代码
set vb t_vb=
set t_vb=

"换行符设置，优先LF，其次CRLF
set fileformats=unix,dos
"设置编码
set encoding=utf-8
"设置文件编码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312
"设置终端编码
set termencoding=utf-8

"显示不可见字符
set list
"显示tab为三角形，显示行尾空格为点
set listchars=tab:▷\ ,trail:·

" 当文件中使用 CRLF 换行符时，显示 CRLF 换行符为 ↵
autocmd BufReadPost * if &fileformat == 'dos' | set listchars+=eol:↵ | endif
" 设置默认的换行符
set fileformats=unix,dos

"文件监视，如果文件被别的编辑器改变产生冲突，会发出提示，自动更新
set autoread

"激活所有模式下鼠标的使用（vim如果不接管，tmux就会接管)
set mouse=a
set selectmode=key

"显示状态栏(默认值为1,不显示)
set laststatus=2
"状态行显示的具体内容
set statusline=%<%F%m%r%h%w\ %=[%{&ff}][%Y][%l,%v][%p%%]

"高亮搜索
set hlsearch
"增量搜索，输入时不断进行搜索
set incsearch
"搜索忽略大小写
set ignorecase
"智能判断是否忽略大小写，如果搜索含有大写则不忽略
set smartcase


"展示当前行列数，这应该是默认开启的
set ruler
"输入的按键会在右下角显示出来
set showcmd
"展示当前的模式，这应该是默认开启的
set showmode
"括号的匹配显示以及匹配时间，默认是4个十分之一秒
set showmatch
set matchtime=2

"在处理未保存或只读文件的时候，弹出确认
set confirm

"进入插入模式时显示当前行
autocmd InsertEnter * set cursorline
"退出插入模式时关闭显示当前行
autocmd InsertLeave * set nocursorline

"保存时自动移除行尾空格
autocmd BufWritePre * %s/\s\+$//e

"对于长行禁止自动换行，不开启但保留注释
"set nowrap

"对于非utf8编码的文件在打开时提示
function! CheckFileEncodingUTF8()
    let file_encoding = &fileencoding
    if file_encoding !=# 'utf-8'
        echo "Warnning：file is encoded as " . file_encoding . ", not UTF-8."
    endif
endfunction
" 在打开文件时运行检查函数
autocmd BufReadPost * call CheckFileEncodingUTF8()

"语法高亮
syntax on

