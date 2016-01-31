.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: NAME TAG builddocker

# run a plain container
run: build rundocker

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-d \
	-v /data \
	-t $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

rmall: rm

grab: grabapachedir

grabapachedir:
	-mkdir -p datadir
	docker cp `cat cid`:/var/www/html  - |sudo tar -C datadir/ -pxvf -
	echo `pwd`/datadir/html > APACHE_DATADIR

APACHE_DATADIR:
	@while [ -z "$$APACHE_DATADIR" ]; do \
		read -r -p "Enter the destination of the Apache data directory you wish to associate with this container [APACHE_DATADIR]: " APACHE_DATADIR; echo "$$APACHE_DATADIR">>APACHE_DATADIR; cat APACHE_DATADIR; \
	done ;
