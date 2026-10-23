# Go
export GO_HOME="$WORKSPACE_ENV/go"
export GOPATH="$GO_HOME/packages"
append_path "$GO_HOME/main/bin"
append_path "$GOPATH/bin"
