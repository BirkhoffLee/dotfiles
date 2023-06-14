{
  editorconfig = {
    enable = true;

    settings = {
      "*" = {
        "charset" = "utf-8";
        "end_of_line" = "lf";
        "insert_final_newline" = "true";
        "indent_style" = "space";
        "indent_size" = 2;
      };

      "*.py" = {
        "indent_size" = 4;
      };

      "Makefile" = {
        "indent_style" = "tab";
      };
    };
  };
}
