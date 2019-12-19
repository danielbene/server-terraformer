#!/bin/bash

/home/daniel/configs/monitoring/textfile-collectors/node-exporter-textfile-collector-scripts/smartmon.sh | sponge /var/lib/node_exporter/textfile_collector/smartmon.prom
