;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 18))
(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
