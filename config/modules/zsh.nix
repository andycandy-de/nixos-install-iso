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

      _fn_test_rwx() {
        local rwx=$1
        local file=$2

        if [[ $rwx =~ "r" ]] && [[ ! -r $file ]]; then
          return 1
        fi

        if [[ $rwx =~ "w" ]] && [[ ! -w $file ]]; then
          return 1
        fi

        if [[ $rwx =~ "x" ]] && [[ ! -x $file ]]; then
          return 1
        fi

        return 0
      }

      _fn_open() {
        local cmd_alias=$1
        local permissions=$2
        local command=$3
        local file=$4

        if [[ -z $file ]]; then
          file=$(FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --type f" fzf --preview "bat -n --color=always --line-range :500 {}")
        fi

        if [[ -z $file ]]; then
          return $?
        fi

        if [[ ! -f $file ]]; then
          echo "The file '$file' does not exists!"
          return 1
        fi

        if _fn_test_rwx $permissions $file; then
          eval "$command $file"
          return $?
        else
          echo "Permissions '$permissions' are required!"
          read -q "choice?Execute '$cmd_alias $file' with sudo [y/n]: "
          echo ""
          if [[ $choice == "y" ]]; then
            eval "sudo $command $file"
            return $?
          fi
          return 1
        fi
      }

      _edit() {
        _arguments -C \
          "1:file:_files"
      }

      edit() {
        _fn_open "edit" "w" "$EDITOR" $1
        return $?
      }

      _show() {
        _arguments -C \
          "1:file:_files"
      }

      show() {
        _fn_open cat r 'bat --paging=never' $1
        return $?
      }

      _shop() {
        _arguments -C \
          "1:file:_files"
      }

      shop() {
        _fn_open cat r 'bat -P -p' $1
        return $?
      }

      autoload -Uz compinit
      compinit

      compdef _edit edit
      compdef _show show
      compdef _shop shop
      '';

    shellAliases = {
      fm = "nnn -dH && test -f ~/.config/nnn/.lastd && . ~/.config/nnn/.lastd; rm -f ~/.config/nnn/.lastd";
      wm = "zellij a || zellij";
      ls = "eza -a --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions";
      ll = "eza -a -1 --color=always --long --icons=always -g -h -U -m";
    };
  };
}
