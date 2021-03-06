" ============================================================================
" File:        zebra - Stripe your edits
" Description: Line striper to disambiguate lines
" Author:      Barry Arthur <barry dot arthur at gmail dot com>
" Website:     http://github.com/dahu/vim-zebra
"
" See zebra.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help zebra
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let s:Zebra_version = '0.0.3'

" Vimscript setup {{{1
let s:old_cpo = &cpo
set cpo&vim

if !exists('g:zebra_gap')
  let zebra_gap = 2
endif

" Highlight
try | silent hi Zebra | catch /^Vim\%((\a\+)\)\=:E411/ | hi Zebra ctermbg=green guibg=green | endtry

" Options
" Zebra globally enabled?:{{{1
if !exists('g:zebra')
  let g:zebra = 0
endif

" Private functions:{{{1
function! Zebra()
  if !exists('b:zebra')
    let b:zebra = g:zebra
  endif
  if b:zebra
    exe "match Zebra /" . join(map(filter(range(line('w0'),line('w$')), 'v:val % g:zebra_gap == 0'), '"\\%".v:val."l"'), '\|') . "/"
  else
    match Zebra //
  endif
endfunction

" Public Interface:{{{1
function! ZebraOn()
  let b:zebra = 1
  call Zebra()
endfunction

function! ZebraOff()
  let b:zebra = 0
  call Zebra()
endfunction

function! ZebraToggle(bang)
  if a:bang != '!'
    call ZebraOn()
  else
    call ZebraOff()
  endif
endfunction

" Events, Maps and Commands:{{{1
augroup Zebra
  au!
  au CursorMoved * call Zebra()
augroup END

nnoremap <Plug>ZebraOn  :call ZebraOn()<cr>
nnoremap <Plug>ZebraOff :call ZebraOff()<cr>

if !hasmapto('<Plug>ZebraOn')
  nmap <unique> <Leader>z <Plug>ZebraOn
endif

if !hasmapto('<Plug>ZebraOff')
  nmap <unique> <Leader>Z <Plug>ZebraOff
endif

command! -nargs=0 -bang Zebra call ZebraToggle('<bang>')

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:old_cpo

" vim: set sw=2 sts=2 et fdm=marker:
