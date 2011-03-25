"Basics{
syntax on                               "���ø���
set helplang=cn                         "���ð����ļ�Ϊ����
set nocompatible                        "����ģʽΪ������VI,(nocp)
set nobackup
set noswapfile
set nowb
set fileencodings=ucs-bom,utf-8,cp936
set wrap								"�����Զ�����

set tabstop=4                           "����TAB����
set shiftwidth=4
set softtabstop=4
set expandtab

set ci                                  "cindent
set ai									"autoindent
set si									"smartindent
set number                              "������ʾ�к�

set nocp
filetype plugin on
filetype indent on

"vimide��backspace������ start,indent,eol
set backspace=2



set autoread							"�����ļ������������޸�ʱ�Զ�����

set noerrorbells
set novisualbell

"}


"GUI Settings{
"	����ʾ������
set guioptions-=T
"	����ʾ�˵���
set guioptions-=m
"	��������
set guifont=Courier_New:h10:cANSI

if(has("gui_running"))
	set guifont=Consolas:h9
endif


"	������ɫ����
"colorscheme elflord
colorscheme slate
"colorscheme evening
"colorscheme murphy

"}


"Plugin Settings{
	"TList Setting
	"{
		map <F3> :silent! Tlist<CR>
		let Tlist_Ctags_Cmd='ctags' "��Ϊ���Ƿ��ڻ�����������Կ���ֱ��ִ��
		let Tlist_Use_Right_Window=0 "�ô�����ʾ���ұߣ�0�Ļ�������ʾ�����
		let Tlist_Show_One_File=0 "��taglist����ͬʱչʾ����ļ��ĺ����б������ֻ��1��������Ϊ1
		let Tlist_File_Fold_Auto_Close=1 "�ǵ�ǰ�ļ��������б��۵�����
		let Tlist_Exit_OnlyWindow=1 "��taglist�����һ���ָ��ʱ���Զ��Ƴ�vim
		let Tlist_Process_File_Always=0 "����һֱʵʱ����tags����Ϊû�б�Ҫ
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
	" �������м���
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


"PHP����
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
