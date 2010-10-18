" Vim filetype plugin file 
" Language: perl
" Maintainer:	Afanasov Dmitry <ender@atrus.ru>
" Last Change:	May, 17
" License:	GNU GPL

" Changelog: 
"  - ����, ��������� � use lib ����������� � perl_local_path ���������� ���
"  ������� ������ (��������� ������ �������� � b:perl_local_path)
"  - ������� ���������� ���������� perl_local_path, ����������� �������
"  include �������� ���� � vimrc
"  - ��������� �������� �������������� �������

if !exists("use_perl_search_lib_after_ftplugin")
   finish
endif

" Only do this when not done yet for this buffer
"
" ftplugin/perl.vim �������������� ��� ������ ������������ �� �����,
" ���������� �������� path ��� ������ �������� �� �����. 
"
" if exists("b:did_ftplugin_after_perl_search_lib")
"    finish
" endif
" let b:did_ftplugin_after_perl_search_lib = 1

function! s:search_lib()

        let max_pos = 0
        let pos = 0
        let ll = []
        while 1
                let pos = search("^use lib ", 'n')
                if(pos > max_pos)
                        let l = substitute(getline(pos), 'use lib\s\+', '', '')
                        let l = substitute(l, ";", '', '')

                        if match(l, '^qw') >= 0 
                                let l = substitute(l, 'qw\W\(.\+\)\W', '\1', '')
                                let ll = split(l)
                        else
                                let ll = []
                                for i in split(l, '\s*,\?\s\+')
                                        let i = substitute(i, '\s*\(q\w\?\)\?\W\(\f\+\)\W', '\2', '')

                                        let ll = add(ll, i)
                                endfor
                        endif

                        let max_pos = pos
                else
                        break
                endif
        endwhile

        return join(ll, ",")

endfunction

" ����� �� ������ � ���������� � ���� ������������ ���� ���
if !exists("b:perl_local_path")
        let b:perl_local_path = s:search_lib()

        " perl_local_path ������ ���� �� ������ �������. 
        if !exists("perl_local_path")
                let perl_local_path = b:perl_local_path
        else
                " �� ���������� ������ ����
                if len(b:perl_local_path)
                        let perl_local_path = join([b:perl_local_path, perl_local_path], ",")
                endif
        endif

endif

let &l:path = join([perl_local_path, perlpath], ",")

" vim:ts=4:et:sw=4:sts=4:enc=koi8-r
