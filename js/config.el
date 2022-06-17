;;; tl/js/config.el -*- lexical-binding: t; -*-

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
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tl-js-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . tl-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tl-tsx-mode))



(eval-after-load 'tl-js-mode
  '(add-hook 'tl-js-mode-hook #'add-node-modules-path))

(eval-after-load 'tl-ts-mode
  '(add-hook 'tl-ts-mode-hook #'add-node-modules-path))

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (tree-sitter-require 'tsx)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-js-mode . javascript))
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-ts-mode . typescript))
  (add-to-list 'tree-sitter-major-mode-language-alist '(tl-tsx-mode . tsx))
  )

(add-hook!
'(tl-js-mode-local-vars-hook
  tl-ts-mode-local-vars-hook
  tl-tsx-mode-local-vars-hook
  ) #'lsp)

(after! flycheck
      (flycheck-add-mode 'javascript-eslint 'tl-js-mode)
      (flycheck-add-mode 'javascript-standard 'tl-js-mode)
      )
