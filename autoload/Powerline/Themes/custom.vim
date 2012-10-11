let g:Powerline#Themes#custom#theme = Pl#Theme#Create(
	\ Pl#Theme#Buffer(''
		\ , 'paste_indicator'
		\ , 'mode_indicator'
		\ , 'git:branch'
		\ , 'hgrev:branch'
		\ , 'fileinfo'
		\ , Pl#Segment#Split()
		\ , 'virtualenv:statusline'
		\ , 'fileformat'
		\ , 'fileencoding'
		\ , 'filetype'
		\ , 'scrollpercent'
		\ , 'lineinfo'
	\ ),
	\
	\ Pl#Theme#Buffer('command_t'
		\ , ['static_str.name', 'Command-T']
		\ , Pl#Segment#Truncate()
		\ , Pl#Segment#Split()
		\ , ['raw.line', '%10(Match #%l%)']
	\ ),
	\
\ )
