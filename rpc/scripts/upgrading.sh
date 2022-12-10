# steps:
# 1. stop chain & delete /var/log/chain.err.log
# 2. build an run old version with "-X github.com/tendermint/tm-db.ForceSync=1"
# 3. watch for UPGRADE in /var/log/chain.err.log
# 4. make sure chain stopped
# 5. build and run new version
# 6. check synced

version_new="v6.0.1"

########################################################################################################################
# functions

# 1. stop chain & delete /var/log/chain.err.log
step_1 () {
  echo "step 1"
  supervisorctl stop chain
  sleep 5;

  rm "/var/log/chain.err.log"
}

# 2. build an run old version with "-X github.com/tendermint/tm-db.ForceSync=1"
step_2 () {
  echo "step 2"

  # copy from snapshot_restore.sh


}

step_3 () {
  echo "step 3"
}

step_4 () {
  echo "step 4"
}

step_5 () {
  echo "step 5"
}

step_6 () {
  echo "step 6"
}

########################################################################################################################
# main

cd $HOME
source $HOME/env.sh

step_1

step_2