; -*- coding: utf-8 -*-

(add-to-list 'load-path (file-name-directory (or load-file-name buffer-file-name)))
(add-to-list 'load-path 
	     (concat (file-name-directory (or load-file-name buffer-file-name)) "../packages"))

;; Tool-bar has to be turned-off as soon as possible so the user cannot see it
(tool-bar-mode 0) ;; Not sure we should have this on. The way it is right now, is rather useless for anyone who would use emacs, and i don't think it really provide any UI improvement because there's the menu already. The icons are rather very ugly. Possibly we can improve the icons, and or add a Close button to it.

;; Load ergoemacs-keybindings minor mode
(load "ergoemacs-keybindings/ergoemacs-mode")
(ergoemacs-mode 1)

;; Load packages
(load "init_load_packages")
(load "init_version")
(load "init_functions")
(load "init_settings")

;; ErgoEmacs shortcuts and menus
(load "init_keybinding")
(load "init_mouse")
(load "init_clean_menus")

;; Turn on Open Recent menu under File menu before "Close" item
;; (Why this code here? because the File menu is initialized
;;  in init_clean_menus.el)
(require 'recentf)
(setq recentf-menu-before "Close")
(setq recentf-save-file "~/.emacs.d/.recentf")
(recentf-mode 1)

;; (server-start) ; this keeps emacs running just one instance. For example, a user double clicks a file, it'll just switch to a existing instance. Not sure this is best approach.
