DATETIME ?= $(shell date "+%Y-%m-%d-%H%M%S")

.PHONY: up
up:  ## Start Hugo server
	hugo server -D

.PHONY: post
post:  ## Create a new post
	hugo new posts/${DATETIME}-new-post.md

.PHONY: help
help:  ## Print usage information
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help
