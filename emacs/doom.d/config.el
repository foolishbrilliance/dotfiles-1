;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(restore-frame-position)

;; Functions
(defun joe/avy-goto-url()
  "Use avy to go to an URL in the buffer."
  ;; Copied from http://bit.ly/2PJQoIq
  (interactive)
  (avy--generic-jump "https?://" nil 'pre))

(setq doom-font (font-spec :family "Inconsolata" :size 18)
      split-width-threshold 100 ;; split windows if the window's max width <100
      evil-escape-key-sequence ";y"
      evil-escape-unordered-key-sequence t

      ;; deft
      deft-default-extension "txt"
      deft-directory "~/Google Drive/Notational Velocity"
      deft-extensions '("md" "org" "txt")
      deft-use-filename-as-title t
      )

;; Default modes
(add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode)) ;; default mode for .txt files

;; deft
;; Overwrite `deft-current-files` for the `deft-buffer-setup` and limit it to 30 entries: https://github.com/jrblevin/deft/issues/43#issuecomment-350198825
(defun anks-deft-limiting-fn (orig-fun &rest args)
  (let
      ((deft-current-files (-take 30 deft-current-files)))
    (apply orig-fun args)))
(advice-add 'deft-buffer-setup :around #'anks-deft-limiting-fn)
;; auto refresh after clearing filter
(advice-add #'deft-filter-clear :after #'deft-refresh)

;; Org mode
(setq
  org-directory "~/Google Drive/Notational Velocity"
  org-default-notes-file (concat org-directory "/notes.org")
  org-footnote-auto-adjust t ;; sort and renumber footnotes after every insert/delete
  +workspaces-on-switch-project-behavior nil ;; make switch-project not open new workspace
 )
;; failback notes directory
(unless (file-directory-p org-directory) (setq org-directory "~/Dropbox/Notes"))

;; make projectile faster
(after! projectile
  (if (executable-find "fd") (setq projectile-generic-command "fd . -0"
                                   projectile-git-command "fd . -0")
    (if (executable-find "rg") (setq projectile-generic-command "rg --files -0 ."
                                     projectile-git-command "rg --files -0 .") nil))
  (setq projectile-switch-project-action 'projectile-find-file-dwim))

;; Ivy
(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
(add-to-list 'ivy-re-builders-alist '(counsel-describe-function . ivy--regex-ignore-order))

;; Snipe
(evil-snipe-override-mode 1)  ;; enable 1-char snipes
;; Disable 1-char snipes in magit because conflicts
(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)

;; set default regex builder for all commands
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

(after! counsel
  ;; This currently does not work
  (add-to-list 'ivy-sort-functions-alist '(counsel-recentf . file-newer-than-file-p))
  )

;; Keybindings
;; examples at https://github.com/hlissner/doom-emacs/blob/master/modules/private/default/%2Bbindings.el
(map!
 ;; Global bindings
 :gnvime [A-backspace] #'backward-kill-word
 :n "DEL" #'evil-switch-to-windows-last-buffer
 :m "\\" nil ;; by default this is evil-execute-in-emacs-state, which I never use. TODO: This doesn't work
 :i "A-SPC"            #'+company/complete ;; I use C-SPC for Spotlight com

 ;; Leader bindings
 (:leader
   :desc "Last buffer"    :n "\\" #'evil-switch-to-windows-last-buffer

   :desc "Find file in project"    :n "SPC" #'+ivy/projectile-find-file

   ;; Recursive find-file in a target directory
   :desc "Find file in directory" :n "f/" (lambda! (counsel-file-jump nil (read-directory-name "From directory: ")))
   ;; Recursive grep in target directory
   :desc "Target directory" :n "//" (lambda! (+ivy/rg nil nil (read-directory-name "From directory: ")))
   :desc "Find file in subdirectory" :n "ff"  (lambda!
                                               (let* ((proot (read-directory-name "From parent directory: "))
                                                      (pdir (expand-file-name (projectile-complete-dir proot)
                                                                              proot))
                                                      (file (projectile-completing-read
                                                             "Find file: "
                                                             (projectile-project-files pdir))))
                                                 (find-file (expand-file-name file pdir))))

   ;; Prefix bindings
   (:desc "avy" :prefix "j"
     :nv "b" #'avy-pop-mark
     :nv "j" #'evil-avy-goto-char
     :nv "J" #'evil-avy-goto-char-2
     :nv "l" #'evil-avy-goto-line
     :nv "u" #'+joe/avy-goto-url
     :nv "w" #'evil-avy-goto-word-or-subword-1)

   (:desc "toggle" :prefix "t"
     :desc "Truncate lines"           :n "t" #'toggle-truncate-lines)

   ;; Custom prefix - (e)xtended
   (:desc "extended" :prefix "e"
       :nv "o" #'link-hint-open-link
       :nv "y" #'link-hint-copy-link))

 ;; deft
 (:after deft
   (:map (deft-mode-map)
     :i "C-u"                  #'deft-filter-clear
     :i [M-backspace]          #'deft-filter-decrement-word))

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
       :nv [tab]     #'markdown-cycle
     (:localleader
       ;; Movement
       :nv "{"   #'markdown-backward-paragraph
       :nv "}"   #'markdown-forward-paragraph
       ;; Completion, and Cycling
       :nv "]"       #'markdown-complete
       :nv [tab]     #'markdown-cycle
       ;; Indentation
       :nv ">"   #'markdown-indent-region
       :nv "<"   #'markdown-outdent-region
       ;; Element removal
       :nv "k"   #'markdown-kill-thing-at-point

       ;; Do something sensible based on context
       :nv "d"   #'markdown-do

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
       :nv "lc"  #'markdown-insert-gfm-checkbox
       :nv "lt"  #'markdown-toggle-gfm-checkbox

       ;; region manipulation
       :nv "xb"  #'markdown-insert-bold
       :nv "xi"  #'markdown-insert-italic
       :nv "xc"  #'markdown-insert-code
       :nv "xC"  #'markdown-insert-gfm-code-block
       :nv "xq"  #'markdown-insert-blockquote
       :nv "xQ"  #'markdown-blockquote-region
       :nv "xp"  #'markdown-insert-pre
       :nv "xP"  #'markdown-pre-region))))

(after! magit
  ;; Load magit in split frame
  (setq magit-display-buffer-function 'magit-display-buffer-traditional))

;; Terminal-specific config
(unless (display-graphic-p)
  (progn
    (setq-hook! 'minibuffer-setup-hook truncate-lines t) ;; don't wrap in ivy results
    (setq term-suppress-hard-newline t) ;; disable newlines
    (set-display-table-slot standard-display-table 'wrap ?\b))) ;; disable wrap character

;; load local config last
(when (file-exists-p "~/.emacs.local.el") (load "~/.emacs.local.el"))
