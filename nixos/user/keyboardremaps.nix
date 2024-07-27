{ pkgs, ... }: 
{
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
	caps)

      (defalias
	  escctrl (tap-hold 250 250 esc lctrl))

      (deflayer base
	@escctrl)
    '';
  };
}
