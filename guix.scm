(use-modules
 (guix packages)
 (guix profiles)
 ((guix licenses) #:prefix license:)
 (gnu packages)
 (gnu packages emacs)
 (gnu packages emacs-xyz)
 (guix build-system emacs))

(define-public emacs-hardtime
  (package
    (name "emacs-hardtime")
    (version "git")
    (source (local-file "hardtime.el"))
    (build-system emacs-build-system)
    (synopsis "hardtime.el")
    (description "hardtime.el")
    (home-page "https://emacs-hardtime.org")
    (license license:gpl3+)))

(packages->manifest
 (list emacs
       emacs-package-lint
       emacs-flycheck
       emacs-hardtime))
