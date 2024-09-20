###############################################################################
#
#                   ❇❇❇ Welcome to the Makefile ❇❇❇
#                             Version: v0.1
#
# Include this in your project, but don't change it. Rather create a main
# Makefile and include this, adjust variables as needed. You probably want to
# set the $IMG variable for the docker image.
#
###############################################################################


COLUMNS               ?= $(shell stty size | awk '{print $$2}')
SETUP_STTY            ?= -stty columns $$(( $(COLUMNS) - 4 )) $(DEBUG)
UPPER                 ?= $(shell echo '$1' | tr '[:lower:]' '[:upper:]')
FORMAT                ?= sed "s/^/    /g"

BIN_DIR               ?= bin
BIN                   ?= $(BIN_DIR)/app

RM                    ?= rm
MKDIR                 ?= mkdir

GO                    ?= go
GOBUILD               ?= $(GO) build
GOGET                 ?= $(GO) get

GO_SRC                ?= $(shell find ./ -name '*.go')

OS                    ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
CGO_ENABLED           ?= 0
GOENV                 ?= CGO_ENABLED=$(CGO_ENABLED) GOOS=$(OS)
LDFLAGS               ?= -ldflags="-s -w"

ECHO                  ?= @echo "  "
ifeq ($(OS),linux)
	ECHO                ?= @echo -e "  "
endif

ARCH                  ?= $(shell uname -m | tr '[:upper:]' '[:lower:]')
ifeq ($(ARCH),x86_64)
	ARCH               = amd64
endif

V                     ?= 0
ifneq ($(V),1)
	Q                  = @
	DEBUG              = 2>/dev/null
endif

.PHONY: all
all: help

##@ General
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; \
		printf "Usage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


.PHONY: clean
clean: ## Remove bin dir
	$(Q)$(ECHO) $(call UPPER, $@)
	$(Q)$(RM) -rf bin/*


##@ Publishing
.PHONY: build-docker
build-docker: $(BINS)## Build the docker image
	$(Q)$(ECHO) $(call UPPER, $@)
ifndef IMG
	$(error IMG variable is not set)
endif
	$(Q) DOCKER_BUILDKIT=1 docker build --ssh default . -t ${IMG} | $(FORMAT)

include $(shell pwd)/make/Makefile.development
include $(shell pwd)/make/Makefile.linting
include $(shell pwd)/make/Makefile.format
include $(shell pwd)/make/Makefile.testing
include $(shell pwd)/make/Makefile.audit
