;;; tl/js/config.el -*- lexical-binding: t; -*-

(use-package! tree-sitter
  :when (bound-and-true-p module-file-suffix)
  :hook (js-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  )
