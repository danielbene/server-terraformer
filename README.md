# server-terraformer
This project is an auto builder, so in case of a server failure, I want to be able to clone the full service enverinment as easily as possible.

The main goal of the repo is to give you an idea that how can you build a "terraformer" like this. My guess is that you probaly wont need the exact same services as I, so go ahead and modify it.

The development is in early stage, possibly it will evolve in unpredictable ways. :)

Opinions are welcome.

## Services

Docker  
x11docker  
Portainer  
NodeExporter  
Prometheus  
Grafana  
Samba  
Transmission  
OpenEats  
Lychee  
Kodi  
SimpleDashParticles  

## Setup

*The target OS is **Ubuntu-server 18.04 LTS**. With other systems there may be compatibility issues.*

The only thing that needs to be modified is the environment file. You can find an example layout in the the docker-compose folder called `.env_sample`. You have to copy that as a `.env` file in place, and fill the required variables. These are:

`HOST_IP`: the ip of your server (this should be static). (e.g. 192.168.1.2)  
`HOST_NAME`: name of the host machine. Used by prometheus for job name, it can be anything. (e.g. myhost42)
`HOST_BASE_DIST`: the base distribution of your OS. Tested with `ubuntu` and `debian`. May work with others, if there is a docker repo for them.  
`LOG_DIR`: path where log files will placed. (e.g. /path/to/logs)  
`SCRAPE_INTERVAL`: interval in seconds that sets, how often node exporter will query system statistics. (e.g. 30)  
`TZ`: timezone. (e.g. Europe/Budapest)  
`SDP_CONF_DIR`: path where the simple-dash-particles config files will placed. (e.g. /path/to/conf)  
`SMB_USR`: samba share user name.  
`SMB_PASS`: samba share password.  
`SMB_NAME`: name for the storage. (e.g. MYPRIVATENAS)  
`HOST_SMB_MOUNT`: mount point of the shared folder, on the server. (e.g. /path/to/nasfolder)  
`GUEST_SMB_MOUNT`: this is where the shared folder will be mounted in the container. (e.g. /NASSHARE)  
`PROM_CONF_DIR`: path where the prometheus config files will placed. (e.g. /path/to/conf)  
`GRAFANA_PASS`: admin password for Grafana.  
`TR_USER`: transmission daemon user name.  
`TR_PASS`: transmission daemon user password.  
`TR_CONF_DIR`: path where the transmission daemon config files will placed. (e.g. /path/to/conf)  
`OPENEATS_DIR`: path where the open-eats config files will placed. (e.g. /path/to/conf)  
`OPENEATS_GUI_PORT`: port for the web interface. (e.g. 8081)  
`OPENEATS_API_PORT`: port for the api communication. (e.g. 8001)  
`LYCHEE_DIR`: path where the lychee config files will placed. (e.g. /path/to/conf)  
`LYCHEE_IMG`: path where the generated images will be stored.  
`LYCHEE_IMPORT_DIR`: path to a folder that will mounted in to the container. This can be used for easier img import. (this way you can simply use import from server option, and give the `/importer` path)  
`LYCHEE_DB_ROOT_PASS`: lychee db root password.  
`LYCHEE_DB_NAME`: lychee db name. (e.g. lychee)  
`LYCHEE_DB_USER`: lychee db user name. (e.g. lychee)  
`LYCHEE_DB_USER_PASS`: lychee db user password. (e.g. lychee)  
`KODI_DIR`: x11docker kodi container config directory. (e.g. /path/to/config/dir)

After it's done, it can be started simply with `sudo ./terraform_srv.sh`. In the building process open-eats will ask for some user information, but everything else should work unattended. After its done (and no error happend), webservices can be checked with the help of the ports file.
