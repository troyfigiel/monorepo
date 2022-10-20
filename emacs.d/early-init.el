;;; -*- lexical-binding: t -*-

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

(setq native-comp-deferred-compilation nil)
(setq package-enable-at-startup nil)

;; All straight variable data (repositories, builds, etc.) should go to var/.
(setq straight-base-dir (expand-file-name "var/" user-emacs-directory))

;; Move the lock file to straight-lock.el in the user-emacs-directory.
(setq straight-profiles `((nil . ,(expand-file-name "straight-lock.el" user-emacs-directory))))

;; We want straight to pull from the master, i.e. stable branch.
;; Although this is set by default after bootstrapping straight, we use this
;; to grab the bootstrap script from the master branch of straight.
(setq straight-repository-branch "master")

;; Bootstrap straight.el. Do not download it again if the file already exists.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" straight-base-dir))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 (concat "https://raw.githubusercontent.com/radian-software/straight.el/"
		 (file-name-as-directory straight-repository-branch)
		 "install.el")
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Right after finishing initialization, ensure the lock file is up to date.
(add-hook 'after-init-hook #'straight-freeze-versions)
