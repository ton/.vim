let g:Powerline#Segments#git#segments = Pl#Segment#Init(['git', 1,
	\
	\ Pl#Segment#Create('branch', '%{Powerline#Functions#git#GetBranch("$BRANCH")}')
\ ])
