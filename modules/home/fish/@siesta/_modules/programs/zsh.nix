{
  self,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    initContent = ''
      source $HOME/.zshrc.unix
    '';
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
