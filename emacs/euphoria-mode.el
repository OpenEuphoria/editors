;;; euphoria-mode-el -- Major mode for editing Euphoria files

;; Author: Jeremy Cowgar <jeremy@cowgar.com>
;; Created: 26 Oct 2010
;; Keywords: Euphoria major-mode

;; Copyright (C) 2010 Jeremy Cowgar <jeremy@cowgar.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:
;;
;; This mode provides syntax highlighting for Euphoria source files
;;
;; Euphoria can be learned about at http://www.openeuphoria.org

;;; Code:
(defvar euphoria-mode-hook nil)
(defvar euphoria-mode-map
  (let ((euphoria-mode-map (make-keymap)))
    (define-key euphoria-mode-map "\C-j" 'newline-and-indent)
    (define-key euphoria-mode-map "\C-c" 'comment-region)
    (define-key euphoria-mode-map "\C-\c" 'uncomment-region)
    euphoria-mode-map)
  "Keymap for Euphoria major mode")

(add-to-list 'auto-mode-alist '("\\.e$" . euphoria-mode))
(add-to-list 'auto-mode-alist '("\\.ex$" . euphoria-mode))
(add-to-list 'auto-mode-alist '("\\.exw$" . euphoria-mode))

;; Keywords:
;;
;; (regexp-opt '("as" "and" "break" "by" "case" "constant" "continue"
;;   "do" "end" "else" "elsif" "elsedef" "elsifdef" "exit" "entry" "enum"
;;   "export" "for" "function" "global" "goto" "include" "if" "ifdef"
;;   "label" "loop" "namespace" "not" "or" "override" "procedure" "public"
;;   "return" "retry" "switch" "then" "type" "to" "until" "while" "with" "without"
;;   "xor"))
;;
;; Types:
;;
;; (regexp-opt '("object" "sequence" "integer" "atom"))
;;

(defconst euphoria-font-lock-keywords-1
  (list
   '("\\<[+-\.]?\\(0d\\)?[0-9_\\.]+\\>" . font-lock-constant-face)
   '("\\<0b[0-1_]+\\>" . font-lock-constant-face)
   '("\\<0t[0-8_]+\\>" . font-lock-constant-face)
   '("\\<0x[0-9A-Fa-f_]+\\>" . font-lock-constant-face)
   '("\\<[A-Z0-9][^ \t\n\r]*\\>" . font-lock-constant-face)
   '("\\<\\(atom\\|integer\\|object\\|sequence\\)\\>" . font-lock-type-face)
   '("\\<\\(a\\(?:nd\\|s\\)\\|b\\(?:reak\\|y\\)\\|c\\(?:ase\\|on\\(?:stant\\|tinue\\)\\)\\|do\\|e\\(?:ls\\(?:e\\(?:def\\)?\\|if\\(?:def\\)?\\)\\|n\\(?:d\\|try\\|um\\)\\|x\\(?:\\(?:i\\|por\\)t\\)\\)\\|f\\(?:or\\|unction\\)\\|g\\(?:lobal\\|oto\\)\\|i\\(?:f\\(?:def\\)?\\|nclude\\)\\|l\\(?:abel\\|oop\\)\\|n\\(?:amespace\\|ot\\)\\|o\\(?:r\\|verride\\)\\|p\\(?:rocedure\\|ublic\\)\\|ret\\(?:ry\\|urn\\)\\|switch\\|t\\(?:hen\\|o\\|ype\\)\\|until\\|w\\(?:hile\\|ith\\(?:out\\)?\\)\\|xor\\)\\>" . font-lock-builtin-face)

   )
  "Minimal highlighting for Euphoria mode.")

(defconst euphoria-imenu-generic-expression
  '(("Routine" "^\\(export\\|public\\|global\\|override\\)?[ \t]*\\(function\\|procedure\\)[ \t]+\\([a-z]+\\)" 3)
    )
  "Generic Imenu setup")

(defvar euphoria-font-lock-keywords euphoria-font-lock-keywords-1)

(defvar euphoria-mode-syntax-table nil)

(if (not euphoria-mode-syntax-table)
    (progn
      (setq euphoria-mode-syntax-table (make-syntax-table))
      ;; _ is part of a word
      (modify-syntax-entry ?_ "w" euphoria-mode-syntax-table)

      ;; define '...' strings
      (modify-syntax-entry ?\' "\""   euphoria-mode-syntax-table)

      ;; define `...` strings
      (modify-syntax-entry ?\` "\""   euphoria-mode-syntax-table)

      ;; define “/* ... */”comment style
      (modify-syntax-entry ?\/ ". 14" euphoria-mode-syntax-table)
      (modify-syntax-entry ?* ". 23" euphoria-mode-syntax-table)

      ;; define -- comment style
      (modify-syntax-entry ?\- ". 12b" euphoria-mode-syntax-table)
      (modify-syntax-entry ?\n "> b" euphoria-mode-syntax-table)
  ))

(defun euphoria-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map euphoria-mode-map)
  (set-syntax-table euphoria-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults)
       '(euphoria-font-lock-keywords))
  (make-local-variable 'comment-start)
  (setq comment-start "-- ")
  (setq imenu-generic-expression euphoria-imenu-generic-expression)
  (setq major-mode 'euphoria-mode)
  (setq mode-name "Euphoria")
  (run-hooks 'euphoria-mode-hook))

(provide 'euphoria-mode)
