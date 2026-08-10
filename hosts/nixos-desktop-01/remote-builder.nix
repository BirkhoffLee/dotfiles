# Forward every build off this host and onto nixos-server-01.
#
# This VM is 4 vCPU / 7 GiB with a 64 GiB /nix/store that already runs ~85%
# full, which makes it a bad place to compile a GNOME closure. nixos-server-01
# is 8 vCPU / 23 GiB, has the store paths cached already, and is the host that
# pushes to birkhoff.cachix.org.
#
# Doing it here rather than on the Mac keeps deploy-rs's `remoteBuild = true`
# intact: deploy hands the derivation to this node, this node's daemon hands the
# actual builds to nixos-server-01 over the LAN, and the closure never transits
# the Mac. Both VMs live on the same PVE host (homelab-nuc), so that hop is
# essentially free.
#
# `nix.buildMachines` is the right option on NixOS: the Determinate NixOS module
# leaves `nix.enable` alone, so the stock nix module still generates
# /etc/nix/machines. Note this does NOT hold on darwin, where
# `determinateNix.enable` forces `nix.enable = false` and the whole nix-darwin
# nix module — /etc/nix/machines included — stops being generated; there the
# equivalent is `determinateNix.buildMachines`.
#
# Trade-off, accepted deliberately: with `max-jobs = 0` this host cannot build
# anything on its own. If nixos-server-01 is down, builds here fail outright
# with "unable to start any build" rather than falling back to local compilation.
{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "nixos-server-01.hippo-hexatonic.ts.net";
        protocol = "ssh-ng";
        systems = [ "x86_64-linux" ];
        sshUser = "root";

        # Reuses this host's pre-seeded SSH host key as the client identity, so
        # there is no extra key to provision: it is deployed declaratively from
        # the private `secrets` input (see networking.nix) and is already root
        # owned, 0600, and stable across rebuilds. The matching public key is
        # authorized for root on nixos-server-01.
        sshKey = "/etc/ssh/ssh_host_ed25519_key";

        maxJobs = 4;

        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];

        # base64 -w0 /etc/ssh/ssh_host_ed25519_key.pub on nixos-server-01.
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9STFZFSlQzUDNWaDkyYlVyWi9uQlRld0crS0JaRld1Nk82VDR1dmErR00gCg==";
      }
    ];

    settings = {
      # The whole point: 0 local build slots, so every derivation is handed to
      # the builder above instead of being compiled on this VM.
      max-jobs = 0;

      # Let the builder pull dependencies from the caches itself.
      builders-use-substitutes = true;
    };
  };
}
