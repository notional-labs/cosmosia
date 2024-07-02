cd $HOME

#if [[ -z $upgrading ]]; then
#  git clone --single-branch --branch $version $git_repo
#  repo_name=$(basename $git_repo |cut -d. -f1)
#  cd $repo_name
#else
#  repo_name=$(basename $git_repo |cut -d. -f1)
#  cd $repo_name
#  git reset --hard
#  git fetch --all --tags
#  git checkout "$p_version"
#fi

# TODO: fix building temporary, got apphash with release/v4.1.x branch, only commit f5b51641c07e7637dc1a9d38477c2a543bcf47aa works
cd $HOME
git clone https://github.com/White-Whale-Defi-Platform/migaloo-chain
cd migaloo-chain
git checkout f5b51641c07e7637dc1a9d38477c2a543bcf47aa

go install -tags pebbledb -ldflags "-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb" ./...
