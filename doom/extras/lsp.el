;;; extras/lsp.el -*- lexical-binding: t; -*-

;; lsp-ui
(setq
 lsp-enable-file-watchers nil
 lsp-enable-indentation nil   ;; prettier preferred
 lsp-enable-links nil        ;; no need for lsp links when we have browse-url
 lsp-completion-enable-additional-text-edit nil ;; may need to test further
 lsp-enable-snippet nil
 lsp-headerline-breadcrumb-enable nil
 lsp-modeline-code-actions-enable nil
 lsp-modeline-workspace-status-enable nil
 lsp-signature-doc-lines 1  ;; default 20
 lsp-use-plists t

 lsp-ui-doc-enable t
 lsp-ui-doc-position 'top
 lsp-ui-doc-include-signature nil
 lsp-ui-doc-use-childframe nil
 lsp-ui-doc-header t

 lsp-ui-flycheck-enable nil
 lsp-flycheck-live-reporting nil

 lsp-ui-peek-enable t
 lsp-ui-peek-list-width 60
 lsp-ui-peek-peek-height 25

 lsp-ui-sideline-delay 1.2
 lsp-ui-sideline-enable t
 lsp-ui-sideline-show-diagnostics t
 lsp-ui-sideline-show-hover t
 lsp-ui-sideline-show-symbol nil)

;;; Lsp
(setq lsp-client-packages '(ccls lsp-actionscript lsp-ada lsp-angular lsp-ansible lsp-asm lsp-astro
      lsp-autotools lsp-awk lsp-bash lsp-beancount lsp-bufls lsp-clangd
      lsp-clojure lsp-cmake lsp-cobol lsp-credo lsp-crystal lsp-csharp lsp-css
      lsp-cucumber lsp-cypher lsp-d lsp-dart lsp-dhall lsp-docker lsp-dockerfile
      lsp-earthly lsp-elixir lsp-elm lsp-emmet lsp-erlang lsp-eslint lsp-fortran
      lsp-fsharp lsp-gdscript lsp-gleam lsp-glsl lsp-go lsp-golangci-lint
      lsp-grammarly lsp-graphql lsp-groovy lsp-hack lsp-haskell lsp-haxe
      lsp-idris lsp-java lsp-javascript lsp-jq lsp-json lsp-kotlin lsp-latex
      lsp-lisp lsp-ltex lsp-lua lsp-magik lsp-markdown lsp-marksman lsp-mdx
      lsp-meson lsp-metals lsp-mint lsp-mojo lsp-move lsp-mssql lsp-nginx
      lsp-nim lsp-nix lsp-nushell lsp-ocaml lsp-openscad lsp-pascal lsp-perl
      lsp-perlnavigator lsp-php lsp-pls lsp-purescript lsp-pwsh lsp-pyls
      lsp-pylsp lsp-pyright lsp-python-ms lsp-qml lsp-r lsp-racket lsp-remark
      lsp-rf
      ;; lsp-roslyn
      lsp-rubocop lsp-ruby-lsp lsp-ruby-syntax-tree
      lsp-ruff-lsp lsp-rust lsp-semgrep lsp-shader lsp-solargraph lsp-solidity
      lsp-sonarlint lsp-sorbet lsp-sourcekit lsp-sql lsp-sqls lsp-steep
      lsp-svelte lsp-tailwindcss lsp-terraform lsp-tex lsp-tilt lsp-toml
      lsp-trunk lsp-ttcn3 lsp-typeprof lsp-v lsp-vala lsp-verilog lsp-vetur
      lsp-vhdl lsp-vimscript lsp-volar lsp-wgsl lsp-xml lsp-yaml lsp-yang
      lsp-zig))
(setq
 lsp-volar-hybrid-mode nil
 lsp-volar-take-over-mode nil)
;; Tailwind
;; (use-package! lsp-tailwindcss
  ;; :init (setq lsp-tailwindcss-add-on-mode t)
  ;; :config
  ;; (dolist (tw-major-mode
  ;;         '(css-mode
  ;;           css-ts-mode
  ;;           typescript-mode
  ;;           typescript-ts-mode
  ;;           tsx-ts-mode
  ;;           web-mode
  ;;           js2-mode
  ;;           js-ts-mode))
  ;; (add-to-list 'lsp-tailwindcss-major-modes tw-major-mode))
  ;; )
;; web-mode
(setq web-mode-style-padding 0)
(setq web-mode-script-padding 0)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
