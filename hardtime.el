;;; hardtime.el --- Prevents overuse of specified commands -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Ilya Chernyshov

;; Author: Ilya Chernyshov <ichernyshovvv@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "26.3"))
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

(defvar hardtime--count 0)
(defvar hardtime--start-time nil)
(defvar hardtime--start-point nil)

(defgroup hardtime nil
  "Customization for `hardtime'."
  :group 'hardtime
  :link '(url-link "https://github.com/ichernyshovvv/hardtime.el"))

(defun hardtime-warn ()
  "Warn about overuse of naviagation commands."
  (message "Do not overuse navigation commands"))

(defcustom hardtime-limit 3
  "The number of sequential calls of a command that is considered a limit."
  :type 'integer)

(defcustom hardtime-period 0.2
  "Period in seconds in which `hardtime' counts the number of commands calls."
  :type 'number)

(defcustom hardtime-warn #'hardtime-warn
  "Function to call when the limit is reached."
  :type 'function)

(defcustom hardtime-predicate #'hardtime-check-command
  "Predicate that decides whether to check the command to be called."
  :type 'function)

(defun hardtime-check-command ()
  "Return non-nil if the currently executed command should be checked."
  (memq this-command '( right-char left-char left-word right-word
                        forward-paragraph backward-paragraph
                        next-line previous-line)))

;;;###autoload
(define-minor-mode hardtime-mode
  "Enable `hardtime-mode'."
  :group 'hardtime-mode
  (if hardtime-mode
      (add-hook 'pre-command-hook #'hardtime-count-maybe nil t)
    (remove-hook 'pre-command-hook #'hardtime-count-maybe t)))

(defun hardtime-count-maybe ()
  "Check the currently called command."
  (when (funcall hardtime-predicate)
    (unless hardtime--start-time
      (setq hardtime--start-time (current-time)
            hardtime--start-point (point)))
    (setq hardtime--count (1+ hardtime--count))
    (if (time-less-p (time-subtract nil hardtime--start-time) hardtime-period)
        (and (> hardtime--count hardtime-limit)
             (goto-char hardtime--start-point)
             (setq hardtime--start-time (current-time))
             (funcall hardtime-warn))
      (setq hardtime--start-point nil
            hardtime--start-time nil
            hardtime--count 0))))

(provide 'hardtime)

;;; hardtime.el ends here
