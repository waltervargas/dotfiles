(setq inhibit-startup-message t)
(setq visible-bell t)
(setq auth-sources '(password-store))

;; backup files disabled
(setq auto-save-default nil)
(setq make-backup-files nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 160)
(defvar efs/default-variable-font-size 160)
(set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)

;; global keymaps
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; keymap for a specific mode for example emacs-lisp-mode-map
(define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-theme)

;; enable line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; native compilation
(if (and (fboundp 'native-comp-available-p)
       (native-comp-available-p))
  (message "Native compilation is available")
(message "Native complation is *not* available"))

(if (functionp 'json-serialize)
  (message "Native JSON is available")
(message "Native JSON is *not* available"))

(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (progn
    (setq native-comp-async-report-warnings-errors nil)
    (setq comp-deferred-compilation t)
    (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))
    (setq package-native-compile t)
    ))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;; (unless package-archive-contents
;;   (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; M-x clm/toggle-command-log-buffer
(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-all-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15))

(use-package all-the-icons)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;i(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
         doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-xcode t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; (use-package rainbow-delimiters
;;   ;; the hook keyword specifies for anything that is prog-mode
;;   ;; enable rainbow-delimeters-mode
  
;;   ;; prog-mode is the base mode for all programming languages
  
;;   ;; rainbow-delimeters mode will color parenthesis in elisp
;;   ;; with different colors
;;   :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  ;; don't start searches with ^
  (setq ivy-initial-inputs-alist nil))
  
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; useful package to look a functions and variables
;; documentation (elisp)
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)

  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-function] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  ;;:hook (evil-mode . rune/evil-hook)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; TODO not working, maybe will work when evil mode is enabled
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
   "t"  '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "chose theme")

   "f"  '(:ignore f :which-key "toggles")
   "ff" '(counsel-projectile-find-file :which-key "find file in project")

   "g"  '(:ignore g :which-key "toggles")
   "gg" '(magit-status :which-key "magit status")

   "w"  '(:ignore w :which-key "toggles")
   "wq" '(evil-window-delete :which-key "evil window delete")
   "ww" '(evil-window-vsplit :which-key "evil window vsplit")
   "ws" '(evil-window-split :which-key "evil window split")
   ))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit 1))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/workspace")
    (setq projectile-project-search-path '("~/workspace" "~/workspace/learning-rust")))
  (setq projectile-switch-project-action #'projectile-dired))


;; counsel-projectile-rg to ripgrep on projects
;; C-c C-o to convert the minibuffer into buffer
;; and keep the list on the buffer
;; then press <enter> to jump 
(use-package counsel-projectile
  :config (counsel-projectile-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" default))
 '(org-agenda-files
   '("/home/walter/org/tasks.org" "/home/walter/org/birthdays.org"))
 '(package-selected-packages
   '(yaml-mode company-lsp go-mode rustic yasnippet company lsp-ui lsp-mode flycheck visual-fill-column org-bullets term eterm-256color rainbow-delimiters evil-nerd-commenter forge evil-magit magit counsel-projectile treemacs-icons-dired treemacs-projectile treemacs-evil projectile evil-collection which-key use-package treemacs ivy-rich helpful general evil doom-themes doom-modeline counsel command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(use-package magit
  :bind
  (("C-x g" . magit-status)
   ("C-x C-g" . magit-status))

  ;; don't load magit until this commands are executed
  :commands
  (magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package pass
  :config
  (setq epg-gpg-program "gpg"))

(use-package forge
  :after magit)


(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (auto-fill-mode 0)
  (setq evil-auto-indent nil)
  
  (setq org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t)

  (setq org-startup-indented t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))

  (setq org-babel-python-command "python3"))

(defun efs/org-font-setup ()
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Fira Code Retina" :weight 'regular :height (cdr face)))
  ;; Ensure that anything that should be fixed-pitch 
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-tag nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)
  ;; Set the fixed pitch face
  ;;(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina EtBembo" :height efs/default-font-size)
  (set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height efs/default-font-size)
  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil :font "Fira Code Retina" :height efs/default-variable-font-size :weight 'regular))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-int-drawer t)
  (setq org-agenda-files
	'("~/org/tasks.org"
	  "~/org/birthdays.org"
	  "~/org/habits.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	  (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
	'(("archive.org" :maxlevel . 1)
	  ("tasks.org" :maxlevel . 1)))

  ;; save org buffers after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("germancourse" . ?g)
       ("rust" . ?r)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
	`(("t" "Tasks / Projects")
	  ("tt" "Task" entry (file+olp "~/org/tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

	  ("j" "Journal Entries")
	  ("jj" "Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
	  ("jm" "Meeting" entry
           (file+olp+datetree "~/org/journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
	  
	  ("w" "Workflows")
	  ("we" "Checking Email" entry (file+olp+datetree "~/org/journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

	  ("m" "Metrics Capture")
	  ("mw" "Weight" table-line (file+headline "~/org/metrics.org" "Weight")
	   "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))
  
  (efs/org-font-setup))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package flycheck :ensure)

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-eldoc-hook #'(lsp-hover))
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  
  :config
  ;; uncomment for less flashiness
  (setq lsp-eldoc-hook nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-rust-analyzer-server-display-inlay-hints t)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))


(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :ensure
  :commands (lsp lsp-deferred)
  :hook
  (go-mode . lsp-deferred)
  (terraform-mode . lsp-deferred)
  :config
  ;; disable lsp-eldoc
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  ;;(lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-enable-which-key-integration t))


(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5)) ;; how long to wait until popup

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package go-mode)

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package terraform-mode)

(use-package company-terraform
  :after terraform-mode)

(use-package company-quickhelp)

(use-package yaml-mode
  :mode ("\\.yaml$" . yaml-mode))

