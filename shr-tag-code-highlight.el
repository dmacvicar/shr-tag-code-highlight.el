;;; shr-tag-code-highlight.el

;; Copyright (C) 2021 Duncan Mac-Vicar P.
;; Copyright (C) 2016 Andreas Jansson
;;
;; Based on example from language-detection.el
;;
;; Author: Duncan Mac-Vicar P.
;; URL: https://github.com/dmacvicar/shr-tag-code-highlight.el
;; Package-Requires: ((emacs "26.0") (language-detection "0.1.0"))
;; Keywords: html
;; Version: 1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'shr)
(require 'dom)                          ; 25.1+
(require 'language-detection)
(require 'cl-lib)

(defun shr-tag-pre-highlight (dom)
  (let ((shr-folding-mode 'none)
        (shr-current-font 'default))
    (shr-ensure-newline)
    (insert (eww-fontify-code dom))
    (shr-ensure-newline)))

(defun shr-tag-code-highlight (dom)
  (insert (eww-fontify-code dom)))

(defun eww-fontify-code (dom)
  (with-temp-buffer
    (shr-insert (dom-texts dom ""))
    ;(shr-generic dom)
    (let ((mode (eww-buffer-auto-detect-mode)))
      (when mode
        (eww-fontify-buffer mode)))
    (buffer-string)))

(defun eww-fontify-buffer (mode)
  (delay-mode-hooks (funcall mode))
  (font-lock-default-function mode)
  (font-lock-default-fontify-region (point-min)
                                    (point-max)
                                    nil))

(defun eww-buffer-auto-detect-mode ()
  (let* ((map '((ada ada-mode)
                (awk awk-mode)
                (c c-mode)
                (cpp c++-mode)
                (clojure clojure-mode lisp-mode)
                (csharp csharp-mode java-mode)
                (css css-mode)
                (dart dart-mode)
                (delphi delphi-mode)
                (emacslisp emacs-lisp-mode)
                (erlang erlang-mode)
                (fortran fortran-mode)
                (fsharp fsharp-mode)
                (go go-mode)
                (groovy groovy-mode)
                (haskell haskell-mode)
                (html html-mode)
                (java java-mode)
                (javascript javascript-mode)
                (json json-mode javascript-mode)
                (latex latex-mode)
                (lisp lisp-mode)
                (lua lua-mode)
                (matlab matlab-mode octave-mode)
                (objc objc-mode c-mode)
                (perl perl-mode)
                (php php-mode)
                (prolog prolog-mode)
                (python python-mode)
                (r r-mode)
                (ruby ruby-mode)
                (rust rust-mode)
                (scala scala-mode)
                (shell shell-script-mode)
                (smalltalk smalltalk-mode)
                (sql sql-mode)
                (swift swift-mode)
                (visualbasic visual-basic-mode)
                (xml sgml-mode)))
         (language (language-detection-string
                    (buffer-substring-no-properties (point-min) (point-max))))
         (modes (cdr (assoc language map)))
         (mode (cl-loop for mode in modes
                        when (fboundp mode)
                        return mode)))
    (message (format "%s" language))
    (when (fboundp mode)
      mode)))

(provide 'shr-tag-code-highlight)
;;; shr-tag-code-highlight.el ends here
