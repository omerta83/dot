;;; extras/projectile.el -*- lexical-binding: t; -*-

(setq projectile-project-search-path '("~/Sites/"))
(defun mp/get-project-root ()
  (when (fboundp 'projectile-project-root)
    (projectile-project-root)))
(setq consult-project-root-function #'mp/get-project-root)
(setq completion-in-region-function #'consult-completion-in-region)
`(lsp-workspace-folders-add ,(mp/get-project-root))

;; Load all projectile's projects to project.el's list
;; projectile-known-projects
;; project--list
