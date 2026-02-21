{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "qb114514" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
