{ pkgs, ... }: {
  programs.ironbar = {
    enable = true;
    config = {
      name = "bar";
      position = "top";
      anchor_to_edges = true;
      center = [
        {
          type = "clock";
          justify = "center";
        }
      ];
    };
  };
}
