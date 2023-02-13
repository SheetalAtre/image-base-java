all: multiarch

IMAGE_BASE=docker.flame.org/library

multiarch: set-git-info
	docker buildx build \
	    --pull \
	    --platform linux/amd64,linux/arm64 \
			-t ${IMAGE_BASE}/image-base-java-ubi8-minimal:latest \
			-t ${IMAGE_BASE}/image-base-java-ubi8-minimal:${GIT_BRANCH} . \
			--push

#
# set git info details
#
set-git-info:
	@$(eval GIT_BRANCH=$(shell git describe --tags))
	@$(eval GIT_HASH=$(shell git rev-parse ${GIT_BRANCH}))
