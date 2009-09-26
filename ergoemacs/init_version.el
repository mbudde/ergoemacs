; -*- coding: utf-8 -*-

;; Most of the code in this file is a copy from GNU/Emacs startup.el

(defconst ergoemacs-version "1.6")
(defconst ergoemacs-url "http://code.google.com/p/ergoemacs/")
(defconst ergoemacs-url-authors "http://code.google.com/p/ergoemacs/wiki/AuthorsAndAcknowledgement")
(defconst ergoemacs-url-contrib "http://code.google.com/p/ergoemacs/wiki/HowToContribute")

;; ErgoEmacs version
(defun emacs-version (&optional here) "\
Return string describing the version of Emacs that is running.
If optional argument HERE is non-nil, insert string at point.
Don't use this function in programs to choose actions according
to the system configuration; look at `system-configuration' instead."
  (interactive "P")
  (let ((version-string
         (format "GNU Emacs %s (%s%s%s) of %s on %s\nErgoEmacs distribution %s"
		 emacs-version
		 system-configuration
		 (cond ((featurep 'motif)
			(concat ", " (substring motif-version-string 4)))
		       ((featurep 'gtk)
			(concat ", GTK+ Version " gtk-version-string))
		       ((featurep 'x-toolkit) ", X toolkit")
		       ((featurep 'ns)
			(format ", NS %s" ns-version-string))
		       (t ""))
		 (if (and (boundp 'x-toolkit-scroll-bars)
			  (memq x-toolkit-scroll-bars '(xaw xaw3d)))
		     (format ", %s scroll bars"
			     (capitalize (symbol-name x-toolkit-scroll-bars)))
		   "")
		 (format-time-string "%Y-%m-%d" emacs-build-time)
		 emacs-build-system 
		 ergoemacs-version)))
    (if here
        (insert version-string)
      (if (interactive-p)
          (message "%s" version-string)
        version-string))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fancy splash screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq fancy-startup-text
  '((:face (variable-pitch (:foreground "red"))
     "Welcome to "
     :link ("ErgoEmacs"
	    (lambda (button) (browse-url ergoemacs-url))
	    "ErgoEmacs home page")
     " based on "
     :link ("GNU Emacs"
	    (lambda (button) (browse-url "http://www.gnu.org/software/emacs/"))
	    "GNU Emacs home page")
     ".\n\n"
     :face variable-pitch
     ;; :link ("ErgoEmacs Tutorial" (lambda (button) (help-with-tutorial)))
     ;; "\tLearn basic keystroke commands"
     :link ("View Emacs Manual" (lambda (button) (info-emacs-manual)))
     "\tView the Emacs manual using Info\n"
     :link ("Absence of Warranty" (lambda (button) (describe-no-warranty)))
     "\tErgoEmacs comes with "
     :face (variable-pitch (:slant oblique))
     "ABSOLUTELY NO WARRANTY\n"
     :face variable-pitch
     :link ("Copying Conditions" (lambda (button) (describe-copying)))
     "\tConditions for redistributing and changing Emacs\n"
     "\n")))

(setq fancy-about-text
  '((:face (variable-pitch (:foreground "red"))
     "This is "
     :link ("ErgoEmacs"
	    (lambda (button) (browse-url ergoemacs-url))
	    "ErgoEmacs home page")
     " based on "
     :link ("GNU Emacs"
	    (lambda (button) (browse-url "http://www.gnu.org/software/emacs/"))
	    "GNU Emacs home page")
     ".\n\n"
     (lambda () (emacs-version))
     "\n\n"
     :face variable-pitch
     :link ("ErgoEmacs Authors"
	    (lambda (button) (browse-url ergoemacs-url-authors)))
     "\tErgoEmacs contributors\n"
     :link ("GNU/Emacs Authors"
	    (lambda (button)
	      (view-file (expand-file-name "AUTHORS" data-directory))
	      (goto-char (point-min))))
     "\tMany people have contributed code included in GNU Emacs\n"
     :link ("Contributing"
	    (lambda (button) (browse-url ergoemacs-url-contrib)))
     "\tHow to contribute improvements to ErgoEmacs\n"
     "\n"
     :link ("Absence of Warranty" (lambda (button) (describe-no-warranty)))
     "\tErgoEmacs comes with "
     :face (variable-pitch (:slant oblique))
     "ABSOLUTELY NO WARRANTY\n"
     :face variable-pitch
     "\n"
     )))

(defun fancy-splash-head ()
  "Insert the head part of the splash screen into the current buffer."
  (let* ((image-file (cond ((stringp fancy-splash-image)
			    fancy-splash-image)
			   ((display-color-p)
			    (cond ((<= (display-planes) 8)
				   (if (image-type-available-p 'xpm)
				       "splash.xpm"
				     "splash.pbm"))
				  ((image-type-available-p 'svg)
				   "splash.svg")
				  ((image-type-available-p 'png)
				   "splash.png")
				  ((image-type-available-p 'xpm)
				   "splash.xpm")
				  (t "splash.pbm")))
			   (t "splash.pbm")))
	 (img (create-image image-file))
	 (image-width (and img (car (image-size img))))
	 (window-width (window-width (selected-window))))
    (when img
      (when (> window-width image-width)
	;; Center the image in the window.
	(insert (propertize " " 'display
			    `(space :align-to (+ center (-0.5 . ,img)))))

	;; Change the color of the XPM version of the splash image
	;; so that it is visible with a dark frame background.
	(when (and (memq 'xpm img)
		   (eq (frame-parameter nil 'background-mode) 'dark))
	  (setq img (append img '(:color-symbols (("#000000" . "gray30"))))))

	;; Insert the image with a help-echo and a link.
	(make-button (prog1 (point) (insert-image img)) (point)
		     'face 'default
		     'help-echo (concat "mouse-2, RET: Browse " ergoemacs-url)
		     'action (lambda (button) (browse-url ergoemacs-url))
		     'follow-link t)
	(insert "\n\n")))))

(defun fancy-startup-tail (&optional concise)
  "Insert the tail part of the splash screen into the current buffer."
  (let ((fg (if (eq (frame-parameter nil 'background-mode) 'dark)
		"cyan" "darkblue")))
    (fancy-splash-insert :face `(variable-pitch (:foreground ,fg))
			 "\nThis is "
			 (emacs-version)
			 "\n"
			 :face '(variable-pitch (:height 0.8))
			 emacs-copyright
			 "\n")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Normal splash screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun normal-splash-screen (&optional startup concise)
  "Display non-graphic splash screen.
If optional argument STARTUP is non-nil, display the startup screen
after Emacs starts.  If STARTUP is nil, display the About screen.
If CONCISE is non-nil, display a concise version of the
splash screen in another window."
  (let ((splash-buffer (get-buffer-create "*About ErgoEmacs*")))
    (with-current-buffer splash-buffer
      (setq buffer-read-only nil)
      (erase-buffer)
      (setq default-directory command-line-default-directory)
      (set (make-local-variable 'tab-width) 8)
      (if (not startup)
	  (set (make-local-variable 'mode-line-format)
	       (propertize "---- %b %-" 'face 'mode-line-buffer-id)))

      (if pure-space-overflow
	  (insert pure-space-overflow-message))

      ;; The convention for this piece of code is that
      ;; each piece of output starts with one or two newlines
      ;; and does not end with any newlines.
      (insert (if startup "Welcome to ErgoEmacs" "This is ErgoEmacs"))
      (insert "\n")

      (normal-about-screen)

      ;; The rest of the startup screen is the same on all
      ;; kinds of terminals.

      (use-local-map splash-screen-keymap)

      ;; Display the input that we set up in the buffer.
      (set-buffer-modified-p nil)
      (setq buffer-read-only t)
      (if (and view-read-only (not view-mode))
	  (view-mode-enter nil 'kill-buffer))
      (if startup (rename-buffer "*ErgoEmacs*" t))
      (goto-char (point-min)))
    (if concise
	(display-buffer splash-buffer)
      (switch-to-buffer splash-buffer))))

(defun normal-about-screen ()
  (insert "\n" (emacs-version) "\n\n")

  (insert "To follow a link, click Mouse-1 on it, or move to it and type RET.\n\n")

  (insert-button "ErgoEmacs Authors"
		 'action
		 (lambda (button) (browse-url ergoemacs-url-authors))
		 'follow-link t)
  (insert "\tErgoEmacs contributors\n")

  (insert-button "GNU/Emacs Authors"
		 'action
		 (lambda (button)
		   (view-file (expand-file-name "AUTHORS" data-directory))
		   (goto-char (point-min)))
		 'follow-link t)
  (insert "\tMany people have contributed code included in GNU Emacs\n")

  (insert-button "Contributing"
		 'action
		 (lambda (button) (browse-url ergoemacs-url-contrib))
		 'follow-link t)
  (insert "\t\tHow to contribute improvements to ErgoEmacs\n\n")

  (insert-button "Absence of Warranty"
		 'action (lambda (button) (describe-no-warranty))
		 'follow-link t)
  (insert "\tErgoEmacs comes with ABSOLUTELY NO WARRANTY\n"))
