" Ensure it's not loaded already
if exists('g:MinLoaded') || &cp
  finish
end
:let g:MinLoaded = 1

" :OpenMin <category> [date]
function! s:OpenMin(cat, ...)

    " Get date, default to today
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
    execute "edit ~/notes/" . cat . "/" . converted_date . ".md"

endfunction
command! -nargs=+ OpenMin call <SID>OpenMin(<f-args>)


" TODO: functions
" list follow-up: [category]
" open ref: <title>
" list min: <category>
" list ref
