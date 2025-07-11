{ home, ... }:

{
  # disable logging
  home.file.".config/llm/logs-off" = { text = ""; };
}
