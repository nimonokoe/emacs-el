(add-to-list 'load-path "~/.emacs.d/elisp/auto-install/")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme-6.6.0/")

;; ;; auto-install
;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

;; package
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))

;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives
;; 	     '("marmalade" . "https://maramalade-repo.org/packages/"))
;; (when (< emacs-major-version 24)
;;   ;; For important compatibility libraries like cl-lib
;;   (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; byte-compile
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)


;; color-theme
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-lethe)))


;; ido-mode
(ido-mode t)

;; ;; nlinum
;; (require 'nlinum)
;; (global-nlinum-mode t)
;; (setq nlinum-format "%5d")

;; rinari
(require 'rinari)