;;; -*- lexical-binding: t -*-

(use-package dired
  :straight (:type built-in)
  :general
  ("s-d" 'dired-jump))

(use-package dired-hacks-utils
  :custom (dired-utils-format-information-line-mode 1))

;; TODO: With dired-single I can give dired a buffer name it always keeps.
;; Is this something useful for my workflow?
(use-package dired-single
  :after (dired evil-collection)
  :general
  (:states 'normal
   :keymaps 'dired-mode-map
   "h" 'dired-single-up-directory
   ;; I like going down directories like this, but not if
   ;; I accidentally open the file in another buffer.
   ;; TODO: Can I run dired-single-buffer only for directories?
   "l" 'dired-single-buffer))

;; Most of the time I do not want to change or see my dotfiles.
;; Seeing them should be a keypress away though, so as to not
;; have too much friction.
(use-package dired-hide-dotfiles
  :after (dired evil-collection)
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :general
  (:states 'normal
   :keymaps 'dired-mode-map
   "H" 'dired-hide-dotfiles-mode))

;; IDEA: Can I already view images inline with dired?
;; If not, should I set up image-dired?
(use-package dired-open
  :after dired
  :custom
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (dired-open-extensions '(("png" . "feh")
			   ("mkv" . "mpv"))))
(use-package dired-rainbow
  :after dired
  :config
  ;; TODO: There is a lot to potentially fix with these colourings.
  ;; For example, why is .el under compiled instead of interpreted?
  ;; Nonetheless, it is a good start.
  (dired-rainbow-define-chmod
   directory "#6cb2eb"
   "d.*")
  (dired-rainbow-define
   html "#eb5286"
   ("css" "less" "sass" "scss" "htm"
    "html" "jhtm" "mht" "eml" "mustache"
    "xhtml"))
  (dired-rainbow-define
   xml "#f2d024"
   ("xml" "xsd" "xsl" "xslt" "wsdl"
    "bib" "json" "msg" "pgn" "rss"
    "yaml" "yml" "rdata" "conf"))
  (dired-rainbow-define
   document "#9561e2"
   ("docm" "doc" "docx" "odb" "odt"
    "pdb" "pdf" "ps" "rtf" "djvu"
    "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define
   markdown "#ffed4a"
   ("org" "etx" "info" "markdown" "md"
    "mkd" "nfo" "pod" "rst" "tex"
    "textfile" "txt"))
  (dired-rainbow-define
   database "#6574cd"
   ("xlsx" "xls" "csv" "accdb" "db"
    "mdb" "sqlite" "nc"))
  (dired-rainbow-define
   media "#de751f"
   ("mp3" "mp4" "MP3" "MP4" "avi"
    "mpeg" "mpg" "flv" "ogg" "mov"
    "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define
   image "#f66d9b"
   ("tiff" "tif" "cdr" "gif" "ico"
    "jpeg" "jpg" "png" "psd" "eps"
    "svg"))
  (dired-rainbow-define
   log "#c17d11"
   ("log"))
  (dired-rainbow-define
   shell "#f6993f"
   ("awk" "bash" "bat" "sed" "sh"
    "zsh" "vim"))
  (dired-rainbow-define
   interpreted "#38c172"
   ("py" "ipynb" "rb" "pl" "t"
    "msql" "mysql" "pgsql" "sql" "r"
    "clj" "cljs" "scala" "js" "nix"))
  (dired-rainbow-define
   compiled "#4dc0b5"
   ("asm" "cl" "lisp" "el" "c"
    "h" "c++" "h++" "hpp" "hxx"
    "m" "cc" "cs" "cp" "cpp"
    "go" "f" "for" "ftn" "f90"
    "f95" "f03" "f08" "s" "rs"
    "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define
   executable "#8cc4ff"
   ("exe" "msi"))
  (dired-rainbow-define
   compressed "#51d88a"
   ("7z" "zip" "bz2" "tgz" "txz"
    "gz" "xz" "z" "Z" "jar"
    "war" "ear" "rar" "sar" "xpi"
    "apk" "xz" "tar"))
  (dired-rainbow-define
   packaged "#faad63"
   ("deb" "rpm" "apk" "jad" "jar"
    "cab" "pak" "pk3" "vdf" "vpk"
    "bsp"))
  (dired-rainbow-define
   encrypted "#ffed4a"
   ("gpg" "pgp" "asc" "bfe" "enc"
    "signature" "sig" "p12" "pem"))
  (dired-rainbow-define
   fonts "#6cb2eb"
   ("afm" "fon" "fnt" "pfb" "pfm"
    "ttf" "otf"))
  (dired-rainbow-define
   partition "#e3342f"
   ("dmg" "iso" "bin" "nrg" "qcow"
    "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define
   vc "#0074d9"
   ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod
   executable-unix "#38c172"
   "-.*x.*"))

;; This gives behaviour similar to what you see for example on GitHub and GitLab
;; where a directory `foo/' containing a single file `bar' is shortened to
;; `foo/bar'.
(use-package dired-collapse
  :after dired
  :config (dired-collapse-mode 1))

;; I prefer dired-ranger over ranger, because dired is actually built-in.
;; On top of that, it is quite good and has a lot of extensions.
(use-package dired-ranger
  :general
  (:states 'normal
   :keymaps 'dired-mode-map
   "y" 'dired-ranger-copy
   "p" 'dired-ranger-paste
   ;; IDEA: How should I bind `dired-ranger-move'? Is "X" the best binding?
   "X" 'dired-ranger-move))

(use-package treemacs
  :after solaire-mode)

(provide 'config/01_directory)
