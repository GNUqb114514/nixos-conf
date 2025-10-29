let
  priv2key = priv: map (x: builtins.readFile ./keys/${priv}/${x}) (builtins.attrNames (builtins.readDir ./keys/${priv}));
  full-access-keys = priv2key "full-access";
  priv2key2 = priv: priv2key priv ++ full-access-keys;
in {
  "github-ssh.age" = {
    publicKeys = full-access-keys;
    armor = true;
  };
}
