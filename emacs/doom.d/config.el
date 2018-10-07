;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 18))
(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
;; set default regex builder for all commands
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

;; Keybindings
;; examples at https://github.com/hlissner/doom-emacs/blob/master/modules/private/default/%2Bbindings.el

;; Global bindings
(map!
 :gnvime [A-backspace] #'backward-kill-word
 :i "A-SPC"            #'+company/complete ;; I use C-SPC for Spotlight

 ;; evil-magit
 (:after evil-magit
   :map (magit-status-mode-map magit-revision-mode-map)
   :n [A-tab]          #'magit-section-cycle-diffs ;; M-tab is used by OSX
   ))

;; Leader bindings
(map!
 (:leader
   :desc "Last buffer"    :n "\\" #'evil-switch-to-windows-last-buffer

   ;; Prefix bindings
   (:desc "toggle" :prefix "t"
     :desc "Truncate lines"           :n "t" #'toggle-truncate-lines
   )))
