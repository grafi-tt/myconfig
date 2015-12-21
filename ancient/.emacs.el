; General Settings
;; load path
(setq load-path (cons "~/.emacs.d/site-lisp" load-path))
(setq load-path (cons "~/.emacs.d/auto-install" load-path))

;; use viper-mode
;;; level 3 (in ~/.viper)
(setq viper-mode 't)
(require 'viper)
(define-key viper-vi-global-user-map [?g?g] 'beginning-of-buffer)
(define-key viper-vi-global-user-map [?u] 'undo)

;; Various Settings
;;; confirm on exit emacs
(setq confirm-kill-emacs 'y-or-n-p)

;;; do not make backup files
(setq make-backup-files nil)

(setq auto-save-list-file-prefix "~/.emacs-autosave/.saves-")

;;; display line number
(require 'linum)

;; auto-complete.el
;;;(require 'auto-complete-config)
;;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/ac-dict")
;;;(ac-config-default)

;; tc2
(require 'tc-setup)

;; auto-install.el
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)  

;; anything.el
(require 'anything-startup)

; Applications
;; twittering-mode
(require 'twittering-mode)
(setq twittering-username "grafi_tt")
(setq twittering-auth-method 'xauth)
(setq twittering-initial-timeline-spec-string
  '(":home" ":mentions"))
(setq twittering-retweet-format "QT: @%s %t")
(defun twittering-mode-hook-func ()
  (twittering-icon-mode t)
  (set-face-bold-p 'twittering-username-face t)
  (set-face-foreground 'twittering-username-face "DeepSkyBlue3")
  (set-face-foreground 'twittering-uri-face "gray35")
  (define-key twittering-mode-map (kbd "<") 'beginning-of-buffer)
  (define-key twittering-mode-map (kbd ">") 'end-of-buffer)
  (define-key twittering-mode-map (kbd "F") 'twittering-favorite)
  (define-key twittering-mode-map (kbd "R") 'twittering-native-retweet)
  (define-key twittering-mode-map (kbd "Q") 'twittering-organic-retweet))

(add-hook 'twittering-mode-hook 'twittering-mode-hook-func)


;; Programming modes
;;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
            (inf-ruby-keys)))

;;; scheme
