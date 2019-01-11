;; README

;; most global objects are prefixed 'gpk-' - they shouldn't link to my area of the file-system, but they might depend on following my working patterns.

;; Things that are most likely specific to my way of working are probably signalled by use of anything derived from any calls to "user-login-name" or "gpk-babshome".  These are probably worth searching for.

;; ess and org are the two most pimped-out packages:
;; ESS - I have a funny way of loading R, and I'm in the process of changing it so refresh-r-version is probably not needed by most people.
;; ORG - I have a yasnippet code that auto-inserts new projects to have certain properties, so a lot of the defun's there are to do with that - I'll try to put the snippets on github as well so that it makes sense.


;; Localisation
(if (string-match "thecrick" (system-name))
    (setq gpk-babshome (getenv "my_lab")
	  gpk-oncamp t)
  (setq gpk-babshome "I:\\"
	gpk-oncamp nil)
  )
(setq inhibit-default-init t)
(setq use-package-always-ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq use-package-always-ensure t)
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
(load-theme 'solarized t)
(if gpk-oncamp
    (set-face-attribute 'default nil :family "Input")
  (set-face-attribute 'default nil :family "Consolas")
  )
;; Use monospaced font faces in current buffer
(defun my-buffer-face-mode-fixed ()
  "Sets a fixed width (monospace) font in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Input-mono"))
  (buffer-face-mode))
(menu-bar-mode nil) 
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(tool-bar-mode -1); hide the toolbar
(prefer-coding-system 'utf-8)
(display-time-mode t)
(global-prettify-symbols-mode 1)
(defvar ESS-prettify-symbols-alist '())
;;Editing
(global-font-lock-mode t); syntax highlighting
(delete-selection-mode t); entry deletes marked text
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode
;;Shell
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")
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
;;;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package outshine
  :init
  (setq outshine-use-speed-commands t)
  (add-hook 'ess-mode-hook 'outshine-mode)
  (add-hook 'R-mode-hook 'outshine-mode)
  (add-hook 'julia-mode-hook 'outshine-mode)
  )



(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))


(use-package magit
  :commands magit-get-top-dir
  :bind ("C-x g" . magit-status))

(use-package s)

(use-package expand-region
  :commands er/expand-region
  :bind ("C-=" . er/expand-region))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  )

(use-package web-mode
  :commands web-mode
  :mode (("\\.html\\'" . web-mode)
	 ("\\.php\\'" . web-mode)
	 )
  :config
  (setq web-mode-markup-indent-offset 2)
  )

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)
  )

(use-package dired+
  :config
  (diredp-toggle-find-file-reuse-dir 1)
  )

