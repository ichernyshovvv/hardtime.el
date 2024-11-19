# `hardtime.el`

Emacs package that prevents overuse of specified commands.

What it does:

When `hardtime-mode` is enabled, it allows you to use commands defined in
`hardtime-predicate` function only `hardtime-limit` times in `hardtime-period`
and if the limit is reached, it moves the point back and calls `hardtime-warn`
function.  All mentioned variables are customizable.  For example,
`hardtime-warn` could be set to a function that tells you to use
`avy-goto-char-timer` instead.

The common usage would be to prevent overuse of navigation commands (such as
`right-char`, `left-char`, `next-line`, `previous-line` (bound to arrow keys and
C-npbf)).  This is the default behaviour.

The name of the package is taken from [vim-hardtime](https://github.com/takac/vim-hardtime/) plugin.

## Installation and configuration

``` elisp
(use-package hardtime
  :init
  (unless (package-installed-p 'hardtime)
    (package-vc-install
     '(hardtime
       :vc-backend Git
       :url "https://github.com/ichernyshovvv/hardtime.el"
       :branch "master")))
  :hook (prog-mode . hardtime-mode))
```

### For Evil users

Configuration suitable for `evil-mode` users:

``` elisp
(use-package hardtime
  :config
  (defun evil-hardtime-check-command ()
    "Return non-nil if the currently executed command should be checked."
    (memq this-command '( next-line previous-line evil-previous-visual-line
                          right-char left-char left-word right-word
                          evil-forward-char evil-backward-char
                          evil-next-line evil-previous-line)))
  :custom
  (hardtime-predicate #'evil-hardtime-check-command)
  :hook (prog-mode . hardtime-mode))
```
