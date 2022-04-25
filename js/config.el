;;; tl/js/config.el -*- lexical-binding: t; -*-
(define-derived-mode tl-js-mode fundamental-mode "tl js mode" "My major javascript mode")
(define-derived-mode tl-ts-mode fundamental-mode "tl ts mode" "My major typescript mode")

(add-to-list 'auto-mode-alist '("\\.js\\'" . tl-js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tl-js-mode))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . tl-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tl-ts-mode))

;tree-sitter-major-mode-language-alist
;(javascript-mode . javascript)
;
(add-to-list 'tree-sitter-major-mode-language-alist '(tl-js-mode . javascript))
(add-to-list 'tree-sitter-major-mode-language-alist '(tl-ts-mode . typescript))

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

  ;; (setq js-chain-indent nil
  ;;       js-jsx-syntax nil)
  )


(add-hook! '(tl-js-mode-local-vars-hook
             typescript-mode-local-vars-hook
             typescript-tsx-mode-local-vars-hook
             web-mode-local-vars-hook
             rjsx-mode-local-vars-hook
             js-mode-local-vars-hook)
  (defun +javascript-init-lsp-or-tide-maybe-h ()
    "Start `lsp' or `tide' in the current buffer.

LSP will be used if the +lsp flag is enabled for :lang javascript AND if the
current buffer represents a file in a project.

If LSP fails to start (e.g. no available server or project), then we fall back
to tide."
    (let ((buffer-file-name (buffer-file-name (buffer-base-buffer))))
      (when (derived-mode-p 'js-mode 'typescript-mode 'typescript-tsx-mode)
        (if (null buffer-file-name)
            ;; necessary because `tide-setup' and `lsp' will error if not a
            ;; file-visiting buffer
            (add-hook 'after-save-hook #'+javascript-init-lsp-or-tide-maybe-h
                      nil 'local)
          (or (if (featurep! +lsp) (lsp!))
              ;; fall back to tide
              (if (executable-find "node")
                  (and (require 'tide nil t)
                       (progn (tide-setup) tide-mode))
                (ignore
                 (doom-log "Couldn't start tide because 'node' is missing"))))
          (remove-hook 'after-save-hook #'+javascript-init-lsp-or-tide-maybe-h
                       'local))))))

(eval-after-load 'js-mode
  '(add-hook 'js-mode-hook #'add-node-modules-path))
