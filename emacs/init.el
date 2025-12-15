;;; init.el --- Minimal vanilla Emacs config -*- lexical-binding: t; -*-

;;; Basic settings
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil)

;; UI
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(column-number-mode 1)
(line-number-mode 1)
(if (version< emacs-version "26")
    (global-linum-mode 1)
  (global-display-line-numbers-mode 1))
(show-paren-mode 1)

;;; Electric pair mode
(electric-pair-mode 1)
(electric-indent-mode 1)

;;; Space as leader key
(defvar my-leader-map (make-sparse-keymap)
  "Leader keymap.")

(global-set-key (kbd "M-SPC") my-leader-map)

;; File operations
(define-key my-leader-map (kbd "f f") 'find-file)
(define-key my-leader-map (kbd "f s") 'save-buffer)
(define-key my-leader-map (kbd "f r") 'recentf-open-files)

;; Buffer operations
(define-key my-leader-map (kbd "b b") 'switch-to-buffer)
(define-key my-leader-map (kbd "b k") 'kill-buffer)
(define-key my-leader-map (kbd "b l") 'list-buffers)
(define-key my-leader-map (kbd "b i") 'ibuffer)
(define-key my-leader-map (kbd "b m") 'bookmark-set)
(define-key my-leader-map (kbd "b j") 'bookmark-jump)

;; Window operations
(define-key my-leader-map (kbd "w d") 'delete-window)
(define-key my-leader-map (kbd "w s") 'split-window-below)
(define-key my-leader-map (kbd "w v") 'split-window-right)
(define-key my-leader-map (kbd "w o") 'other-window)
(define-key my-leader-map (kbd "w u") 'winner-undo)
(define-key my-leader-map (kbd "w r") 'winner-redo)
(define-key my-leader-map (kbd "w m") 'delete-other-windows)
(define-key my-leader-map (kbd "w =") 'balance-windows)

;; Dired
(define-key my-leader-map (kbd "d d") 'dired)
(define-key my-leader-map (kbd "d j") 'dired-jump)

;; Search
(define-key my-leader-map (kbd "s s") 'isearch-forward)
(define-key my-leader-map (kbd "s r") 'query-replace)
(define-key my-leader-map (kbd "s o") 'occur)

;; Compile
(define-key my-leader-map (kbd "c c") 'compile)
(define-key my-leader-map (kbd "c r") 'recompile)

;; Jump to definition/function in buffer
(define-key my-leader-map (kbd "j") 'imenu)

;; Evaluation
(define-key my-leader-map (kbd "e b") 'eval-buffer)
(define-key my-leader-map (kbd "e r") 'eval-region)

;; Help
(define-key my-leader-map (kbd "h f") 'describe-function)
(define-key my-leader-map (kbd "h v") 'describe-variable)
(define-key my-leader-map (kbd "h k") 'describe-key)

;; Misc
(define-key my-leader-map (kbd "SPC") 'execute-extended-command)
(define-key my-leader-map (kbd "/") 'comment-or-uncomment-region)

;;; Indentation
(setq-default indent-tabs-mode nil
              tab-width 4
              c-basic-offset 4
              python-indent 4)

;;; C/C++ settings
(setq c-default-style "linux"
      c-basic-offset 4)

;;; Python settings
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil
                  tab-width 4
                  python-indent 4)))

;;; Rust mode (basic)
(define-derived-mode rust-mode prog-mode "Rust"
  "Simple major mode for Rust."
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4))

(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;;; Dired enhancements
(setq dired-listing-switches "-alh"  ; human-readable sizes
      dired-dwim-target t)            ; guess target for copy/move

(add-hook 'dired-mode-hook 'dired-hide-details-mode)

;;; Ibuffer
(setq ibuffer-expert t  ; don't ask for confirmation on delete
      ibuffer-show-empty-filter-groups nil)

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)))  ; auto-refresh

;;; Window management
(winner-mode 1)  ; undo/redo window configs

;; Quick window switching
(global-set-key (kbd "M-o") 'other-window)

;;; Recent files
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;;; Compilation
(setq compilation-scroll-output t)

;;; Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

;;; Better expansion
(global-set-key (kbd "M-/") 'hippie-expand)

;;; Programming mode enhancements
(add-hook 'prog-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)
            (subword-mode 1)))  ; treat CamelCase as separate words

;;; Unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;; Mouse support in terminal
(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;;; Whitespace cleanup
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Load Dracula on startup; the ‘t’ skips the confirmation prompt (Emacs 24+)
(load-theme 'dracula t)

;;; init.el ends here
