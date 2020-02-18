
# katzenpost_exp_env
Source code underlying the testbed used by [KatzenAnalyser](https://github.com/LasseWolter/KatzenAnalyser) as well as files to get started with using the katzenpost mixnet on your local machine (`mixnet/` directory).

### Disclaimer
This repo is given as is and won't be updated to work with the most recent version of the katzenpost mixnet.  
If you would like to work with the most recent version of the katzenpost mixnet, checkout their repo -> [katzenpost](https://github.com/katzenpost)

## Setup
Make sure your `$GOPATH` environment variable is set to the root of your go workspace (by default this is `~/go`).
You can check this by running `echo $GOPATH`.
1.  Clone this repo into `$GOPATH/src/github.com/katzenpost` using the following commads
	- `cd $GOPATH/src/github.com/` 
		- this directory should exists if you've used any go libraries hosted on git, if it doesn't exist, create it
	- `git clone https://github.com/LasseWolter/katzenpost_exp_env.git katzenpost`
2. Finish setup by entering the `install` directory (`cd install`) and running:
	- `./make.sh` (a bash script included in the repository)
	- this will install:
		- required dependencies in your go source folder `$GOPATH/src`
		- the go binaries required for the mixnet in `$GOPATH/bin`
3. Now enter the `katzenpost/mixnet` directory and run the `start.sh` script:
	- `./start.sh`
	- this should start up all the components of the mixnet
		- 1 authority
		- 2 providers, named provider and service_provider
		- 1 mix
4. If you would like to start the catshadow-messaging client manually you can do this by running the following command for example:
	- `cmd -f alice.toml -s testClient -g -shell`
	- check out the other options by running `cmd -h`
5. To stop the mixnet enter the `katzenpost/mixnet` directory and run`./stop.sh`
	- this script uses the `killall` utility. If it's not installed on your system you'll need to install it: 
		- running `sudo apt install psmisc` (this package contains the killall utility) should work on most systems

I hope this little introduction helped you to get started. There are a few [bash scripts](#additional-scripts) which helped me handling task that came up frequently during the work with the mixnet - maybe they'll be helpful to you as well.  
  

### Additional sctipts
- `cleanEnv.sh` - deletes all logs and dbs (used in the `install_and_build_docker` script)
- `clearAllDBs.sh` - deletes all dbs (NOT the logs)
- `clearAuthDB.sh` - deletes only the auth dbs - this can be enough in cases where you changed the setup and only want the PKI document to be generated from scratch but don't care about the content of provider/mix dbs 
- `gen_mix_config` - generates a new mix config file with the given mix_id and mix_ip (this config is based on the config file `./base_conf/mix_conf` - you might want to update it to suit your needs)
- `install_and_build_docker` - cleans the environment, installs go files and copies them to ./bin directory and then builds a docker container named `mix_net`
- `install_and_start` - installs go files (doesn't copy them to ./bin directory) and then runs `start.sh` to start the mix_net locally
- `start.sh` - starts the different components of the mixnet locally 
- `stops.sh` - stops all components of the mixnet
- `update_auth_pub_key` - updates all entries of the authority public key to the passed key (you want to update this script in order to include configs of new components you add, e.g. `mix2.toml` of a new mix)

### Tips for development
- to have a closer look at the databases created by the mixnet servers (providers/mixes/auth) I've found the [boltbrowser](https://github.com/br0xen/boltbrowser) a very useful tool
- if you change the setup you'll probably want to delete at least the auth db (see [additional scripts](#additional-scripts)) such that the PKI-document will be generated correctly for the current epoch - otherwise, you might have to wait until the next epoch for changes to take effect which is not convenient for debugging
- the authority.toml file should only contain as many `[[Mixes]]` as are in use. E.g. if you define another Mix2 in the config but don't actually start it the PKI-document won't be generated properly and thus, the handshake between the server instances won't complete 
- if the experiment seems to be stuck at "Waiting for Handshakes between servers to complete..." it's likely that the PKI document wasn't generated correctly. Check the authority-logfile, if it wasn't generated properly check:
    - if the authority.toml contains any extra sections ([[Mixes]], [[Providers]]) for components which aren't actually running - see note above)
    - check that the public keys in components config files and the config.toml for the experiment. If one of the keys is incorrect this might cause the problem

### Using your own modified Docker-image
- you can create your own docker images of your mixnet setup by entering the `mixnet` directory and then running:
    - `./install_and_build_docker.sh` 
    - this script cleans up the environment by deleting all the logs and dbs (such that these won't be copied to the docker image) and then creates a docker image called `mix_net' using the `Dockerfile` in the same directory
    - **WARNING**: the config files are not the same as for your local setup
        - it takes the config files prefixed with `docker_` located in the same directories as the usual config files (e.g. `./auth/`, `./mix1/`)
            - so if you create a new mixnet component or change something in the existing config-files, always remember to create/update the corresponding `docker_`-config-file as well
    - then you can run the `./runExperiment` script from the [KatzenAnalyser-repo](https://github.com/LasseWolter/KatzenAnalyser) with an additional argument to pass the name of your local docker image (in this case `mix_net`) - run `runExperiment.sh` without arguments to see help 
    
    
Thanks for checking out this repo!
