;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! deft)
(package! link-hint)
(package! lua-mode)
(package! restore-frame-position :recipe (:fetcher github :repo "aaronjensen/restore-frame-position"))
(package! web-mode)
(load! "~/.doom.local.packages" nil t)

;;; .emacs ends here
