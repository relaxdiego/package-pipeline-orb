.DEFAULT_GOAL := help

##
## Available Goals:
##

##   publish-orb-dev  : Publishes the orb for development purposes.
##
.PHONY: publish-orb-dev
publish-orb-dev :
	# TODO: Make this pick up the namespace/orb-name and dev version from a .gitignored
	#       file named '.orb-dev.yml'
	circleci orb pack src | circleci orb publish - relaxdiego/package-pipeline@dev:alpha

##   validate-config  : Runs the circleci config validator against .circleci/config.yml.
##
.PHONY: validate-config
validate-config :
	circleci config validate .circleci/config.yml


##   validate-orb     : Runs circleci orb validate against the orb in src/
##
.PHONY: validate-orb
validate-orb :
	circleci orb pack src | circleci orb validate -

# From: https://swcarpentry.github.io/make-novice/08-self-doc/index.html
##   help             : Print this help message.
##
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<
