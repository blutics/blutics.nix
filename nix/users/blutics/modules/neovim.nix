{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = false;
    viAlias = true; vimAlias = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      lua-language-server bash-language-server pyright
      black isort stylua shfmt prettierd
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}

