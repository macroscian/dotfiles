;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Prefs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b"))))
(load-theme `leuven)
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
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  :config
  (setq org-agenda-file-regexp "\\`[^.].*\\.org\\'") ; default value
  (setq org-agenda-files (list "~/projects/projects.org"))
  (setq org-default-notes-file  "~/projects/projects.org")
  (setq org-log-done 'time)
  (bind-key "C-c a"  'org-agenda)
  (bind-key "C-c c" 'org-capture)
  (bind-key "C-c o" 'gpk-guess-directory)
  :init
  (setq org-capture-templates
      '(("t" "Todo" plain (file org-default-notes-file)
             "nt%?")
        ("p" "Project" plain (file org-default-notes-file)
             "np%?")))
  ;; (let ((proj-buffer (get-buffer-window "projects.org"))
  ;; 	)
  ;;   (if 'proj-buffer (set-window-parameter proj-buffer 'no-other-window t))
  ;;   )
  ;;(set-window-parameter (get-buffer-window "projects.org") 'no-other-window t)
  ;;  (set-window-dedicated-p (get-buffer-window "projects.org") t)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :config
  (yas-reload-all)
  :init
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'org-mode-hook 'yas-minor-mode)
  )




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;; work patterns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-register ?e '(file . "~/.emacs")) ; C-x r j e
(set-register ?p '(file . "~/projects/projects.org")) ;C-x r j p
(defun gpk-lproj ()
  (interactive)
  "Find project directories"
  (insert (shell-command-to-string "find ~/projects -maxdepth 2 -mindepth 1 -type d -not -path '*/\.*' -printf '%P\n'")
	  ))
(defun gpk-git-version ()
  (interactive)
  "Put git version into kill ring"
  (kill-new (shell-command-to-string "git log -1 --pretty=format:%h")
	  ))

(defun gpk-org-property (prop)
  (replace-regexp-in-string "[^a-z].*" "" (downcase (org-element-property prop (org-element-at-point))))
  )
(defun gpk-guess-directory ()
  (interactive)
  "Open dired at best guess for where project lives"
  (let ((lab (gpk-org-property :LAB))
	 (scientist (gpk-org-property :SCIENTIST))
	)
    (ido-read-file-name "Find File:" (concat "~/projects/" lab "/" scientist))
    )
  )
  
    
  
;; (defun myhtml ()
;;   (interactive)
;;   (let ((fname (if (string-match "/projects/" buffer-file-name)
;; 		   (replace-regexp-in-string "projects/\\([^/]*\\)/.*" "public_html/LIVE/results/\\1/index.html" buffer-file-name)
;; 		 (replace-regexp-in-string "public_html/LIVE/results/\\([^/]*\\)/.*" "projects/\\1" buffer-file-name)
;; 		 )
;; 	       ))
;;     (find-file (read-file-name "File:" fname fname))
;;     )
;;   )
;; (defun gpk-find-org-file-recursively (&optional directory filext)
;;   "Return .org and .org_archive files recursively from DIRECTORY.
;; If FILEXT is provided, return files with extension FILEXT instead."
;;   (interactive "DDirectory: ")
;;   (let* (org-file-list
;; 	 (case-fold-search t)	      ; filesystems are case sensitive
;; 	 (file-name-regex "^[^.#].*") ; exclude dot, autosave, and backup files
;; 	 (filext (or nil "org$\\\|org_archive"))
;; 	 (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
;; 	 (cur-dir-list (directory-files directory t file-name-regex)))
;;     ;; loop over directory listing
;;     (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
;;       (cond
;;        ((file-regular-p file-or-dir) ; regular files
;; 	(if (string-match fileregex file-or-dir) ; org files
;; 	    (add-to-list 'org-file-list file-or-dir)))
;;        ((file-directory-p file-or-dir)
;; 	(dolist (org-file (gpk-find-org-file-recursively file-or-dir filext)
;; 			  org-file-list) ; add files found to result
;; 	  (add-to-list 'org-file-list org-file)))))))



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
)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "microsoft" :slant normal :weight normal :height 105 :width normal)))))
