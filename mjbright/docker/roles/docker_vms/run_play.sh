#!/usr/bin/env bash

#
# Script to demonstrate usage of the mjbright.docker.docker-vms role
#
# USAGE:
#     run_play.sh -lab 3 5   # Create 5 containers lab3-1, .. lab3-5
#                            # - on a subnet lab3-net using 172.32.3.0/24
#                            # - IPs start at .11 to prevent clash with .1 address
#
#     run_play.sh -clean lab3   # Cleanup all 'lab3' containers and network
#
#     run_play.sh -list  lab3   # List    all 'lab3' containers and network
#

die() { echo "$0: die - $*" >&2; exit 1; }

case "$1" in
    -clean) shift; PREFIX=$1
            [ -z "$PREFIX" ] && die "PREFIX missing:  -clean <PREFIX>"
            set -x
                ansible-playbook -e PREFIX=$PREFIX -t clean -e clean=true \
                    -i localhost, play-docker-vms.yaml
            set +x
            ;;

       -a*) docker ps -a; docker network ls
            ;;

       -l|-list) shift; PREFIX=$1
            if [ ! -z "$PREFIX" ]; then
                CONTAINERS=$( docker ps -a | grep ${PREFIX}- | awk '{ print $NF; }' )
                for C in $CONTAINERS; do
                    docker inspect $C | grep v4
                done
          
                docker network inspect ${PREFIX}-net |& grep Subnet
            else
                docker ps -a
                #docker inspect | grep v4
                docker network ls
            fi
            ;;

      -lab) shift; LN=$1; PREFIX=lab$LN; shift; NUM_VMS=$1
            set -x
                ansible-playbook -e PREFIX=$PREFIX -e NUM_VMS=$NUM_VMS -e SUBNET_PART="172.32.$LN" \
                    -i localhost, play-docker-vms.yaml
            set +x
            ;;

        "") set -x; ansible-playbook -i localhost, play-docker-vms.yaml ; set +x;;

         *) die "Unknown option '$1'";;
esac

