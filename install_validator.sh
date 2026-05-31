#!/bin/bash

#LOC=slc
#SHRED_RECEIVER=64.130.53.8:1002

LOC=ny
SHRED_RECEIVER=141.98.216.96:1002

sudo ./scripts/init_validator.sh \
  --use-ramdisk-for-account False \
  --swap-file-size-gb 128 \
  --jito-enable True \
  --jito-block-engine-url https://$LOC.mainnet.block-engine.jito.wtf \
  --jito-relayer-url http://127.0.0.1:11226 \
  --jito-bam-url http://pittsburgh.mainnet.bam.jito.wtf \
  --jito-receiver-addr $SHRED_RECEIVER