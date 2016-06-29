;; http://emacswiki.org/emacs/SetFonts
;; M-x describe-font
(set-face-attribute 'default nil :family "Ubuntu Mono" :foundry "DAMA"
 :slant 'normal :weight 'normal :height 70 :width 'normal)
;; (set-face-attribute 'default nil :family "Source Code Pro" :foundry
;;  "ADBO" :slant 'normal :weight 'semi-bold :height 60 :width 'normal)
;; ;; (set-face-attribute 'default nil :family "Inconsolatazi4" :foundry
;;   "PfEd" :slant 'normal :weight 'normal :height 80 :width 'normal)

(setq show-paren-delay 0)
(show-paren-mode 1)

(blink-cursor-mode 0)

(column-number-mode 1)
(display-battery-mode 1)

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)

;; Don't open the *About GNU Emacs* buffer (C-h C-a) on startup.
(setq inhibit-startup-screen t)

;; Save the session (desktop) when Emacs exits and restore it on startup.
(desktop-save-mode 1)

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/") package-archives)
(push '("melpa" . "http://melpa.milkbox.net/packages/") package-archives)
(package-initialize)

;; Evil stuff.
(require 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq evil-want-C-u-scroll t)
(require 'evil)
(evil-mode 1)
(evil-commentary-mode 1)
(require 'evil-matchit)
(global-evil-matchit-mode 1)
(require 'evil-snipe)
(evil-snipe-mode 1)
(setq evil-snipe-repeat-keys t)
(setq evil-snipe-scope 'visible)
(setq evil-snipe-repeat-scope 'whole-visible)
(setq evil-snipe-enable-highlight t)
(setq evil-snipe-enable-incremental-highlight t)
(evil-snipe-override-mode 1)
(require 'evil-surround)
(global-evil-surround-mode 1)
(require 'linum-relative)
(add-hook 'prog-mode-hook 'linum-mode)
(require 'evil-magit)
(require 'evil-org)

(load-theme 'ujelly t)
;; (load-theme 'monokai t)
;; (load-theme 'zenburn t)

;; Make Emacs aware of Vim modelines.  I think [the package][1] isn't available on MELPA,
;; Marmalade or GNU ELPA, so I'm using a Git submodule and installing it manually.
;; [1]: https://github.com/cinsk/emacs-vim-modeline
(add-to-list 'load-path "~/.emacs.d/emacs-vim-modeline/")
(require 'vim-modeline)
(add-to-list 'find-file-hook 'vim-modeline/do)

;; https://github.com/emacs-helm/helm
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)

(global-set-key (kbd "C-x g") 'magit-status)

;; [Org-Reveal][1]: exports Org documents to [reveal.js][2] presentations.
;; [1]: https://github.com/yjwen/org-reveal
;; [2]: https://github.com/hakimel/reveal.js
(require 'ox-reveal)

;; https://github.com/slime/slime
(setq inferior-lisp-program "sbcl")
(setq slime-contribs '(slime-fancy))

(require 'powerline)
;; Don't use fancy mode line separators; saves surprisingly much space.
(setq powerline-default-separator nil)
(require 'spaceline-config)
(spaceline-spacemacs-theme)
(spaceline-helm-mode)
;; Color the mode (status) line's indicator based on the current Vim mode (different
;; colors for normal mode, insert mode, ...).
(setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
;; Disable some spaceline segments.
(setq spaceline-buffer-size-p nil)
(setq spaceline-version-control-p nil)
;; Hide some minor mode displays (lighters) from the mode line.
(require 'diminish)
(diminish 'evil-commentary-mode)
(diminish 'evil-snipe-local-mode)
(diminish 'helm-mode)
(diminish 'undo-tree-mode)

(require 'saveplace)
(setq-default save-place 1)

;; vim: tw=90 sts=-1 sw=3 et
