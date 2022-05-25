
########################################################################################################################
# functions

# args
# @1 start_flags string
# @2 local_peers string
update_start_flags () {
  found_p2p_persistent_peers=false
  new_start_flags=""
  for flag in $start_flags; do
    new_flag="$flag"
    # trim spaces
    new_flag=$(echo "${new_flag}" |xargs)

    if [[ $new_flag == --p2p.persistent_peers* ]]; then
      new_flag="$new_flag,${local_peers}"
      found_p2p_persistent_peers=true
    fi

    if [[ ! -z "$new_start_flags" ]]; then
      new_start_flags="${new_start_flags} "
    fi
    new_start_flags="${new_start_flags}${new_flag}"
  done

  if [[ "$found_p2p_persistent_peers" == false ]]; then
    if [[ ! -z "$new_start_flags" ]]; then
      new_start_flags="${new_start_flags} "
    fi

    new_start_flags="${new_start_flags}--p2p.persistent_peers=${local_peers}"
  fi

  echo "${new_start_flags}"
}


#########################################################################################################################
## testing
#
#echo "**************testing with --p2p.persistent_peers"
#start_flags="--p2p.seeds=c00e2f8ff7f521cc6385dcc4ad4c7053d9895e9e@167.99.194.126:46656 --p2p.persistent_peers=ca133187b37b59d2454812cfcf31b6211395adec@167.99.194.126:16656,1c7e014b65f7a3ea2cf48bffce78f5cbcad2a0b7@13.37.85.253:26656,8c64a2127cc07d4570756b61f83af60d34258398@13.37.61.32:26656,9aabe0ac122f3104d8fc098e19c66714c6f1ace9@3.37.140.5:26656,faedef1969911d24bf72c56fc01326eb891fa3b7@63.250.53.45:16656,94ac1c02b4e2ca3fb2706c91a68b8030ed3615a1@35.247.175.128:16656,be2235996b1c785a9f57eed25fd673ca111f0bae@52.52.89.64:26656,f63d15ab7ed55dc75f332d0b0d2b01d529d5cbcd@212.71.247.11:26656,f5597a7ed33bc99eb6ba7253eb8ac76af27b4c6d@138.201.20.147:26656"
#local_peers="42bf9fc1eda78eba131fd7ff2c114ba6a11410ff@cosmoshub.1.he0exgh6f5unzvvcf8n5fkdxr.cosmosia.:26656,a6293413e0e95859b4a0c20d475857b718222483@cosmoshub.2.hfhcfpb92xwf5cl8yo6gzmlwl.cosmosia.:26656"
#new_start_flags=$(update_start_flags "$start_flags" "local_peers")
#echo "new_start_flags=${new_start_flags}"
#
####
#echo "**************testing without --p2p.persistent_peers"
#start_flags="--p2p.seeds=c00e2f8ff7f521cc6385dcc4ad4c7053d9895e9e@167.99.194.126:46656"
#local_peers="42bf9fc1eda78eba131fd7ff2c114ba6a11410ff@cosmoshub.1.he0exgh6f5unzvvcf8n5fkdxr.cosmosia.:26656,a6293413e0e95859b4a0c20d475857b718222483@cosmoshub.2.hfhcfpb92xwf5cl8yo6gzmlwl.cosmosia.:26656"
#new_start_flags=$(update_start_flags "$start_flags" "local_peers")
#echo "new_start_flags=${new_start_flags}"