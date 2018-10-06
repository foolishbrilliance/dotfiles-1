;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 18))
(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
;; set default regex builder for all commands
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

;; Keybindings
;; examples at https://github.com/hlissner/doom-emacs/blob/master/modules/private/default/%2Bbindings.el

(map!
 :gnvime [A-backspace] #'backward-kill-word
 )
(map!
 (:leader
   :nv [tab] nil
   :desc "Last buffer"    :n "TAB" #'evil-switch-to-windows-last-buffer
   (:desc "toggle" :prefix "t"
          :desc "Truncate lines"           :n "t" #'toggle-truncate-lines)
   ))
