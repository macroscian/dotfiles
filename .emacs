;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq use-package-always-ensure t)
;; Localisation
(if (string-match "thecrick" (system-name))
    (setq gpk-babshome "/camp/stp/babs/"
	  gpk-oncamp t)
  (setq gpk-babshome "I:\\"
	gpk-oncamp nil)
  )

(require 'package)
(add-to-list 'package-archives
 	     '("marmalade" .
 	       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
 	     '("MELPA" .
 	       "http://melpa.milkbox.net/packages/"))
(package-initialize)
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Prefs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b"))))
					;(load-theme `leuven)
(load-theme 'leuven t)

(if gpk-oncamp
    (set-face-attribute 'default nil :family "Liberation Mono")
  (set-face-attribute 'default nil :family "Consolas")
  )
(menu-bar-mode nil) 
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(tool-bar-mode -1); hide the toolbar
(prefer-coding-system 'utf-8)
(display-time-mode t)
;;Editing
(global-font-lock-mode t); syntax highlighting
(delete-selection-mode t); entry deletes marked text
(put 'upcase-region 'disabled nil)
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode
;;Shell
(setq shell-file-name "bash")
(setq shell-command-switch "-c")
;; Scrolling
(setq scroll-preserve-screen-position "always"
      scroll-conservatively 5
      scroll-margin 2)
(global-set-key [(control v)]  (lambda () (interactive) (scroll-up 1)))
(global-set-key [(control b)]  (lambda () (interactive) (scroll-down 1)))
(winner-mode 1)
;;Backup Prefs
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . ".~"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t       ; use versioned backups
 vc-make-backup-files t
 )
(defun force-backup-of-buffer ()
  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . ".~/per-session")))
          (kept-new-versions 3))
      (backup-buffer)))
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  (let ((buffer-backed-up nil))
    (backup-buffer)))
(add-hook 'before-save-hook  'force-backup-of-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package web-mode
  :commands web-mode
  :mode (("\\.html\\'" . web-mode)
	 ("\\.php\\'" . web-mode)
	 )
  :config
  (setq web-mode-markup-indent-offset 2)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dired+
  :config
  (diredp-toggle-find-file-reuse-dir 1)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ess-site
  :commands R
  :preface
  (defun kbw ()
    "kill"
    (interactive) (kill-buffer-and-window)
    )
  (defun replace-loop-with-first ()
    "Replace a loop with setting the variable to first possible value"
    (interactive)
    (save-excursion
      (let ((original (buffer-substring (line-beginning-position) (line-end-position)))
	    )
	(if (string-match " \*for (\\(\.\*\\) in \\(\.\*\\)) { \*" original)
	    (ess-eval-linewise (replace-match "\\1 <- (\\2)[1]" t nil original) nil nil)
	  )
	)
      )
    (ess-next-code-line 1)
    )
  (defun switch-project ()
    "Send instructions to R to clear workspace"
    (interactive)
    (ess-send-string
     (get-process "R")
     (concat "switchProject(\"" default-directory "\")")
     )
    )
  
  
  :init
  (setq ess-default-style 'RStudio)
  :config
  (bind-key "C-c C-j"  'replace-loop-with-first ess-mode-map)
  (bind-key "M-q" 'kbw ess-help-mode-map)
  (bind-key "C-c w" 'ess-execute-screen-options inferior-ess-mode-map)
  (bind-key "C-<up>" 'comint-previous-matching-input-from-input inferior-ess-mode-map)
  (bind-key "C-<down>" 'comint-next-matching-input-from-input inferior-ess-mode-map)
  (setq comint-input-ring-size 1000)
  (setq-default ess-dialect "R")
  (setq ess-eval-visibly nil)
  (setq ess-ask-for-ess-directory nil
	inferior-R-args "--no-save --no-restore")
  (use-package ess-tracebug
    :config
    (ess-tracebug t)
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package highlight-parentheses
  :config
  (show-paren-mode t)
  (setq hl-paren-colors '("#1b9e77" "#d95f02" "#7570b3" "#e7298a" "#a6761d" "#e6ab02"))
  (global-highlight-parentheses-mode t)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package bookmark
  :config
  (use-package bookmark+))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :init
  (setq gpk-project-directory (concat gpk-babshome "working/" user-login-name "/"))
  (setq gpk-project-orgfile (concat gpk-project-directory "work.org"))
  :config
  (setq org-agenda-file-regexp "\\`[^.].*\\.org\\'") ; default value
  (setq org-agenda-files (list gpk-project-orgfile))
  (setq org-default-notes-file  gpk-project-orgfile)
  (setq org-log-done 'time)
  (setq org-capture-templates
	'(("t" "Todo" plain (file org-default-notes-file)
	   "nt%?")
	  ("p" "Project" plain (file org-default-notes-file)
	   "np%?")))
  ;; (defun gpk-org-property (prop)
  ;;   (replace-regexp-in-string "[^a-z].*" "" (downcase (org-element-property prop (org-element-at-point))))
  ;;   )
  (defun gpk-org-property (prop)
;    (downcase (org-element-property prop (org-element-at-point)))
    (downcase (plist-get (nth 1 (org-element-at-point)) prop))
    )
  (defun gpk-guess-directory ()
    (interactive)
    "Open dired at best guess for where project lives"
    (let* ((lab (gpk-org-property :LAB))
	   (scientist (replace-regexp-in-string "@crick.ac.uk" "" (gpk-org-property :SCIENTIST)))
	   (project (replace-regexp-in-string "[^[:alnum:]]" "_" (gpk-org-property :PROJECT)))
	   (guess-dir (concat gpk-project-directory "projects/" lab "/" scientist "/" project))
	   )
      (if (file-exists-p guess-dir)
	  (find-file (ido-read-file-name "Find File:" guess-dir))
	(copy-directory (concat gpk-project-directory "code/R/template") guess-dir nil t)
	)
      )
    )
  (bind-key "C-c a"  'org-agenda)
  (bind-key "C-c c" 'org-capture)
  (bind-key "C-c o" 'gpk-guess-directory)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :config
  (yas-reload-all)
  :init
  (setq yas-indent-line 'fixed)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'org-mode-hook 'yas-minor-mode)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;; work patterns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if gpk-oncamp
    (setq gpk-lab-names (append
			 '("external")
			 (directory-files "/camp/lab" nil "^[a-z]")
			 (directory-files "/camp/stp" nil "^[a-z]")))
  (setq gpk-lab-names (append
		       '("external")
		       (mapcar 
			(lambda (x) (replace-regexp-in-string "lab-" "" x))
			(directory-files "\\\\data.thecrick.org" nil "^[a-z]"))
		       )
	)
  )


(dolist (r `((?p (file . ,(concat gpk-project-orgfile)))
             (?e (file . ,(concat "~/.emacs")))
             (?c "@crick.ac.uk")
	     ))
  (set-register (car r) (cadr r)))


(defun gpk-lproj ()
  (interactive)
  "Find project directories"
  (insert (shell-command-to-string
	   (concat "find " gpk-project-directory "/projects -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*' -printf '%P\n'")
	   )
	  ))

(defun gpk-guess-orgnode ()
  (interactive)
  "Filter org at best guess for where project lives"
  (let* (
	 (mypath (file-name-directory buffer-file-name))
	 (shortPath (replace-regexp-in-string gpk-project-directory "" mypath))
	 (spl (split-string shortPath "/"))
	 (lab (nth 1 spl))
	 (scientist (concat (nth 2 spl) "@crick.ac.uk"))
	 )
    (org-tags-view nil (concat "+Lab=\"" lab "\"+Scientist=\"" scientist "\""))
    )
  )



(defun gpk-git-version ()
  (interactive)
  "Put git version into kill ring"
  (kill-new (shell-command-to-string "git log -1 --pretty=format:%h")
	    ))


(setq tramp-default-mode "ssh")

(setq tramp-remote-process-environment ())
(add-to-list 'tramp-remote-process-environment
	     (format "DISPLAY=%s" (getenv "DISPLAY")))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ess-swv-pdflatex-commands (quote ("pdflatex" "texi2pdf" "make")))
 '(ess-swv-processor (quote knitr))
 '(package-selected-packages
   (quote
    (leuven-theme ess f bookmark+ dired+ highlight-parentheses undo-tree yasnippet use-package))))


					;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
					; '(default ((t (:family "Consolas" :foundry "microsoft" :slant normal :weight normal :height 105 :width normal)))))
