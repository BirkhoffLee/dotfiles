{ home, ... }:

# This is the 1Password SSH agent config file, which allows you to customize the
# behavior of the SSH agent running on this machine.
#
# You can use it to:
# * Enable keys from other vaults than the Private vault
# * Control the order in which keys are offered to SSH servers
#
# EXAMPLE
#
# By default, all keys in your Private vault(s) are enabled:
#
#  [[ssh-keys]]
#  vault = "Private"
#
# You can enable more keys by adding more `[[ssh-keys]]` entries.
# For example, to first enable item "My SSH Key" from "My Custom Vault":
#
#  [[ssh-keys]]
#  item = "My SSH Key"
#  vault = "My Custom Vault"
#
#  [[ssh-keys]]
#  vault = "Private"
#
# You can test the result by running:
#
#  SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ssh-add -l
#
# More examples can be found here:
#  https://developer.1password.com/docs/ssh/agent/config

{
  home.file.".config/1Password/ssh/agent.toml" = {
    text = ''
      # Managed by home-manager

      [[ssh-keys]]
      item = "2mjyhu76qqmeex23n35wzpj4ri"

      [[ssh-keys]]
      item = "xoa6h6kmwwlcznc26euhrqke3q"

      [[ssh-keys]]
      item = "lgpo25nfmotwf2inm67a7nboeu"

      [[ssh-keys]]
      item = "4rd5wm4adrtnmpnkxzi6baozh4"
    '';
  };
}
