;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 15 :weight 'thin)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; Indent with 4 spaces
(setq tab-width 4)
(setq evil-shift-width 4)
;; the amount of data which Emacs reads from the process (improve lsp)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Fullscreen in macos
(setq default-frame-alist '((fullscreen . maximized)

                            ;; You can turn off scroll bars by uncommenting these lines:
                            ;; (vertical-scroll-bars . nil)
                            ;; (horizontal-scroll-bars . nil)

                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#000000")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))

;; vue-mode
(use-package! vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp!)
  (setq mmm-submode-decoration-level 0) ; Fix highlighting in vue
)

(use-package! lsp-ui
  :config
  (setq
   lsp-enable-file-watchers nil

   lsp-ui-doc-enable t
   lsp-ui-doc-position 'top
   lsp-ui-doc-include-signature t
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-header t

   lsp-ui-flycheck-enable nil
   lsp-ui-flycheck-list-position 'left
   lsp-flycheck-live-reporting nil

   lsp-ui-peek-enable t
   lsp-ui-peek-list-width 60
   lsp-ui-peek-peek-height 25

   lsp-ui-sideline-delay 1.2
   lsp-ui-sideline-enable t
   lsp-ui-sideline-enable t
   lsp-ui-sideline-show-diagnostics t
   lsp-ui-sideline-show-hover t
   lsp-ui-sideline-show-symbol t)

  (map! :n "M-." 'lsp-ui-peek-find-definitions)
  (map! :n "M-/" 'lsp-ui-peek-find-references))

;; (use-package! web
;;   :hook
;;   (prettier-js))

;; (use-package! prettier-js
;;   :config
;;   (setq prettier-js-args '("--trailing-comma" "all" "--vue-indent-script-and-style" "true" "--print-width" "90")))
