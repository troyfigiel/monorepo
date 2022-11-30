{
  programs.emacs.init.usePackage = {
    popper-echo = {
      enable = true;
      hook = [ "(after-init . popper-echo-mode)" ];
    };

    popper = {
      enable = true;
      hook = [ "(after-init . popper-mode)" ];
      general = [''
        (:keymaps 'override
         :states '(normal insert visual)
         "C-c c" 'popper-cycle
         "C-c s" 'popper-toggle-latest
         "C-c f" 'popper-toggle-type)
      ''];
      custom = {
        popper-reference-buffers = ''
          '("^\\*eshell.*\\*$" eshell-mode
            "^\\*shell.*\\*$" shell-mode
            "^\\*term.*\\*$" term-mode
            "^\\*vterm.*\\*$" vterm-mode)
        '';
        popper-window-height = "15";
      };
    };
  };
}
