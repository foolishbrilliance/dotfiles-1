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

   ;; Recursive find-file in a target directory
   :n "f/" (lambda! (counsel-file-jump nil (read-directory-name "From directory: ")))
   ;; Recursive grep in target directory
   :n "//" (lambda! (+ivy/rg nil nil (read-directory-name "From directory: ")))

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

 ;; magit git commit buffer
 (:after with-editor
   :map with-editor-mode-map
   (:localleader
     :n "c" #'with-editor-finish
     :n "k" #'with-editor-cancel))

 ;; markdown
 (:after markdown-mode
   (:map markdown-mode-map
     (:localleader
       ;; Movement
       :nv "{"   #'markdown-backward-paragraph
       :nv "}"   #'markdown-forward-paragraph
       ;; Completion, and Cycling
       :nv "]"   #'markdown-complete
       ;; Indentation
       :nv ">"   #'markdown-indent-region
       :nv "<"   #'markdown-exdent-region
       ;; Element removal
       :nv "k"   #'markdown-kill-thing-at-point

       ;; Following and Jumping
       :n "N"   #'markdown-next-link
       :n "f"   #'markdown-follow-thing-at-point
       :n "P"   #'markdown-previous-link
       :n "<RET>" #'markdown-jump

       ;; Buffer-wide commands
       :nv "c]"  #'markdown-complete-buffer
       :nv "cc"  #'markdown-check-refs
       :nv "ce"  #'markdown-export
       :nv "cm"  #'markdown-other-window
       :nv "cn"  #'markdown-cleanup-list-numbers
       :nv "co"  #'markdown-open
       :nv "cp"  #'markdown-preview
       :nv "cv"  #'markdown-export-and-preview
       :nv "cw"  #'markdown-kill-ring-save

       ;; headings
       :nv "hi"  #'markdown-insert-header-dwim
       :nv "hI"  #'markdown-insert-header-setext-dwim
       :nv "h1"  #'markdown-insert-header-atx-1
       :nv "h2"  #'markdown-insert-header-atx-2
       :nv "h3"  #'markdown-insert-header-atx-3
       :nv "h4"  #'markdown-insert-header-atx-4
       :nv "h5"  #'markdown-insert-header-atx-5
       :nv "h6"  #'markdown-insert-header-atx-6
       :nv "h!"  #'markdown-insert-header-setext-1
       :nv "h@"  #'markdown-insert-header-setext-2

       ;; Insertion of common elements
       :nv "-"   #'markdown-insert-hr
       :nv "if"  #'markdown-insert-footnote
       :nv "ii"  #'markdown-insert-image
       ;;:nv "ik"  #'spacemacs/insert-keybinding-markdown
       :nv "iI"  #'markdown-insert-reference-image
       :nv "il"  #'markdown-insert-link
       :nv "iL"  #'markdown-insert-reference-link-dwim
       :nv "iw"  #'markdown-insert-wiki-link
       :nv "iu"  #'markdown-insert-uri

       ;; List editing
       :nv "li"  #'markdown-insert-list-item

       ;; region manipulation
       :nv "xb"  #'markdown-insert-bold
       :nv "xi"  #'markdown-insert-italic
       :nv "xc"  #'markdown-insert-code
       :nv "xC"  #'markdown-insert-gfm-code-block
       :nv "xq"  #'markdown-insert-blockquote
       :nv "xQ"  #'markdown-blockquote-region
       :nv "xp"  #'markdown-insert-pre
       :nv "xP"  #'markdown-pre-region
       )))
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

;; load local config last
(when (file-exists-p "~/.emacs.local.el") (load "~/.emacs.local.el"))
