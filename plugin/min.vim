" Ensure it's not loaded already
if exists('g:MinLoaded') || &cp
  finish
end
" Leaving off while debug
" :let g:MinLoaded = 1

" Requirements
" `date` in path


" :OpenMin <category> [date]
function! s:OpenMin(cat, ...)

    " Get params, default date to today
    let date = (a:0 >= 1) ? a:1 : "today"
    let cat = a:cat

    " Convert date
    let converted_date = substitute(system("date -d '" . date . "' +%Y-%m-%d"), '[\r\n]\+$', '', '')
    if v:shell_error 
	echoerr "Invalid date (see `man date`)"
	return
    endif

    " TODO: configurable path, not ~/notes
    " TODO: configurable ext, not .md
    " TODO: check if cat exists or not, confirm
    execute "edit ~/notes/mins" . cat . "/" . converted_date . ".md"

endfunction
command! -nargs=+ OpenMin call <SID>OpenMin(<f-args>)

" :OpenRef <title> 
function! s:OpenRef(title)

    let title = a:title

    " TODO: configurable path, not ~/notes
    " TODO: configurable ext, not .md
    execute "edit ~/notes/refs/" . title . ".md"

endfunction
command! -nargs=1 OpenRef call <SID>OpenRef(<f-args>)


" TODO: functions
" list follow-up: [category]
" list min: <category>
" list ref
