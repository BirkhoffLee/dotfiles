{
  # disable logging
  home.file.".config/llm/logs-off" = {
    text = "";
  };

  # convert image to markdown
  home.file.".config/llm/templates/md.yaml" = {
    text = ''
      model: openrouter/qwen/qwen3-vl-32b-instruct
      options:
        temperature: 0.0
      system: |
        Convert all texts in the attached images to raw Markdown code (for the math expressions within, use inline latex).

        ## Math Expressions

        Any math equations or representations found in the images should be directly written as inline LaTeX within the Markdown code.

        Instead of using brackets or parentheses, wrap the LaTeX expressions with a single dollar sign $$ for inline LaTeX, and double dollar sign $$$$ for a complete latex block. Do not add whitespaces between dollar signs and the actual latex expressions.

        Anything else should be written in Markdown format instead of LaTeX code.

        ## Strictly Prohibited

        Do not output in a code block.
        Do not respond anything else other than the converted texts.
    '';
  };
}
