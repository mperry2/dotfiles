;; ~/.emacs
;;
;; $Id$

;; Add ~/elisp to load path
(setq load-path (cons (expand-file-name "~/elisp") load-path))

(cond ((string-match "XEmacs\\|Lucid" emacs-version)
       ;; Load XEmacs configuration files
       (load "xemacs-path")
       (load "xemacs-variables")
       (load "xemacs-general")
       (load "xemacs-modes")
       (load "xemacs-packages")
       (if (> emacs-major-version 19)
           (load "xemacs-java")
         )
       (load "xemacs-c")
       (if (> emacs-major-version 19)
           (load "xemacs-perl")
         )
       (load "xemacs-keys")
       (message "XEmacs startup files loaded successfully.")
       )
      (t
       ;; Start server for emacsclient
       ;(server-start)
       ;(message "Started emacs server successfully.")
       ;; Load GNU Emacs configuration files
       (load "xemacs-path")
       (load "emacs-variables")
       (load "emacs-general")
       (load "xemacs-modes")
       (load "emacs-packages")
       (if (> emacs-major-version 19)
           (load "xemacs-java")
         )
       (load "emacs-c")
       (if (> emacs-major-version 19)
           (load "xemacs-perl")
         )
       (load "emacs-keys")
       (message "GNU Emacs startup files loaded successfully.")
       )
      )

;; Reload saved desktop
(load "desktop")
(desktop-load-default)
(desktop-read)





