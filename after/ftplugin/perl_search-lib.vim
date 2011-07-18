" Vim filetype plugin file 
" Language: perl
" Maintainer: Tianon
" License: GNU GPL

if exists('b:did_ftplugin_search_lib') | finish | endif
let b:did_ftplugin_search_lib = 1

if !exists('perl_search_lib_maxSearchLines') " allow this to be overridden in .vimrc or elsewhere
	let perl_search_lib_maxSearchLines = 100 " stop at this many lines, for speed's sake
endif

if executable('perl')
	let s:saveCursor = getpos('.')
	try
		let s:maxPos = 0
		let b:perlPathCode = "use constant CURRENT_FILE => '" . expand('%:p') . "';"
		while 1
			call cursor(s:maxPos == 0 ? 1 : s:maxPos, 1)
			
			let s:pos = search('^use\s\+\(lib\|File::Basename\|Cwd\)\s\+[^;]\+;$', 'n', s:maxSearchLines)
			if (s:pos <= s:maxPos)
				break
			endif
			
			let b:perlPathCode .= ' ' . getline(s:pos)
			
			let s:maxPos = s:pos
		endwhile
		if (s:maxPos > 0)
			let b:perlPathCode .= " print join(',', @INC);"
			let b:perlPathCode = substitute(b:perlPathCode, '__FILE__', 'CURRENT_FILE', 'g')
			let b:perlPath = system('perl -e ' . shellescape(b:perlPathCode))
			let b:perlPath = substitute(b:perlPath, ',.$', ',,', '')
			let &l:path = b:perlPath " the path we've just found includes and beats the pants off the global 'perlpath' found in perl.vim (since it's file-specific)
		endif
	catch /E145:/
	endtry
	call setpos('.', s:saveCursor)
endif
