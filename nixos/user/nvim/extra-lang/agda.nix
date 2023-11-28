{ pkgs, lib, ... }:
let 
  luaUtf8 = "${lib.getBin pkgs.luajitPackages.luautf8}/lib/lua/5.1/lua-utf8.so";
in
{
  programs.nixvim = {
    plugins.packer = {
      enable = true;
      plugins = [
        "ashinkarov/nvim-agda"
      ];
    };

   extraConfigLua = ''
    package.cpath = "${luaUtf8};" .. package.cpath
   '';
  };
}
