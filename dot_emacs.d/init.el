(add-to-list 'load-path (concat (file-name-as-directory user-emacs-directory) "extra-pkgs") t)

;; Install use-package from ELPA
;; M-x package-install-package RET use-package RET
;; https://github.com/jwiegley/use-package
(eval-when-compile
  (require 'use-package))

;; in case init.el becomes too bloated, use the folder hierarchy in the link below as inspiration
;; https://chat.openai.com/c/5340969a-8d69-475a-95d8-79771a739841
;;(add-to-list 'load-path (concat (file-name-as-directory user-emacs-directory) "init"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)


;; Set exec-path variable from the shell path.
(use-package
  exec-path-from-shell
  :ensure t)
(exec-path-from-shell-initialize)


;; Better *help* buffer
(use-package
  helpful
  :ensure t
  :init (require 'bind-key)
  :bind (("C-h f" . helpful-callable)	; Replace describe-function
	 ("C-h v" . helpful-variable)	; Replace describe-variable
	 ("C-h k" . helpful-key)	; Replace describe-key
	 ("C-h x" . helpful-command)))	; Replace describe-command


;; Fonts
(setq use-default-font-for-symbols nil)
;; Install Google Noto's Color Emoji font and paste the line below in custom.el
;;(add-hook 'after-make-frame-functions (lambda (f) (set-fontset-font t '(#x2300 . #x1FAFF) "Noto Color Emoji" nil 'append)))


;; Custom config
(setq custom-file (concat (file-name-as-directory user-emacs-directory) "custom.el"))
(load custom-file 'noerror)


;; org-mode helpers
(load (concat (file-name-as-directory user-emacs-directory) "org-mode") 'noerror)


;; Auto Save
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Auto-Save-Control.html
(when (>= emacs-major-version 26)
  (auto-save-visited-mode 1)
  (setq auto-save-visited-interval 30))


;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)
(add-hook 'ibuffer-mode-hook (lambda ()
			       (ibuffer-auto-mode 1)))


;; From https://git.sr.ht/%7Etechnomancy/better-defaults
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR." t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; https://www.emacswiki.org/emacs/SavePlace
(save-place-mode 1)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-z") 'zap-up-to-char)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(savehist-mode 1)
(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      backup-by-copying t
      frame-inhibit-implied-resize t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      ediff-window-setup-function 'ediff-setup-windows-plain)

(unless backup-directory-alist
  (setq backup-directory-alist `(("." . ,(concat (file-name-as-directory user-emacs-directory)
                                                 "backups")))))

(setq tramp-auto-save-directory (concat (file-name-as-directory user-emacs-directory)
                                        "backups"))

;; Copy/paste
(cua-mode t)
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour


;; Always display column number
(setq column-number-mode t)


;; Remove toolbar
(tool-bar-mode -1)


;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
;; do this especially on Windows, else python output problem
(set-terminal-coding-system 'utf-8-unix)


;; company - text completion framework
(use-package
  company
  :ensure t
  :hook (prog-mode . company-mode))

(use-package
  company-box
  :ensure t
  :requires company
  :hook (company-mode . company-box-mode))


;; org-mode
(use-package
  org
  :ensure nil
  :bind ("C-M-<return>" . org-insert-subheading))

(customize-set-variable 'org-directory "~/Documents/org-files/")
(customize-set-variable 'org-archive-location (concat (file-name-as-directory org-directory)
						      "arquivo.org::* From %s"))
(customize-set-variable 'org-agenda-files (list org-directory (concat (file-name-as-directory
								       org-directory) "Notes") 
						(concat (file-name-as-directory org-directory)
							"journal")))
(customize-set-variable 'org-use-tag-inheritance nil)
(setq org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)"
				    "CANCELED(c)")))
(setq org-agenda-files '(org-directory))
(setq org-tag-persistent-alist
      '((:startgroup)
	("projeto")
	(:grouptags)
	("{p@.+}")
	(:endgroup)))
(setq org-default-notes-file (concat (file-name-as-directory org-directory) "notes.org"))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)


(use-package
  org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))

;; Org to Markdown for Hugo
(use-package
  ox-hugo
  :ensure t
  :pin melpa ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

;; Org exporter for asciidoc format
;; https://github.com/yashi/org-asciidoc
(use-package
  ox-asciidoc
  :ensure t)


(use-package
  emojify
  :ensure t
  :after org
  :hook (org-mode . emojify-mode)
  :bind ("C-c e" . emojify-insert-emoji)
  :config (setq emojify-display-style 'unicode)
  (setq emojify-emoji-styles '(unicode)))


(use-package
  diminish
  :ensure t)

(use-package
  ace-window
  :ensure t
  :bind ("M-o" . ace-window))


;; Imenu
(add-hook 'prog-mode-hook #'imenu-add-menubar-index)
(add-hook 'prog-mode-hook
      (lambda ()
        (setq-local imenu-auto-rescan t)))


;; Emacs Lisp
(use-package
  eldoc
  :ensure t
  :diminish eldoc-mode)

(use-package
  elisp-format
  :ensure t)

(use-package
  macrostep
  :ensure t
  :config (define-key emacs-lisp-mode-map (kbd "C-c e") 'macrostep-expand))

(use-package
  yasnippet
  :ensure t
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config (yas-reload-all))

(use-package
  ledger-mode
  :ensure t)

(use-package
  hledger-mode
  :ensure t
  :mode ("\\.journal\\'" "\\.hledger\\'"))

;; beancount-mode is not in MELPA.
;; Installation: copy beancount.el to ~/.emacs.d/extra-pkgs/
;; https://github.com/beancount/beancount-mode/
(require 'beancount nil 'noerror)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))


(use-package
  which-key
  :ensure t
  :config (which-key-mode))


;; Projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


;; Language Server Protocol (lsp-mode)
(use-package
  lsp-mode
  :ensure t
  :hook (((c-mode c++-mode go-mode python-mode) . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package
  lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package
  lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

(use-package
  lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "basedpyright"))


;; Debugger Adapter Protocol
(use-package
  dap-mode
  :ensure t
  :after lsp-mode
  :config (require 'dap-cpptools)
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  (require 'dap-dlv-go))


(use-package
  slime
  ;; :init
  ;; (add-to-list 'load-path (expand-file-name "contrib" slime-path))
  :config (setq inferior-lisp-program "sbcl"))

;; minor mode for a nice writing environment
(use-package
  olivetti
  :ensure t)

;; integration with grammar correction tool LanguageTool
(use-package
  langtool
  :ensure t
  :config (setq langtool-http-server-host "localhost" langtool-http-server-port 8081))
(use-package
  langtool-popup)

;; typographical editing
(use-package
  typo
  :ensure t
  :hook (text-mode . typo-mode)
  :init (typo-global-mode 1))

(use-package
  editorconfig
  :ensure t
  :diminish editorconfig-mode
  :config (editorconfig-mode 1))

;; config/markup language support
(use-package
  markdown-mode
  :ensure t)

(use-package
  adoc-mode
  :ensure t)

(use-package
  ini-mode
  :ensure t)
(use-package
  json-mode
  :ensure t)
(use-package
  yaml-mode
  :ensure t)
(use-package
  nginx-mode
  :ensure t)

;; Docker
(use-package
  dockerfile-mode
  :ensure t)
(use-package
  docker-compose-mode
  :ensure t)

(use-package
  zig-mode)

(use-package
  vue-mode)

(use-package
  go-mode)
(use-package
  ob-go)


;; Emmet
(use-package
  emmet-mode
  :ensure t
  :hook ((sgml-mode web-mode css-mode) . emmet-mode))


(use-package
  smartparens
  :ensure t
  :diminish smartparens-mode
  :config (require 'smartparens-config))


;; Themes
(use-package
  modus-themes
  :ensure t)
(load-theme 'modus-operandi)
