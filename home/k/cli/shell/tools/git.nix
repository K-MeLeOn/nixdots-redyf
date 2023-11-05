{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "kameleon";
    userEmail = "kam.global@pm.me";
    extraConfig = {
      init = {defaultBranch = "main";};
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
