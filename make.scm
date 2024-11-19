(define (time-machine commit version)
  (format #t "Emacs Version: ~a" version)
  (newline)
  (system* "guix" "time-machine" "-q" (format #f "--commit=~a" commit)
           "--" "shell" "--pure" "--manifest=guix.scm"
           "--" "emacs" "-q" "--load=test.el"))
