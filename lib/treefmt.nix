{
  projectRootFile = ".git/config";
  enableDefaultExcludes = true;
  settings = {
    global.excludes = [
      "npins/**"
      "*.txt"
    ];
  };
  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt.enable = true;
  };
}
