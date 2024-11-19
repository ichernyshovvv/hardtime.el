;;; hardtime.el --- Prevents overuse of specified commands -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Ilya Chernyshov

;; Author: Ilya Chernyshov <ichernyshovvv@gmail.com>
;; Version: 0.1-pre
;; Package-Requires: ((emacs "28.1"))
;; Keywords: navigation, convenience
;; URL: https://github.com/ichernyshovvv/hardtime.el

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; hardtime.el is a package that prevents overuse of specified commands.

;;; Code:

(defvar ht-count 0)
(defvar ht-start-time nil)
(defvar ht-start-point nil)

(defgroup hardtime nil
  "Customization for `hardtime'."
  :group 'hardtime
  :link '(url-link "https://github.com/ichernyshovvv/hardtime.el"))

(defun ht-warn ()
  "Warn about overuse of naviagation commands."
  (message "Do not overuse navigation commands"))

(defcustom ht-limit 3
  "The number of sequential calls of a command that is considered a limit."
  :type 'integer)

(defcustom ht-period 0.2
  "Period in seconds in which `hardtime' counts the number of commands calls."
  :type 'number)

(defcustom ht-warn #'ht-warn
  "Function to call when the limit is reached."
  :type 'function)

(defcustom ht-predicate #'ht-check-command
  "Predicate that decides whether to check the command to be called."
  :type 'function)

(defun ht-check-command ()
  "Return non-nil if the currently executed command should be checked."
  (memq this-command '( right-char left-char left-word right-word
                        forward-paragraph backward-paragraph
                        next-line previous-line)))

;;;###autoload
(define-minor-mode ht-mode
  "Enable `ht-mode'."
  :group 'ht-mode :global t
  (if ht-mode
      (add-hook 'pre-command-hook #'ht-count-maybe)
    (remove-hook 'pre-command-hook #'ht-count-maybe)))

(defun ht-count-maybe ()
  "Check the currently called command."
  (when (funcall ht-predicate)
    (unless ht-start-time
      (setq ht-start-time (current-time)
            ht-start-point (point)))
    (setq ht-count (1+ ht-count))
    (if (time-less-p (time-subtract nil ht-start-time) ht-period)
        (and (> ht-count ht-limit)
             (goto-char ht-start-point)
             (setq ht-start-time (current-time))
             (funcall ht-warn))
      (setq ht-start-time nil
            ht-count 0
            ht-start-point nil))))

(provide 'hardtime)

;; Local Variables:
;;   read-symbol-shorthands: (("ht-" . "hardtime-"))
;; End:

;;; hardtime.el ends here
