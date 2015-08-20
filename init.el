;;;elファイルの読み込み
(add-to-list 'load-path "~/.emacs.d/")

;;;;;;;;;;;;;;;;;;;;;;;;;
;;基本設定
;;;;;;;;;;;;;;;;;;;;;;;;;
;tabをspace4つにする
(setq tab-width 4)
(setq indent-tabs-mode nil)

;auto-byte-compile
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)


;auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict/")
(ac-config-default)

;; ;auto-install
;; (add-to-list 'load-path "~/.emacs.d/auto-install")
;; (require 'auto-install)
;; (setq auto-install-directory "~/.emacs.d/auto-install")
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)  

;color-theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-lethe)))

(setq default-frame-alist
      (append (list
               '(alpha . (90 85))
               ) default-frame-alist))


;M-g goto-line
(global-set-key "\M-g" 'goto-line)

;C-h でデリート機能をつける
(global-set-key "\C-h" 'backward-delete-char)

;trrの設定
(autoload 'trr "/usr/local/share/emacs/site-lisp/trr" nil t)

;buffer移動
(windmove-default-keybindings)
(defvar windmove-wrap-around)
(setq windmove-wrap-around t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Load the library and start it up
;; (require 'rosemacs)
;; (invoke-rosemacs)

;; ;; Optional but highly recommended: add a prefix for quick access
;; ;; to the rosemacs commands
;; (global-set-key "\C-x\C-r" ros-keymap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;perl用の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defalias 'perl-mode 'cperl-mode)
(setq auto-mode-alist (cons '("\\.t$" . cperl-mode) auto-mode-alist))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;python用の設定
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load-file "~/.emacs.d/emacs-for-python/epy-init.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;php用の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;php用の設定
(add-to-list 'load-path "~/.emacs.d/php-mode-1.5.0")
(autoload 'php-mode "php-mode")
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))
(defvar php-mode-force-pear)
(setq php-mode-force-pear t)
(add-hook 'php-mode-user-hook
	  '(lambda ()
	     (setq php-manual-path "/usr/local/share/php/doc/html")
	     (setq php-manual-url "http://www.phppro.jp/phpmanual")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C/C++用の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gdbの見える化
(defvar gdb-many-windows)
(defvar gdb-use-separate-io-buffer)
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

;デバッグ用printfの挿入
(defun my-insert-printf-debug ()
  (interactive)
  (insert "printf(\"%s %s:%d\\n\", __func__, __FILE__, __LINE__);")
  (indent-according-to-mode)
)

(defvar c++-mode-map)
(add-hook 'c++-mode-hook
  (function (lambda ()
              (define-key c++-mode-map (kbd "C-c d") 'my-insert-printf-debug)
)))

;; C-c c で compile コマンドを呼び出す
(define-key mode-specific-map "c" 'compile)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;auto-insert
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'autoinsert)
;;ユーザ固有設定
(setq user-full-name "Ryo Soga")
(setq user-mail-address "coffeegg89@gmail.com")

;; テンプレートのディレクトリ
(setq auto-insert-directory "~/.emacs.d/templates/")

;; 各ファイルによってテンプレートを切り替える
(setq auto-insert-alist
      (nconc '(
               ("\\.cpp$" . ["template.cpp" my-template])
               ("\\.c$" . ["template.c" my-template])
               ("\\.h$"   . ["template.h" my-template])
               ("\\.hpp$"   . ["template.h" my-template])
	       ("\\.lisp$" . ["template.lisp" my-template])
               ("\\.tex$" . ["template.tex" my-template])
               ("\\.py$" . ["template.py" my-template])
               ("Makefile.all$" . ["Makefile.all" my-template])
               ("Makefile.target$" . ["Makefile.target" my-template])
               ) auto-insert-alist))
(require 'cl)

;; ここが腕の見せ所
(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%author%" . (lambda()(identity user-full-name)))
    ("%mail%" . (lambda()(identity user-mail-address)))
    ("%cyear%" . (lambda()(substring (current-time-string) -4)))
    ("%license%" . (lambda()(read-from-minibuffer "License: ")))
    ("%bdesc%" . (lambda()(read-from-minibuffer "Brief dscription: ")))
    ("%extension%" . (lambda()(read-from-minibuffer "File extension: ")))
    ("%compiler%" . (lambda()(read-from-minibuffer "Compiler: ")))
    ("%target%" . (lambda()(read-from-minibuffer "Project Name is: ")))
    ("%include-guard%"    . (lambda () (format "__%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))))

(defun my-template ()
  (time-stamp)
  (mapc #'(lambda(c)
        (progn
          (goto-char (point-min))
          (replace-string (car c) (funcall (cdr c)) nil)))
    template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YaTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/yatex")
;; (autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;; (setq auto-mode-alist
;;       (append '(("\\.tex$" . yatex-mode)
;;                 ("\\.ltx$" . yatex-mode)
;;                 ("\\.cls$" . yatex-mode)
;;                 ("\\.sty$" . yatex-mode)
;;                 ("\\.clo$" . yatex-mode)
;;                 ("\\.bbl$" . yatex-mode)) auto-mode-alist))
;; (defvar YaTeX-inhibit-prefix-letter)
;; (setq YaTeX-inhibit-prefix-letter nil)
;; (defvar YaTeX-kanji-code)
;; (setq YaTeX-kanji-code 4
;;       ;; Yatex-latex-message-code 'utf-8
;;       )
;; (defvar YaTeX-use-LaTeX2e)
;; (setq YaTeX-use-LaTeX2e t)
;; (defvar YaTeX-use-AMS-LaTeX)
;; (setq YaTeX-use-AMS-LaTeX t)
;; (defvar YaTeX-dvi2-command-ext-alist)
;; (setq YaTeX-dvi2-command-ext-alist
;;       '(("[agx]dvi\\|dviout" . ".dvi")
;;         ("gv" . ".ps")
;;         ("texworks\\|evince\\|okular\\|zathura\\|qpdfview\\|pdfviewer\\|mupdf\\|xpdf\\|firefox\\|acroread\\|pdfopen" . ".pdf")))
;; (defvar tex-command)
;; (setq tex-command "sh ~/.platex2pdf")
;; (setq tex-command "ptex2pdf -l -ot '-synctex=1'")
;(setq tex-command "ptex2pdf -l -u -ot '-synctex=1'")
;(setq tex-command "pdfplatex")
;(setq tex-command "pdfplatex2")
;(setq tex-command "pdfuplatex")
;(setq tex-command "pdfuplatex2")
;(setq tex-command "pdflatex -synctex=1")
;(setq tex-command "lualatex -synctex=1")
;(setq tex-command "luajitlatex -synctex=1")
;(setq tex-command "xelatex -synctex=1")
;(setq tex-command "latexmk")
;(setq tex-command "latexmk -e '$latex=q/platex -synctex=1/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq tex-command "latexmk -e '$latex=q/platex -synctex=1/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %O -z -f %S | convbkmk -g > %D/' -e '$ps2pdf=q/ps2pdf %O %S %D/' -norc -gg -pdfps")
;(setq tex-command "latexmk -e '$latex=q/uplatex -synctex=1/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq tex-command "latexmk -e '$latex=q/uplatex -synctex=1/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %O -z -f %S | convbkmk -u > %D/' -e '$ps2pdf=q/ps2pdf %O %S %D/' -norc -gg -pdfps")
;(setq tex-command "latexmk -e '$pdflatex=q/pdflatex -synctex=1/' -e '$bibtex=q/bibtex/' -e '$makeindex=q/makeindex/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/lualatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/luajitlatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/xelatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -xelatex")
(defvar bibtex-command)
(setq bibtex-command (cond ((string-match "uplatex\\|-u" tex-command) "upbibtex")
                           ((string-match "platex" tex-command) "pbibtex")
                           ((string-match "lualatex\\|luajitlatex\\|xelatex" tex-command) "bibtexu")
                           ((string-match "pdflatex\\|latex" tex-command) "bibtex")
                           (t "pbibtex")))
(defvar makeindex-command)
(setq makeindex-command (cond ((string-match "uplatex\\|-u" tex-command) "mendex")
                              ((string-match "platex" tex-command) "mendex")
                              ((string-match "lualatex\\|luajitlatex\\|xelatex" tex-command) "texindy")
                              ((string-match "pdflatex\\|latex" tex-command) "makeindex")
                              (t "mendex")))
(defvar dvi2-command)
(setq dvi2-command "evince")
;(setq dvi2-command "okular --unique")
;(setq dvi2-command "zathura -s -x \"emacsclient --no-wait +%{line} %{input}\"")
;(setq dvi2-command "qpdfview --unique")
;(setq dvi2-command "pdfviewer")
;(setq dvi2-command "texworks")
;(setq dvi2-command "firefox -new-window")
(defvar dviprint-command-format)
(setq dviprint-command-format "acroread `echo %s | sed -e \"s/\\.[^.]*$/\\.pdf/\"`")

(defun evince-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "fwdevince")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
	(defvar YaTeX-parent-file)
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat "\"" pf "\" " ln " \"" ctf "\""))
    (message (concat cmd " " args))
    (process-query-on-exit-flag
     (start-process-shell-command "fwdevince" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c e") 'evince-forward-search)))

(require 'dbus)

(defun un-urlify (fname-or-url)
  "A trivial function that replaces a prefix of file:/// with just /."
  (if (string= (substring fname-or-url 0 8) "file:///")
      (substring fname-or-url 7)
    fname-or-url))

(defun evince-inverse-search (file linecol &rest ignored)
  (let* ((fname (un-urlify file))
         (buf (find-file fname))
         (line (car linecol))
         (col (cadr linecol)))
    (if (null buf)
        (message "[Synctex]: %s is not opened..." fname)
      (switch-to-buffer buf)
      (goto-line (car linecol))
      (unless (= col -1)
        (move-to-column col)))))

(dbus-register-signal
 :session nil "/org/gnome/evince/Window/0"
 "org.gnome.evince.Window" "SyncSource"
 'evince-inverse-search)

(defun okular-forward-search ()
  (interactive)
  (let* ((ctf (buffer-file-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "okular")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
	(defvar YaTeX-parent-file)
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat "--unique \"file:" pf "#src:" ln " " ctf "\""))
    (message (concat cmd " " args))
    (process-query-on-exit-flag
     (start-process-shell-command "okular" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c o") 'okular-forward-search)))

(defun qpdfview-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "qpdfview")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat "--unique \"" pf "#src:" ctf ":" ln ":0\""))
    (message (concat cmd " " args))
    (process-kill-without-query
     (start-process-shell-command "qpdfview" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c q") 'qpdfview-forward-search)))

(defun pdfviewer-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "pdfviewer")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat "\"file:" pf "#src:" ln " " ctf "\""))
    (message (concat cmd " " args))
    (process-kill-without-query
     (start-process-shell-command "pdfviewer" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c p") 'pdfviewer-forward-search)))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (auto-fill-mode -1)))

;;
;; RefTeX with YaTeX
;;
;(add-hook 'yatex-mode-hook 'turn-on-reftex)
(add-hook 'yatex-mode-hook
          '(lambda ()
             (reftex-mode 1)
             (define-key reftex-mode-map (concat YaTeX-prefix ">") 'YaTeX-comment-region)
             (define-key reftex-mode-map (concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mark down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
     
;; ;; Rinari
;; (add-to-list 'load-path "~/.emacs.d/rinari")
;; (require 'rinari)

;; ruby-mode
(add-to-list 'load-path "~/.emacs.d/ruby-mode")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; Rake files are ruby, too, as are gemspecs, rackup files, and gemfiles.
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

;; ruby-electric.el --- electric editing commands for ruby files
;; (require 'ruby-electric)
;; (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; set ruby-mode indent
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

;; ;;; rhtml-mode
;; (add-to-list 'load-path "~/.emacs.d/rhtml")
;; (require 'rhtml-mode)
;; (add-hook 'rhtml-mode-hook
;;     (lambda () (rinari-launch)))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippets")
(let ((emacs-major-version 22))
  (unintern 'locate-dominating-file)
  (unintern 'locate-dominating-stop-dir-regexp)
  (require 'yasnippet))
;(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
;; rails-snippets
(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")


;; flymake for ruby
(require 'flymake)
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
(let* ((temp-file (flymake-init-create-temp-buffer-copy
'flymake-create-temp-inplace))
(local-file (file-relative-name
temp-file
(file-name-directory buffer-file-name))))
(list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
(add-hook
'ruby-mode-hook
'(lambda ()
;; Don't want flymake mode for ruby regions in rhtml files
(if (not (null buffer-file-name)) (flymake-mode))
;; エラー行で C-c d するとエラーの内容をミニバッファで表示する
(define-key ruby-mode-map "\C-cd" 'credmp/flymake-display-err-minibuf)))

(defun credmp/flymake-display-err-minibuf ()
"Displays the error/warning for the current line in the minibuffer"
(interactive)
(let* ((line-no (flymake-current-line-no))
(line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
(count (length line-err-info-list))
)
(while (> count 0)
(when line-err-info-list
(let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
(full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
(text (flymake-ler-text (nth (1- count) line-err-info-list)))
(line (flymake-ler-line (nth (1- count) line-err-info-list))))
(message "[%s] %s" line text)
)
)
(setq count (1- count)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; SCSS
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))

;; ;; インデント幅を2にする
;; ;; コンパイルは compass watchで行うので自動コンパイルをオフ
;; (setq exec-path (cons (expand-file-name "~/.gem/ruby/2.0/bin") exec-path))
;; (defun scss-custom ()
;;   "scss-mode-hook"
;;   (and
;;    (set (make-local-variable 'css-indent-offset) 2)
;;    (set (make-local-variable 'scss-compile-at-save) nil)
;;    )
;;   )
;; (add-hook 'scss-mode-hook
;; 	  '(lambda() (scss-custom)))


