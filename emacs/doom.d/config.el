;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 18)
      split-width-threshold 100    ;; split windows if the window's max width <100
      )

(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
;; set default regex builder for all commands
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

;; Keybindings
;; examples at https://github.com/hlissner/doom-emacs/blob/master/modules/private/default/%2Bbindings.el

;; Global bindings
(map!
 :gnvime [A-backspace] #'backward-kill-word
 :i "A-SPC"            #'+company/complete ;; I use C-SPC for Spotlight

 ;; Leader bindings
 (:leader
   :desc "Last buffer"    :n "\\" #'evil-switch-to-windows-last-buffer

   ;; Prefix bindings
   (:desc "toggle" :prefix "t"
     :desc "Truncate lines"           :n "t" #'toggle-truncate-lines)
   ;; Custom prefix - (e)xtended
   (:desc "extended" :prefix "e"
       :nv "o" #'link-hint-open-link
       :nv "y" #'link-hint-copy-link))

 ;; evil-magit
 (:after evil-magit
   (:map (magit-status-mode-map magit-revision-mode-map)
     :n [A-tab]          #'magit-section-cycle-diffs)) ;; M-tab is used by OSX

 ;; markdown
 (:after markdown
   (:map markdown-mode-map
     (:localleader
       :nv "xc" #'markdown-insert-code
       :nv "xC" #'markdown-insert-gfm-code-block)))

 ;; magit git commit buffer
 (:after with-editor
   :map with-editor-mode-map
   (:localleader
     :desc "Finish" :n "c" #'with-editor-finish
     :desc "Cancel" :n "k" #'with-editor-cancel))
)

(after! magit
  ;; Load magit in split frame
  (setq magit-display-buffer-function 'magit-display-buffer-traditional))

(setq
 evil-escape-key-sequence ";y"
 evil-escape-unordered-key-sequence t

 ;; Org mode
 org-directory "~/WorkDocs/Notational Data"
 org-default-notes-file (concat org-directory "/notes.org")
 org-footnote-auto-adjust t ;; sort and renumber footnotes after every insert/delete
 )

;; failback notes directory
(unless (file-directory-p "~/WorkDocs/Notational Data") (setq org-directory "~/Dropbox/Notes"))
