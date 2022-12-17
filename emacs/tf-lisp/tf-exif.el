;;; tf-exif.el --- Set modification timestamps based on Exif timestamps -*- lexical-binding: t -*-

;; Copyright (C) 2022-2022  Troy Figiel

;; Author: Troy Figiel <troy.figiel@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.2") (denote "1.1.0") (image-dired "0.4.11"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;; This file is NOT part of GNU Emacs.

;;; Commentary:
;;
;; The interface of tf-exif.el consists of two functions. To set the
;; last modification timestamp of a picture to its Exif timestamp,mark
;; your file (or multiple files) in dired and call
;; `tf-exif-set-last-modification-marked-files'. If a file already has
;; an identifier created by `denote', you can overwrite this
;; identifier with `tf-exif-overwrite-identifier-marked-files'. Note
;; that this will break existing `denote' links to these
;; pictures,since it changed to file identifier.
;;
;; A potential workflow is to first use
;; `tf-exif-set-last-modification-marked-files' to adjust the
;; modification timestamp for a set of marked files and to then run
;; `denote-dired-rename-marked-files'.
;;
;; If some pictures do not have the Exif timestamp as their
;; identifier, for example, because
;; `denote-dired-rename-marked-files'was used before
;; `tf-exif-set-last-modification-marked-files',`tf-exif-overwrite-identifier-marked-files'
;; can be used to correct this. This is a no-op if the Exif timestamp
;; and file identifier already match or if no Exif timestamp could be
;; found.
;;
;; This can be a preferred workflow over using the last modification
;; timestamp, because it can sometimes happen that two or more
;; pictures have the same last modification timestamps. More
;; importantly, the embedded Exif timestamp is a more meaningful
;; timestamp when you use the `denote' file naming convention as a way
;; to search through your pictures. As long as the pictures are taken
;; with an interval of more than a second, the Exif timestamp will be
;; unique.
(require 'denote)
(require 'image-dired)

;; TODO: The function `image-dired-get-exif-data' has been obsoleted
;; in Emacs 29.1. I need to call `exif-parse-file' and `exif-field'
;; which are now built-in functions to Emacs.

;; TODO: Extract out a function that reads marked files and applies a
;; function on each file.
;; (defun tf-exif--act-on-marked-files (fun format files)
;;   "FUN takes ..."
;;   (dolist (f (dired-get-marked-files t))
;;     (let ((ts (tf-exif--timestamp-from-exif-data
;;	       format
;;	       (expand-file-name f))))
;;       (fun ts f))))

;; TODO: Sometimes when I delete a directory, tf-exif keeps failing
;; because it seems to be stuck in that directory when it is trying to
;; rename. What is happening exactly and how can I mitigate this?

;;;###autoload
(defun tf-exif-set-last-modification-marked-files ()
  (interactive)
  (dolist (f (dired-get-marked-files t))
    (let ((ts (tf-exif--timestamp-from-exif-data
	       "%Y%m%d%H%M.%S"
	       (expand-file-name f))))
      (when ts
	(shell-command (concat "touch -t" ts " \"" f "\""))
	(message
	 (concat "Updated last modification timestamp of " f " to " ts))))))

;;;###autoload
(defun tf-exif-overwrite-identifier-marked-files ()
  (interactive)
  (dolist (f (dired-get-marked-files t))
    (let ((ts (tf-exif--timestamp-from-exif-data
	       denote-id-format
	       (expand-file-name f)))
	  (id (denote-extract-id-from-string f)))
      (if (not ts)
	  (message (concat "No Exif timestamp found for " f))
	(if (string= id ts)
	    (message (concat "File identifier and Exif timestamp match for " f))
	  (tf-exif--overwrite-file-identifier f ts))))))

(defun tf-exif--overwrite-file-identifier (file timestamp)
  (let ((n (replace-regexp-in-string denote-id-regexp timestamp file)))
    (rename-file file n))
  (message (concat "Overwriting file identifier of " file " with " timestamp)))

(defun tf-exif--format-exif-timestamp (format exif-timestamp)
  "Format a TIMESTAMP of the form %Y:%m:%d %H:%M:%S to the format
%Y%m%d%H%m.%s needed by the touch program."
  (let* ((dt (split-string exif-timestamp))
	 (ts (concat (replace-regexp-in-string ":" "" (cl-first dt))
		     "T"
		     (cl-second dt))))
    (format-time-string format (date-to-time ts))))

;; TODO: We do not need to explicitly depend on image-dired if we can
;; use exiftool directly as a command line tool.
(defun tf-exif--timestamp-from-exif-data (format file)
  "Extract the Date/Time Original exif tag from FILE if it can be
found. Otherwise, an empty string is returned."
  (require 'image-dired)
  (let ((ts (image-dired-get-exif-data file "DateTimeOriginal")))
    (if (string= "" ts) nil (tf-exif--format-exif-timestamp format ts))))

(provide 'tf-exif)
;;;; tf-exif.el ends here
