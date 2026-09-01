# mergiraf — syntax-aware merge driver for git
# @see https://mergiraf.org
{
  programs.mergiraf = {
    enable = true;

    # Registers the `mergiraf` merge driver in git config and adds
    # `* merge=mergiraf` to the global gitattributes.
    # Set explicitly: the default flips in home-manager 26.05.
    enableGitIntegration = true;

    # jujutsu is not used here.
    enableJujutsuIntegration = false;
  };
}
