;;; tl/js/config.el -*- lexical-binding: t; -*-
;;;        use (lsp +eglot) in doom's init.el
;;;        do not enable the doom javascript module in init.el
;;;        i'm on emacs 29.0.90 from d12frosted homebrew at the moment, 28 would probably be wiser




(define-derived-mode tl-js-mode fundamental-mode "tl js mode" "My major javascript mode"
                                        ; borrowed from js-mode
  (setq-local comment-start "// ")
  (setq-local comment-start-skip "\\(?://+\\|/\\*+\\)\\s *")
  (setq-local comment-end "")
  )

(define-derived-mode tl-ts-mode tl-js-mode "tl ts mode" "My major typescript mode")
(define-derived-mode tl-tsx-mode tl-ts-mode "tl tsx mode" "My major tsx mode")

(add-to-list 'auto-mode-alist '("\\.js\\'" . tl-js-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . tl-js-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . tl-js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tl-tsx-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . tl-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tl-tsx-mode))

(eval-after-load 'tl-js-mode '(add-hook 'tl-js-mode-hook #'add-node-modules-path))

;; syntax highlighting
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  ;; (tree-sitter-require 'tsx)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-js-mode . javascript))
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-ts-mode . typescript))
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-tsx-mode . tsx))
  )

;; lsp client, formatting, linting, renaming, etc...
(use-package! eglot
  :defines (eglot-server-programs)
  :hook (((tl-js-mode) . eglot-ensure))
  :init
  (setq eglot-sync-connect 1
        eglot-connect-timeout 10
        eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5
        ;; NOTE We disable eglot-auto-display-help-buffer because :select t in
        ;;      its popup rule causes eglot to steal focus too often.
        eglot-auto-display-help-buffer nil)
  :config
  (add-to-list 'eglot-server-programs '((tl-js-mode) . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-stay-out-of 'flymake)
  )

;; indentation
;; https://vxlabs.com/2022/06/12/typescript-development-with-emacs-tree-sitter-and-lsp-in-2022/#ensure-for-tsx-configure-for-tree-sitter-based-indentation

(use-package tsi
  :after tree-sitter
  :commands (tsi-typescript-mode)
  :hook (((tl-js-mode) . (lambda () (tsi-typescript-mode 1))))
  )

;; more lints from typescript
(use-package flymake-eslint
  :hook ((tl-js-mode) . (lambda () (flymake-eslint-enable)))
  )
