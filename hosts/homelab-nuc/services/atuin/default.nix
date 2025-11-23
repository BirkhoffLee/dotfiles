{
  # Exposed via Tailscale Services
  services.atuin = {
    enable = true;
    host = "127.0.0.1";
    port = 8010;
    openRegistration = true;
  };
}
