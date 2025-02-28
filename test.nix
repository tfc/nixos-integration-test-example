{
  name = "An awesome test.";

  nodes = {
    machine1 = { pkgs, ... }: {
      # Empty config sets some defaults
    };
    machine2 = { pkgs, ... }: { };
  };

  interactive.nodes.machine1 = import ./debug-host-module.nix;

  testScript = ''
    start_all()
    for m in [machine1, machine2]:
      m.systemctl("start network-online.target")
      m.wait_for_unit("network-online.target")

    machine1.succeed("ping -c 1 machine2")
    machine2.succeed("ping -c 1 machine1")
  '';
}
