hi Zebra ctermbg=green guibg=green
function! Zebra()
  exe "match Zebra /" . join(map(filter(range(line('w0'),line('w$')), 'v:val % 2'), '"\\%".v:val."l"'), '\|') . "/"
endfunction

augroup Zebra
  au!
  au CursorMoved * call Zebra()
augroup END
