;;; nlinum-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (global-nlinum-mode nlinum-mode) "nlinum" "nlinum.el"
;;;;;;  (22367 48084))
;;; Generated autoloads from nlinum.el

(autoload 'nlinum-mode "nlinum" "\
Toggle display of line numbers in the left margin (Linum mode).
With a prefix argument ARG, enable Linum mode if ARG is positive,
and disable it otherwise.  If called from Lisp, enable the mode
if ARG is omitted or nil.

Linum mode is a buffer-local minor mode.

\(fn &optional ARG)" t nil)

(defvar global-nlinum-mode nil "\
Non-nil if Global-Nlinum mode is enabled.
See the command `global-nlinum-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-nlinum-mode'.")

(custom-autoload 'global-nlinum-mode "nlinum" nil)

(autoload 'global-nlinum-mode "nlinum" "\
Toggle Nlinum mode in every possible buffer.
With prefix ARG, turn Global-Nlinum mode on if and only if
ARG is positive.
Nlinum mode is enabled in all buffers where
`(lambda nil (unless (minibufferp) (nlinum-mode)))' would do it.
See `nlinum-mode' for more information on Nlinum mode.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("nlinum-pkg.el") (22367 48084 450441))

;;;***

(provide 'nlinum-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; nlinum-autoloads.el ends here
