cd $HOME

if [[ -z $upgrading ]]; then
  git clone --single-branch --branch $version $git_repo
  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
else
  repo_name=$(basename $git_repo |cut -d. -f1)
  cd $repo_name
  git reset --hard
  git fetch --all --tags
  git checkout "$p_version"
fi

go mod edit -replace github.com/cosmos/cosmos-db=github.com/notional-labs/cosmos-db@v1.0.0
go mod tidy
go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...