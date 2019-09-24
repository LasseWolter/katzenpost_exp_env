
# katzenpost_exp_env
Source code underlying the testbed used by [KatzenAnalyser](https://github.com/LasseWolter/KatzenAnalyser) as well as files to get started with using the katzenpost mixnet on your local machine (`mixnet/` directory).

### Disclaimer
This repo is given as is and won't be updated to work with the most recent version of the katzenpost mixnet.  
If you would like to work with the most recent version of the katzenpost mixnet, checkout their repo -> [katzenpost](https://github.com/katzenpost)

## Setup
1.  Clone this repo into `$GOPATH/src/github.com/katzenpost` using the following commads
	- `cd $GOPATH/src/github.com/` 
		- this directory should exists if you've used any go libraries hosted on git, if it doesn't exist, create it
	- `git clone https://github.com/LasseWolter/katzenpost_exp_env.git katzenpost`
2. Install go binaries into your workspace (by default this is `$GOPATH/bin`) by running:
	- `./install_go_binaries.sh` (a bash script included in the repository)
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

Now there are lots of options for you to play around with the mixnet. E.g., you change the structure by adding more mixes (the `gen_mix_config.sh` script can help with that).  
I hope this little introduction helped you to get started. There are a few bash scripts which help handling task that came up for me during the work with the mixnet - maybe they'll be helpful to you as well.  
Last thing, to have a closer look at the databases created by the mixnet I've found the [boltbrowser](https://github.com/br0xen/boltbrowser) a very useful tool.  
  
Thanks for checking out this repo!

