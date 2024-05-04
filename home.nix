{ config, pkgs, ... }: {
home.username = "gidrex";
home.homeDirectory = "/home/gidrex";

# Packets
home.packages = with pkgs; [
	firefox

];
home.file = {

};

home.sessionVariables = {
    # EDITOR = "emacs";
};

# Let Home Manager install and manage itself.
home.stateVersion = "23.11";
programs.home-manager.enable = true;
}
