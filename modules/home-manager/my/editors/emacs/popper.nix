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
        ("<f8>" 'popper-toggle-latest
         "<f9>" 'popper-toggle-type)
      ''];
      custom = {
        popper-reference-buffers = ''
          '("shell\\*$"
            "REPL\\*$"
            "\\*Help\\*" help-mode
            "\\*xref\\*"
            "\\*Messages\\*")
        '';
        # popper-window-height = "10";
      };
    };
  };
}
