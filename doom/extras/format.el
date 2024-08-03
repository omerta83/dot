;;; extras/format.el -*- lexical-binding: t; -*-

(reformatter-define biome-format
  :program "biome"
  :args `("format" "--stdin-file-path" ,buffer-file-name)
  :lighter "Biome")
(reformatter-define prettier-format
  :program "prettier"
  :args `("--stdin-filepath" ,buffer-file-name)
  :lighter "Prettier")

;; Check if biome.json exists, then use biome to format, otherwise, use default
(defun format-buffer ()
  "Format current buffer"
  (interactive)
  (if (project-file-exists-p! "biome.json")
      (biome-format-buffer)
    (format-all-ensure-formatter)
    (format-all-region-or-buffer)))
(map! :leader
      :desc "Format current buffer"
      :n
      "c f" 'format-buffer)
