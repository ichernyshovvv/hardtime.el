$(guile (load "make.scm"))
emacs26:
	$(guile (test-on-emacs "26.3"))
emacs27:
	$(guile (test-on-emacs "27.2"))
emacs28:
	$(guile (test-on-emacs "28.2"))
emacs29:
	$(guile (test-on-emacs "29.4"))
