;; README

;; most global objects are prefixed 'gpk-' - they shouldn't link to my area of the file-system, but they might depend on following my working patterns.

;; Things that are most likely specific to my way of working are probably signalled by use of anything derived from any calls to "user-login-name" or "gpk-babshome".  These are probably worth searching for.

;; ess and org are the two most pimped-out packages:
;; ORG - I have a yasnippet code that auto-inserts new projects to have certain properties, so a lot of the defun's there are to do with that - I'll try to put the snippets on github as well so that it makes sense.

;; Localisation
(if (string-match "babs" (system-name))
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
 	     '("MELPA" .
 	       "http://melpa.milkbox.net/packages/"))
(package-initialize)
(require 'use-package)
(require `dash)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Prefs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
;; (load-theme 'solarized t)
(setq visible-bell t)
(setq solarized-use-variable-pitch nil)
(setq solarized-scale-org-headlines nil)
(load-theme 'solarized-light t)
;(set-face-attribute 'region nil :foreground "#eee8d5" :background "#839496") 
(let ((line "#cccec4"))
  (set-face-attribute 'mode-line          nil :overline   line)
  (set-face-attribute 'mode-line-inactive nil :overline   line)
  (set-face-attribute 'mode-line-inactive nil :underline  line)
  (set-face-attribute 'mode-line          nil :box        nil)
  (set-face-attribute 'mode-line-inactive nil :box        nil)
  (set-face-attribute 'mode-line          nil :background "#2aa198")
  (set-face-attribute 'mode-line          nil :foreground "#532f62")
  (set-face-attribute 'mode-line-inactive nil :background "#eee8d5")
  )
(set-cursor-color "#2aa198") 



(setq ibuffer-saved-filter-groups
      '(("home" 
	 ("R scripts" (or (mode . ess-r-mode)
			  (filename . "rmd$")))
	 ("R" (mode . inferior-ess-r-mode))
	 ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
	 ("dired" (mode . dired-mode))
	 ("emacs" (or
		   (name . "^\\*scratch\\*$")
		   (name . "^\\*Messages\\*$")
		   (filename . ".emacs.d")
		   (filename . ".emacs")
		   (filename . "emacs-config")
		   ))
	 ;; ("Web Dev" (or (mode . html-mode)
	 ;; 		(mode . css-mode)))
	 ("Magit" (name . "\*magit"))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))
(setq ibuffer-show-empty-filter-groups nil)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))


(use-package minions
   :config (minions-mode 1))


(set-fontset-font t '(#xe100 . #xe16f) "Iosevka") ;; see link on my-ESS-pretty-hook
    
(if gpk-oncamp
    (add-to-list 'default-frame-alist '(font . "Iosevka-12" ))
  (add-to-list 'default-frame-alist '(font . "Consolas" ))
  )

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
(setq shell-command-switch "-c")
;; Scrolling
(setq scroll-preserve-screen-position "always"
      scroll-conservatively 5
      scroll-margin 2)
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))
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
;Spelling
(setq ispell-really-hunspell t)
(setq ispell-program-name "hunspell")
(setq ispell-local-dictionary "en_GB")
(setq ispell-hunspell-dictionary-alist
      '(("en_GB" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_GB") nil utf-8)
	))
(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-strip-common-suffix nil)
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(use-package company
  :ensure t
  :config
  (global-company-mode)
  (define-key company-active-map [return] nil)
  (define-key company-active-map [tab] 'company-complete-common)
  (define-key company-active-map (kbd "TAB") 'company-complete-common)
  (define-key company-active-map (kbd "M-TAB") 'company-complete-selection)
  (setq company-selection-wrap-around t
	company-tooltip-align-annotations t
	company-idle-delay 0.5
	company-minimum-prefix-length 2
	company-tooltip-limit 10)
  )

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
  (setq ess-use-flymake nil)
  :config
  (require 'ess-site)
  (require 'polymode)
  (add-hook `ess-mode-hook  `my-ESS-pretty-hook)
;  (add-hook 'R-mode-hook 'refresh-r-version)
  (bind-key "C-c C-j"  'replace-loop-with-first ess-mode-map)
  (bind-key "M-q" 'kbw ess-help-mode-map)
  (bind-key "C-c w" 'ess-execute-screen-options inferior-ess-mode-map)
  (bind-key "C-<up>" 'comint-previous-matching-input-from-input inferior-ess-mode-map)
  (bind-key "C-<down>" 'comint-next-matching-input-from-input inferior-ess-mode-map)
  (bind-key "C-c ="  'gpk-ess-clip ess-mode-map)
  (setq comint-input-ring-size 1000)
  (setq-default ess-dialect "R")
  (setq ess-eval-visibly nil)
   (setq ;ess-ask-for-ess-directory nil
  	inferior-R-args "--no-save --no-restore")
   :preface
   (add-hook 'ess-mode-hook (lambda () (setq inferior-ess-r-program (concat "./" (car (file-name-all-completions "R-3" "."))))))
   
  (setq inferior-julia-program "./julia.sh")
  (setq ess-ask-for-ess-directory nil)
  (setq ess-history-file nil)
  (setq comint-scroll-to-bottom-on-input t)
  (setq comint-scroll-to-bottom-on-output t)
  (setq comint-move-point-for-output t)
  
  (defun replace-loop-with-first ()
    "Replace a loop with setting the variable to first possible value"
    (interactive)
    (save-excursion
      (let ((original (buffer-substring (line-beginning-position) (line-end-position)))
	    )
	(if (string-match " \*for (\\(\.\*\\) in \\(\.\*\\)) { \*" original)
	    (ess-eval-linewise (replace-match "\\1 <- (\\2)[[1]]" t nil original) nil nil)
	  )
	)
      )
    (ess-next-code-line 1)
    )
  (defun gpk-ess-clip ()
    (interactive)
    "Evaluate region and store results in kill ring"
    (kill-new (substring (
			  ess-string-command  (concat (buffer-substring (mark) (point)) "\n"))
			 4)
	      ))
  (defun my-ESS-pretty-hook ()
    "Set pretty symbols for R" ;;https://www.reddit.com/r/emacs/comments/96q8r3/configuring_iosevka_ligatures_for_emacs/
    (setq prettify-symbols-alist '(("%>%"  . ?⟫) ("<-"  . #Xe137) ("!=" . ?≠) ("==" . ?≡) ("%<>%" . ?⟪) ("%in%" . ?∈)))
    )
  )

(use-package pandoc-mode
  :hook markdown-mode)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
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
  (setq org-priority-faces
      '(
	(?A :foreground "red" :background "yellow" :box t)
	(?B :foreground "black" :background "yellow")
	(?C . "blue")))

  (setq org-hide-emphasis-markers t)
  (setq gpk-working-directory (concat gpk-babshome "working/" user-login-name "/"))
  (setq gpk-project-orgfile (concat gpk-working-directory "work.org"))
;  (setq org-agenda-start-day "0d") 
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
  (setq org-duration-format (quote h:mm))
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
    (downcase (org-entry-get nil prop))
    )
  (defun gpk-first-tag ()
    (nth 1 (split-string (nth 5 (org-heading-components)) ":"))
    )
  (defun gpk-guess-directory ()
    (interactive)
    "Open dired at best guess for where project lives"
    (let* ((lab (gpk-org-property "Lab"))
	   (asf (gpk-org-property "asf"))
	   (scientist (replace-regexp-in-string "@crick.ac.uk" "" (gpk-org-property "Scientist")))
	   (project (replace-regexp-in-string "[^[:alnum:]]" "_" (gpk-org-property "Project")))
	   (project-path (gpk-org-property "path"))
	   )
      (if (file-exists-p project-path)
	  (if (equal current-prefix-arg nil)
	      (find-file (ido-read-file-name "Find File:" project-path))
	    (let ((default-directory project-path))
	      (shell)))
	(let ((default-directory (concat gpk-babshome "working/" user-login-name "/templates")))
	  (shell-command (concat "make " (gpk-first-tag) " lab=" lab " sci=" scientist " project=" project " asf=" asf))
	  )
	)
      )
    )

  (defun gpk-treemacsify ()
    (interactive)
    "Put org projects into treemacs workspaces"
    (write-region "" nil treemacs-persist-file)
    (org-map-entries
     (lambda ()
       (let* (
	      (path (org-entry-get nil "path"))
	      (title (org-entry-get nil "ITEM"))
	      (path-p (and path (file-directory-p path)))
	      )
	 (if (equal 1 (org-outline-level))
	     (write-region (concat "* " title "\n") nil treemacs-persist-file t)
	   (when path-p 
	     (write-region (concat "** " title "\n") nil treemacs-persist-file t)
	     (write-region (concat "- path :: " path "\n") nil treemacs-persist-file t)
	     )
	   )))
     "LEVEL<=2" (list gpk-project-orgfile)
     )
    (find-file treemacs-persist-file)
    (goto-char (point-min))
    (while (re-search-forward "^\* .*\n\\(\*\\s-\\)" nil t)
      (replace-match "\\1"))
    (goto-char (point-min))
    (while (re-search-forward "^\* .*\n\\'" nil t)
      (replace-match ""))
    (save-buffer)
    (kill-buffer)
    (treemacs--restore)
    )
  
  
  
  (bind-key "C-c a"  'org-agenda)
  (bind-key "C-c c" 'org-capture)
  (bind-key "C-c o" 'gpk-guess-directory)
  )

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package yasnippet
  :commands
  (yas-minor-mode)
  :init
  (setq yas-indent-line 'fixed)
  (yas-global-mode 1)
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
;;; Interacting with slurm
(require 'transient)
(load "~/.emacs.d/gpk/slurm.el")
(defun gpk-slurmacs-args (trans)
  "Give a grouped list of all arguments in a transient suffix"
  (mapcar (lambda (grp) (cons (plist-get (aref grp 2) :description)
			 (seq-map (lambda (cmd) (plist-get (third cmd) :argument)) (aref grp 3))))
	  (get trans 'transient--layout)
	  ))
(defun gpk-slurmacs-sub-args (args grouped-args group)
  "Find which args belong to a specific group"
  (let (
	(these-args (cdr (seq-find (lambda (grp) (string= (car grp) group)) grouped-args)))
	)
    (seq-filter (lambda (argstr)
		  (member (replace-regexp-in-string "\\(=\\).*" "\\1" argstr) these-args)
		  )
		args)
    )
  )
(defun gpk-paste (args sep)
  "Implement R's paste command"
  (mapconcat 'identity args sep)
  )

(defun gpk-build-slurm (args)
  "Make the bash script that will submit to slurm"
  (interactive (list (transient-args 'slurmacs-transient)))
  (let* ((this-file (buffer-file-name (current-buffer)))
	 (all-args (gpk-slurmacs-args 'slurmacs-transient))
	 (slurm-args (gpk-slurmacs-sub-args args all-args "Arguments"))
	 (rmd-args (gpk-slurmacs-sub-args args all-args "Markdown"))
	 (srun (cond ((bound-and-true-p poly-markdown+r-mode)
		      (concat "R -e \"rmarkdown::render('" this-file "', " (gpk-paste rmd-args ",")"')\"")
		      )
		     ((eq major-mode `ess-r-mode)
		      (concat "Rscript \"" this-file "\"")
		      )
		     (t this-file)
		     )
	       )
	 )
    (concat "sbatch " (gpk-paste slurm-args " ") " <<EOF
#!/bin/bash
srun " srun  "
[[ -z \"${SLACK_URL}\" ]] || curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"'$SLURM_JOB_NAME' has finished\"}' \"${SLACK_URL}\"
EOF")
 	     )
  )

(defun slurmacs-submit (&optional args)
  "Submit script to CAMP"
  (interactive (list (transient-args 'slurmacs-transient)))
  (shell-command-to-string (gpk-build-slurm args))
  )

(defun slurmacs-message (&optional args)
  "Submit script to CAMP"
  (interactive (list (transient-args 'slurmacs-transient)))
  (setq shell-script (gpk-build-slurm args))
  (switch-to-buffer "slurm.sh")
  (insert shell-script)
  )


(define-transient-command slurmacs-transient ()
  "Slurmacs"
  :value (lambda () (list (concat "--output=" (buffer-file-name) ".out.log")
		     (concat "--error=" (buffer-file-name) ".err.log")
		     (concat "--job-name=\"" (buffer-name) "\"")
		     (concat "output_file='" (file-name-base) ".html'")
		     (concat "output_dir='" default-directory (car (ess-get-words-from-vector "dirname(vDevice())\n")) "'")
		     "--mem-per-cpu=8G"  "--partition=cpu" "--time=1:00:00" "--cpus-per-task=4"
		     ))
  ["Arguments"
   ("-t" "Time Limit" "--time=")
   ("-p" "Partition" "--partition=")
   ("-c" "CPUs" "--cpus-per-task=")
   ("-m" "Memory" "--mem-per-cpu=")
   ("-l" "Log" "--output=")
   ("-e" "Error file" "--error=")
   ("-J" "Job Name" "--job-name=")
   ]
  ["Markdown"
   :if (lambda () (bound-and-true-p poly-markdown+r-mode))
   ("-o" "Output file" "output_file=")
   ("-d" "Output dir" "output_dir=")
   ]
  ["Actions"
   ("s" "Submit to slurm" slurmacs-submit)
   ("b" "Build script" slurmacs-message)
   ]
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
 '(markdown-command "pandoc" t)
 '(moody-mode-line-height 20)
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
    (transient pretty-symbols org-fancy-priorities slack moody flucui-themes company pdf-tools pandoc-mode flycheck zenburn markdown-mode outshine image+ color-theme-solarized groovy-mode ess f bookmark+ dired+ highlight-parentheses undo-tree)))
 '(safe-local-variable-values (quote ((babshash . babs8aecf935)))))


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
 '(outline-1 ((t (:foreground "#268bd2" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 1.6))))
 '(outline-2 ((t (:foreground "#2aa198" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 1.4))))
 '(outline-3 ((t (:foreground "#b58900" :box (:line-width 2 :color "grey75" :style pressed-button) :overline nil :weight bold :height 1.2)))))
