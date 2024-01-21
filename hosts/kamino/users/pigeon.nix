{...}: {
  imports = [
    ../../../users/common
  ];

  manual = {
    html.enable = false;
    manpages.enable = false;
    json.enable = false;
  };
}
