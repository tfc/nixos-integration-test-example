{
  name = "An awesome test.";

  nodes = {
    machine1 = { pkgs, ... }: {
      # Empty config sets some defaults
    };
    machine2 = { pkgs, ... }: { };
  };

  interactive.nodes.machine1 = { ... }: {
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";
    users.extraUsers.root.initialPassword = "";
    virtualisation.forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];
  };

  testScript = ''
    machine1.wait_for_unit("network-online.target")
    machine2.wait_for_unit("network-online.target")

    machine1.succeed("ping -c 1 machine2")
    machine2.succeed("ping -c 1 machine1")
  '';
}
