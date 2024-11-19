(use-modules (ice-9 match))
(define (test-on-emacs version)
  (let ((commit
         (match version
           ("26.3" "c05d2cfcbe")
           ("27.2" "c61746b8aa")
           ("28.2" "4c43c79e40")
           ("29.4" "48097f5119")
           (_ #f))))
    (when commit
      (system* "guix" "time-machine" "-q" (format #f "--commit=~a" commit)
               "--" "environment" "--pure" "--manifest=guix.scm"
               "--" "emacs" "-q" "--load=test.el"))))
