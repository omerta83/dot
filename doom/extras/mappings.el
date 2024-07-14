;;; extras/mappings.el -*- lexical-binding: t; -*-

;;; Git
(map! :n "SPC g p" 'diff-hl-show-hunk)
(map! :leader
      "g g" 'magit-status)
(map! :leader
      :desc "Find string in the project"
      :n
      "f g" 'consult-ripgrep)
(map! :nig "C-s" 'consult-line)

(map! :n "]h" 'diff-hl-next-hunk)
(map! :n "[h" 'diff-hl-previous-hunk)

;;; Embark
;; Unbind this so that embark help prefix works on C-w commands
(map! :m "C-w C-h" nil)
(map! :nig "C-." 'embark-act)
(map! :nig "C-;" 'embark-dwim)        ;; good alternative: M-.
(map! :nig "C-h B" 'embark-bindings)

;;; Project-related
(map! :leader
      :desc "Switch project"
      :n
      "p p" 'project-switch-project)
(map! :leader
      :desc "Run cmd in project root"
      :n
      "p !" 'project-shell-command)
(map! :leader
      :desc "Find file in project"
      :n
      "SPC" 'project-find-file)
(map! :leader
      :desc "Find file in project"
      :n
      "p f" 'project-find-file)

;;; Lsp
(map! :n "M-." 'lsp-ui-peek-find-definitions)
(map! :n "M-/" 'lsp-ui-peek-find-references)

;; (map! :map evil-window-map
;;       "SPC" #'rotate-layout
;;       ;; Navigation
;;       "h"     #'evil-window-left
;;       "j"     #'evil-window-down
;;       "k"       #'evil-window-up
;;       "l"    #'evil-window-right
;;       ;; Swapping windows
;;       "C-<left>"       #'+evil/window-move-left
;;       "C-<down>"       #'+evil/window-move-down
;;       "C-<up>"         #'+evil/window-move-up
;;       "C-<right>"      #'+evil/window-move-right)
