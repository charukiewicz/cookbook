{
  # Registers a systemd unit as a oneshot that runs an
  # arbitrary script. Useful for system setup tasks.
  systemd.services.foo = {
    script = ''
      echo hello
    '';
    wantedBy = [ 'multi-user.target' ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
