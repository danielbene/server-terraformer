cd docker_compose
docker-compose -f ctl_comp.yml -p ctl_stack down
docker-compose -f data_comp.yml -p data_stack down
docker-compose -f monitoring_comp.yml -p monitoring_stack down
docker-compose -f `grep -m 1 OPENEATS_DIR .env | cut -d '=' -f 2-`/OpenEats/docker-prod.yml down