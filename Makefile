include .env
export

# install required CLI commands
install-tools:
	./00-install-tools.sh

# creates kind cluster and deploys stuff
all:
	./01-initial-kind-and-registry-setup.sh
	./02-install-base-services.sh
	./03-deploy-apps.sh

# run this to delete everything, required if something goes wrong
clean:
	./04-final-cleanup.sh
