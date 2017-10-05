" Ensure it's not loaded already
if exists('g:MinLoaded') || &cp
  finish
end
" Leaving off while debug
" :let g:MinLoaded = 1

" Requirements
" `date` in path
" vim compiled w/ dialog support (for confirm dialog)

" TODO: functions
" grep notes
" list follow-up: [category]
" list min: <category>
" list ref

function! s:GetNotesDir() abort
    
    " TODO: configurable path, not ~/notes
    let notes_dir = $HOME . "/notes"

    " Create if it doesn't exist
    if !isdirectory(notes_dir)
	let choice = confirm(notes_dir . ": Doesn't exist, create it?", "&Yes\n&No", 2)
	if choice == 1
	    call mkdir(notes_dir, "p")
	else
	    return ""
	endif
    endif

    return notes_dir

endfunction

function! s:GetExt() abort
    
    " TODO: Configurable extension
    return ".md"

endfunction

" :OpenMin <category> [date]
function! s:OpenMin(cat, ...) abort

    " Params
    let date = (a:0 >= 1) ? a:1 : "today"
    let cat = a:cat

    " Config
    let ext = <SID>GetExt()
    let notes_dir = <SID>GetNotesDir()
    if notes_dir == ""
	return
    endif

    " Convert date
    let converted_date = substitute(system("date -d '" . date . "' +%Y-%m-%d"), '[\r\n]\+$', '', '')
    if v:shell_error 
	echoerr "Invalid date (see `man date`)"
	return
    endif

    " TODO: check if cat exists or not, confirm
    execute "edit " . notes_dir . "/mins/" . cat . "/" . converted_date . ext

endfunction

" :OpenRef <title> 
function! s:OpenRef(title)

    " Params
    let title = a:title

    " Config
    let ext = <SID>GetExt()
    let notes_dir = <SID>GetNotesDir()
    if notes_dir == ""
	return
    endif

    " Open ref file
    execute "edit " . notes_dir . "/refs/" . title . ext

endfunction

function! s:ListFU()
    
    " Get directory
    let notes_dir = <SID>GetNotesDir()
    if notes_dir == ""
	return
    endif

    execute "silent vimgrep! /#FU/j " . notes_dir . "\**"
    execute "copen"

endfunction



" Commands
command! -nargs=+ OpenMin call <SID>OpenMin(<f-args>)
command! -nargs=1 OpenRef call <SID>OpenRef(<f-args>)
command! -nargs=0 ListFU call <SID>ListFU()

