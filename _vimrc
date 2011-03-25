"Basics{
syntax on                               "设置高亮
set helplang=cn                         "设置帮助文件为中文
set nocompatible                        "设置模式为不兼容VI,(nocp)
set nobackup
set noswapfile
set nowb
set fileencodings=ucs-bom,utf-8,cp936
set wrap								"设置自动折行

set tabstop=4                           "设置TAB缩进
set shiftwidth=4
set softtabstop=4
set expandtab

set ci                                  "cindent
set ai									"autoindent
set si									"smartindent
set number                              "设置显示行号

set nocp
filetype plugin on
filetype indent on

"vimide的backspace设置是 start,indent,eol
set backspace=2



set autoread							"设置文件被其他程序修改时自动载入

set noerrorbells
set novisualbell

"}


"GUI Settings{
"	不显示工具栏
set guioptions-=T
"	不显示菜单栏
set guioptions-=m
"	设置字体
set guifont=Courier_New:h10:cANSI

if(has("gui_running"))
	set guifont=Consolas:h9
endif


"	设置配色类型
"colorscheme elflord
colorscheme slate
"colorscheme evening
"colorscheme murphy

"}


"Plugin Settings{
	"TList Setting
	"{
		map <F3> :silent! Tlist<CR>
		let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
		let Tlist_Use_Right_Window=0 "让窗口显示在右边，0的话就是显示在左边
		let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
		let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
		let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
		let Tlist_Process_File_Always=0 "不是一直实时更新tags，因为没有必要
		let Tlist_Inc_Winwidth=0
	"}
	
	"Omnicppcomplete Setting
	"{
		let OmniCpp_NamespaceSearch = 1
		let OmniCpp_GlobalScopeSearch = 1
		let OmniCpp_ShowAccess = 1
		let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
		let OmniCpp_MayCompleteDot = 1 " autocomplete after .
		let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
		let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
		let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
		" automatically open and close the popup menu / preview window
		au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
		set completeopt=menuone,menu,longest,preview
	"}
	

	"miniBufExplMap
	"{
		let g:miniBufExplMapWindowNavVim = 1 
		let g:miniBufExplMapWindowNavArrows = 1 
		let g:miniBufExplMapCTabSwitchBufs = 1 
		let g:miniBufExplModSelTarget = 1
	"}
"}

"Tags Settings{
	set tags+=$vim\vimfiles\tags\cpp
"}


"Keyboard Mappings{
	"
	map<C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>
	" 编译运行键绑定
	map <F5> :call CompileCode()<CR>
	imap <F5> <ESC>:call CompileCode()<CR>
	vmap <F5> <ESC>:call CompileCode()<CR>

	map <F6> :call RunResult()<CR>

	map <C-t> :NERDTree<cr>
	map <C-o> :TlistToggle<cr>
	vmap <C-c> "+y

	inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
	nnoremap <C-P> :call PhpDocSingle()<CR>
	vnoremap <C-P> :call PhpDocSingle()<CR>
"}


"Function{
func! CompileGcc()
    exec "w"
    let compilecmd="!gcc "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpicc "
    endif
    if search("glut\.h") != 0
        let compil
        
        map <C-t> :NERDTree<cr>
        map <C-o> :TlistToggle<cr>
        vmap <C-c> "+yeflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
    exec "w"
    let compilecmd="!g++ "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! CompileCode()
        exec "w"
        if &filetype == "cpp"
                exec "call CompileGpp()"
        elseif &filetype == "c"
                exec "call CompileGcc()"
        endif
endfunc

func! RunResult()
        exec "w"
        if search("mpi\.h") != 0
            exec "!mpirun -np 4 ./%<"
        elseif &filetype == "cpp"
            exec "! %<"
        elseif &filetype == "c"
            exec "! ./%<"
        elseif &filetype == "python"
            exec "call RunPython"
        elseif &filetype == "java"
            exec "!java %<"
        endif
endfunc

"}


"PHP设置
"{
    "You can obtain the completion dictionary file from:
    "  http://cvs.php.net/viewvc.cgi/phpdoc/funclist.txt
    set dictionary-=$VIM/vimfiles/autocomplete/php/phpfunclist.txt dictionary+=$VIM/vimfiles/autocomplete/php/phpfunclist.txt
    "Use the dictionary completion
    set complete-=k complete+=k

    "Auto completion using the TAB key
    "This function determines, wether we are on
    "the start of the line text(then tab indents)
    "or if we want to try auto completion
    function! InsertTabWrapper()
        let col=col('.')-1
        if !col || getline('.')[col-1] !~ '\k'
            return "\<TAB>"
        else
            return "\<C-N>"
        endif
    endfunction

    "Remap the tab key to select action with InsertTabWrapper
    inoremap <TAB> <C-R>=InsertTabWrapper()<CR>
"}
