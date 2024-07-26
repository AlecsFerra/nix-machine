{ pkgs, ... }: 
{
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
	caps)

      (defalias
	  escctrl (tap-hold 200 200 esc lctrl))

      (deflayer base
	@escctrl)
    '';
  };
}
