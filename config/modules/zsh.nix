{ config, pkgs, ... }:

{
  imports = [];

  environment.systemPackages = with pkgs; [
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-autocomplete
    zsh-syntax-highlighting
  ];

  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.bash;

  programs.zsh = {

    enable = true;

    interactiveShellInit = with pkgs; ''
      HISTFILE=~/.histfile
      HISTSIZE=1000
      SAVEHIST=1000
      EDITOR=hx

      source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      edit() {
        test -w $1 -a -f $1 && $EDITOR $1 ||\
           read -q "choice?No permissions to edit '$1'! Execute sudoedit [y/n]: " &&\
           {echo ""; sudoedit $1} || echo ""
      }
    '';

    shellAliases = {
      fm = "nnn -dH && test -f ~/.config/nnn/.lastd && . ~/.config/nnn/.lastd; rm -f ~/.config/nnn/.lastd";
      wm = "zellij a || zellij";
      ls = "eza -a --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions";
      ll = "eza -a -1 --color=always --long --icons=always -g -h -U -m";
      cat = "bat --paging=never";
      catp = "bat -P -p";
    };
  };
}
