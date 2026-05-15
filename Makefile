REGISTRY      := ghcr.io
GH_USER       := gabjea
IMAGE_PREFIX  := hadoop

COMPONENTS    := namenode datanode resourcemanager nodemanager historyserver

BASE_IMAGE    := $(REGISTRY)/$(GH_USER)/$(IMAGE_PREFIX)-base:latest

.PHONY: login
login:
	@echo "Authenticating with $(REGISTRY)..."
	@ifndef GH_TOKEN
		$(error GH_TOKEN variable is undefined. Run: export GH_TOKEN=your_personal_access_token)
	@endif
	@echo "$(GH_TOKEN)" | docker login $(REGISTRY) -u $(GH_USER) --password-stdin

.PHONY: pipeline
pipeline: check-env build-all push-all
	@echo "Pipeline execution completed successfully. Ready for Argo CD synchronization!"

.PHONY: build-all
build-all: build-base build-components

.PHONY: build-base
build-base:
	@echo "Building Core Base Image..."
	docker build -t $(BASE_IMAGE) ./base

.PHONY: build-components
build-components:
	@echo "Building Component Images sequentially..."
	@for component in $(COMPONENTS); do \
		echo "   -> Building $(IMAGE_PREFIX)-$$component..."; \
		docker build -t $(REGISTRY)/$(GH_USER)/$(IMAGE_PREFIX)-$$component:latest ./$$component; \
	done

.PHONY: push-all
push-all: push-base push-components

.PHONY: push-base
push-base:
	@echo "Uploading Base Image to Registry..."
	docker push $(BASE_IMAGE)

.PHONY: push-components
push-components:
	@echo "Uploading Component Images to Registry..."
	@for component in $(COMPONENTS); do \
		echo "   -> Pushing $(IMAGE_PREFIX)-$$component..."; \
		docker push $(REGISTRY)/$(GH_USER)/$(IMAGE_PREFIX)-$$component:latest; \
	done

.PHONY: clean
clean:
	@echo "Cleaning local build system..."
	docker rmi $(BASE_IMAGE) || true
	@for component in $(COMPONENTS); do \
		docker rmi $(REGISTRY)/$(GH_USER)/$(IMAGE_PREFIX)-$$component:latest || true; \
	done
	@echo "Running Docker system prune to reclaim disk space..."
	docker image prune -f
