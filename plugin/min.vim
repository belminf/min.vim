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
"

function! s:CheckAndCreateDir(dir, create_prompt) abort

    " Variables
    let dir = a:dir

    " If directory exist, just return it
    if isdirectory(dir)
	return 1
    endif

    " ASSERT: Directory doesn't exist
    
    " Prompt user for choice
    let choice = confirm(dir . ": " . a:create_prompt, "&Yes\n&No", 2)

    " If not creating dir, return
    if choice != 1
	return 0
    endif

    " Create directory and return
    call mkdir(dir, "p")
    return 1

endfunction

function! s:GetNotesDir() abort
    
    " TODO: configurable path, not ~/notes
    let notes_dir = $HOME . "/notes"

    " Create if it doesn't exist
    if !<SID>CheckAndCreateDir(notes_dir, "Doesn't exist, create it?")
	return ""
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

    " Compile and check min category dir
    let this_min_dir = notes_dir . "/mins/" . cat . "/"

    if !<SID>CheckAndCreateDir(this_min_dir, "Category doesn't exist, create it?")
	return ""
    endif

    " Open new min note
    execute "edit " . this_min_dir . converted_date . ext

endfunction

function! s:OpenLatestMins(days, ...) abort
    
    " Params
    let days = a:days
    let ext = <SID>GetExt()
    let notes_dir = <SID>GetNotesDir()

    " Go through each directory first
    for this_cat_dir in split(glob(notes_dir . '/mins/*/'), '\n')

	" Go through each day
	let days_left = days
	while days_left >= 0
	    let this_date = substitute(system("date -d '" . days_left . " days ago' +%Y-%m-%d"), '[\r\n]\+$', '', '')

	    let this_min_path = this_cat_dir . this_date . ext

	    " Open file if readable
	    if filereadable(this_min_path)
		execute "edit " . this_min_path
	    endif

	    " Decrement counter
	    let days_left -= 1

	endwhile

    endfor

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
command! -nargs=1 OpenLatestMins call <SID>OpenLatestMins(<f-args>)
command! -nargs=1 OpenRef call <SID>OpenRef(<f-args>)
command! -nargs=0 ListFU call <SID>ListFU()
