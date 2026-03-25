get_mysql_records() {
  local version=$1
  local OS=$(uname -s)

  case "$(uname -m)" in
    x86_64)
      ARCH="amd64"
      ;;
    *)
      ARCH="$(uname -m)"
      ;;
  esac

  # Darwin can run x86 and arm versions, do don't be specific about it.
  # If there is a native version, it will be selected properly during the
  # install phase
  if [[ "${OS}" == "Darwin" ]]; then
    ARCH="[^\"]*"
  fi

  jq --arg os "$OS" --arg arch "$ARCH" \
    --arg version "$version" \
      '.Tarballs[] |
      select(.version == $version and
      .OS == $os and
      .arch == $arch and
      .flavor == "mysql" and
      .minimal == false)' \
      "${SCRIPT_DIR}/../tarball_list.json"
}
