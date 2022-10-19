{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  nativeBuildInputs = [
    emacs
    docker
    direnv
    git
    ripgrep
    pandoc
    texlive.combined.scheme-full
    # General shell niceness
    which
    # For git cloning zettelkasten from GitLab
    openssh
    gnupg
    # To use flyspell
    ispell
    unzip
    # To install packages using asdf
    curl
    cacert
    # TODO: zlib is apparently not enough.
    # I can still not decompress the python binaries.
    zlib
    # Jupyter for ein
    jupyter
    # Archive browsing
    avfs
    # Formatters used with apheleia
    ## Nix
    nixfmt
    ## Python
    black
    ## A ton of other languages...
    nodePackages.prettier
    # Language servers
    ## Python
    python310Packages.python-lsp-server
    #python310Packages.pylsp-mypy
    # pylsp-rope is not packaged yet
    #python310Packages.pylsp-rope
    ## Dockerfile. Unfortunately not in nixpkgs
    # nodePackages.docker-langserver
    ## Terraform
    terraform-ls
    ## SQL
    sqls
    ## Nix
    rnix-lsp
  ];
  shellHook = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
}