(use-package ess
  :commands (R julia)
  :mode (("\\.r\\'" . R-mode)
	 ("\\.R\\'" . R-mode)
	 ("\\.Rmd" . poly-markdown+r-mode)
	 ("\\.jl\\'" . ess-julia-mode))
  :init
  (setq ess-default-style 'RStudio)
  :config
  (require 'ess-site)
  (require 'polymode)
  (add-hook `ess-mode-hook  `my-ESS-pretty-hook)
  (add-hook 'R-mode-hook 'refresh-r-version)
;  (add-hook `iESS-mode-hook `my-buffer-face-mode-fixed)
  (bind-key "C-c C-j"  'replace-loop-with-first ess-mode-map)
  (bind-key "M-q" 'kbw ess-help-mode-map)
  (bind-key "C-c w" 'ess-execute-screen-options inferior-ess-mode-map)
  (bind-key "C-<up>" 'comint-previous-matching-input-from-input inferior-ess-mode-map)
  (bind-key "C-<down>" 'comint-next-matching-input-from-input inferior-ess-mode-map)
  (bind-key "C-c ="  'gpk-ess-clip ess-mode-map)
  (setq comint-input-ring-size 1000)
  (setq-default ess-dialect "R")
  (setq ess-eval-visibly nil)
   (setq ess-ask-for-ess-directory nil
  	inferior-R-args "--no-save --no-restore")
   ;; (use-package ess-tracebug
   ;;   :init
   ;;   (ess-tracebug t)
   ;;   )
  :preface
  (setq inferior-julia-program "./julia.sh")
  (setq ess-ask-for-ess-directory nil)
  (setq ess-history-file nil)
  (setq comint-scroll-to-bottom-on-input t)
  (setq comint-scroll-to-bottom-on-output t)
  (setq comint-move-point-for-output t)
  (defun kbw ()
    "kill"
    (interactive) (kill-buffer-and-window)
    )
  (defun refresh-r-version ()
    "Find newest version of R, which might be local"
    (setq ess-newest-R nil)
    (setq inferior-ess-r-program (car (ess-find-exec-completions "R-3" ".")))
;    (ess-check-R-program)
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
  
  (defun gpk-ess-clip ()
    (interactive)
    "Evaluate region and store results in kill ring"
    (kill-new (substring (
			  ess-string-command  (concat (buffer-substring (mark) (point)) "\n"))
			 4)
	      ))
  (defun my-ESS-pretty-hook ()
    "Set pretty symbols for R"
    (setq prettify-symbols-alist '(("%>%"  . ?►) ("<-"  . ?←) ("==" . ?≡) ("%<>%" . ?◄) ("%in%" . ?∈)))
    )
   )

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  )

(use-package polymode 
  :ensure t
  :mode
  ("\\.Snw" . poly-noweb+r-mode)
  ("\\.Rnw" . poly-noweb+r-mode)
  ("\\.Rmd" . poly-markdown+r-mode))

(use-package highlight-parentheses
  :config
  (show-paren-mode t)
  (setq hl-paren-colors '("#1b9e77" "#d95f02" "#7570b3" "#e7298a" "#a6761d" "#e6ab02"))
  (global-highlight-parentheses-mode t)
  )

(use-package bookmark
  :config
  (use-package bookmark+))

(use-package org
  :init
  (setq org-hide-emphasis-markers t)
  (setq gpk-working-directory (concat gpk-babshome "working/" user-login-name "/"))
  (setq gpk-project-orgfile (concat gpk-working-directory "work.org"))
  (setq org-agenda-start-day "-7d") 
  (add-to-list 'auto-mode-alist '("README$" . org-mode))
  (defun my-org-confirm-babel-evaluate (lang body)
    (not (string= lang "elisp")))  ; don't pester 
  (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
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
  (setq org-time-clocksum-format "%d:%02d")
  (defun my-org-clocktable-indent-string (level)
    (if (= level 1)
	""
      (let ((str ""))
	(while (> level 2)
        ((set )q level (1- level)
	 str (concat str "--")))
	(concat str ""))))
  (advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)
  
  (defun gpk-org-property (prop)
    (downcase (plist-get (nth 1 (org-element-at-point)) prop))
    )
  (defun gpk-guess-directory ()
    (interactive)
    "Open dired at best guess for where project lives"
    (let* ((lab (gpk-org-property :LAB))
	   (scientist (replace-regexp-in-string "@crick.ac.uk" "" (gpk-org-property :SCIENTIST)))
	   (project (replace-regexp-in-string "[^[:alnum:]]" "_" (gpk-org-property :PROJECT)))
	   (guess-dir (concat gpk-working-directory "projects/" lab "/" scientist "/" project))
	   (template-dir (car (plist-get (nth 1 (org-element-at-point)) :tags)))
	   )
      (if (file-exists-p guess-dir)
	  (if (equal current-prefix-arg nil)
	      (find-file (ido-read-file-name "Find File:" guess-dir))
	    (let ((default-directory guess-dir))
	      (shell)))
	(shell-command (concat "git clone --depth=1 " ; forget most of the history
			       "--template=" gpk-working-directory "templates/.git_template " ; hook that puts each commit in a database
			       "file:///" gpk-babshome "working/" user-login-name "/templates/" template-dir " " guess-dir
			       ))
	(shell-command (concat "cd " guess-dir ";git remote remove origin"))
	)
      )
    )
  (bind-key "C-c a"  'org-agenda)
  (bind-key "C-c c" 'org-capture)
  (bind-key "C-c o" 'gpk-guess-directory)
  )

(use-package yasnippet
  :commands
  (yas-minor-mode)
  :init
  (setq yas-indent-line 'fixed)
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  (add-hook 'org-mode-hook #'yas-minor-mode)
  (add-hook 'ess-mode-hook #'yas-minor-mode)
  :config
  (yas-reload-all)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;; work patterns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Abbreviations for standard directories
(defun gpk-abbrev (pth)
  (let ((gpk-abbrev-alist `(("//CAMP/working/USER/projects/" ."PROJ>")
			    ("//CAMP/working/USER/" . "GPK>")
			    ("//CAMP/working/" . "WORK>")
			    ("//CAMP" . "BABS>")
			    (,(getenv "HOME") . "~")
			    ("/home/camp/USER" . "~")
			    )))
    (seq-reduce (lambda (thispth sublist) (replace-regexp-in-string
				      (replace-regexp-in-string "USER" user-login-name
								(replace-regexp-in-string "^//CAMP/" gpk-babshome (car sublist))
								)
					     (cdr sublist) thispth))
		  gpk-abbrev-alist pth)
    )
  )

;; Use abbreviations in window title
(setq frame-title-format
      '((:eval (gpk-abbrev (if (buffer-file-name)
			       (buffer-file-name)
			     (comint-directory "."))
			   )))
)

;; Get lab names from directory structure
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


;; My bookmarks
(dolist (r `((?p (file . ,(concat gpk-project-orgfile)))
             (?e (file . ,(concat "~/.emacs")))
             (?r (file . ,(concat gpk-babshome "working/" user-login-name "/code/R/crick.kellyg/R")))
             (?c "@crick.ac.uk")
	     ))
  (set-register (car r) (cadr r)))



;retain alpha of grant description
(defun gpk-grant-key (grant)
  "return suitable key for givent grant-row"
  (replace-regexp-in-string "[^a-z]" ""  (downcase (nth 1 grant)))
  )
(defun gpk-grant-to-dir (glab)
  "return most likely dlab for a  glab"
  (let* (
	(all-match (mapcar (lambda (dirlab) (length (s-shared-start dirlab glab))) gpk-lab-names))
	(max-len (seq-max all-match))
	(which-max (seq-position all-match max-len))
	)
    (nth which-max gpk-lab-names)
  ))

(setq gpk-grants 
      (let* (
	     (fname (concat gpk-babshome "working/" user-login-name "/projects/.projects.txt"))
	     (tab-delim (with-temp-buffer
			  (insert-file-contents fname)
			  (split-string (buffer-string) "\n" t)))
	     (projects (cdr tab-delim))
	     (project-map (mapcar (lambda (a) (split-string a "\t")) projects))
	     )
	(seq-group-by (lambda (g) (gpk-grant-to-dir (gpk-grant-key g)))  project-map)
	)
      )
(defun gpk-labs-grants (lab)
  "Return list of grants given lab"
  (let* (
	 (grant-row-keyed (seq-find (lambda (g) (equal (car g) lab)) gpk-grants))
	 (grant-row (cdr grant-row-keyed))
	 )
    (mapcar (lambda (gs) (concat (car gs) " " (car (cdr gs)))) grant-row)
    )
  )
   
  
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun gpk-git-version ()
  (interactive)
  "Put git version into kill ring"
  (kill-new (shell-command-to-string "git log -1 --pretty=format:%h")
	    ))




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "412c25cf35856e191cc2d7394eed3d0ff0f3ee90bacd8db1da23227cdff74ca2" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ess-swv-pdflatex-commands (quote ("pdflatex" "texi2pdf" "make")))
 '(ess-swv-processor (quote knitr))
 '(hl-sexp-background-color "#efebe9")
 '(org-clock-rounding-minutes 60)
 '(org-link-frame-setup
   (quote
    ((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame))))
 '(org-speed-commands-user (quote (("h" . org-clock-in) ("d" . lambda))))
 '(org-use-speed-commands t)
 '(package-selected-packages
   (quote
    (use-package poly-R zenburn-theme zenburn solarized-theme spacemacs-theme projectile markdown-mode polymode outshine image+ color-theme-solarized groovy-mode leuven-theme ess f bookmark+ dired+ highlight-parentheses undo-tree))))


					;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
					; '(default ((t (:family "Consolas" :foundry "microsoft" :slant normal :weight normal :height 105 :width normal)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-highlight-input ((t (:inherit nil :foreground "#0000FF" :weight normal))))
 '(outline-1 ((t (:foreground "#268bd2" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 2.0 :family "utopia"))))
 '(outline-2 ((t (:foreground "#2aa198" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 1.8 :family "utopia"))))
 '(outline-3 ((t (:foreground "#b58900" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 1.5 :family "utopia")))))
