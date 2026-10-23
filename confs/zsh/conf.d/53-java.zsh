# Java
for _jdk_dir in "$WORKSPACE_ENV"/openjdk/openjdk-*; do
  [ -d "$_jdk_dir" ] && export JAVA_HOME="$_jdk_dir"
done
unset _jdk_dir
append_path "$JAVA_HOME/bin" # Java bin
append_path "$WORKSPACE_ENV/jdtls/latest/bin" # Java LSP
