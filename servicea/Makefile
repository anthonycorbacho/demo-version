# Makefile.
#
# Arguments:
#	OS	: Platform for binary build, linux Or darwin (OSX)
#

# Bump these on release.
VERSION_MAJOR ?= 0
VERSION_MINOR ?= 0
VERSION_BUILD ?= 1
VERSION ?= v$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_BUILD)

# Default Go binary.
ifndef GOROOT
  GOROOT = /usr/local/go
endif

# Determine the OS to build.
ifeq ($(OS),)
  ifeq ($(shell  uname -s), Darwin)
    GOOS = darwin
  else
    GOOS = linux
  endif
else
  GOOS = $(OS)
endif

GOCMD = GOOS=$(GOOS) go
GOBUILD = CGO_ENABLED=0 $(GOCMD) build
GOTEST = $(GOCMD) test -race
RM = rm -rf
PROJECT = servicea
BUILD_PACKAGE = .
GO_PKGS?=$$(go list ./... | grep -v /vendor/)

VERSION_PACKAGE = github.com/ZEPL/kit/version
GO_LDFLAGS :="
GO_LDFLAGS += -X $(VERSION_PACKAGE).version=$(VERSION)
GO_LDFLAGS += -X $(VERSION_PACKAGE).buildDate=$(shell date +'%Y-%m-%dT%H:%M:%SZ')
GO_LDFLAGS += -X $(VERSION_PACKAGE).gitCommit=$(shell git rev-parse HEAD)
GO_LDFLAGS += -X $(VERSION_PACKAGE).gitTreeState=$(if $(shell git status --porcelain),dirty,clean)
GO_LDFLAGS +="

.PHONY: build

build:
		$(GOBUILD) -ldflags $(GO_LDFLAGS) -i -o ./$(PROJECT) -v $(BUILD_PACKAGE)

clean:
		find . -type f -name '*~' -exec rm {} +
		find . -type f -name '\#*\#' -exec rm {} +
		find . -type f -name '*.coverprofile' -exec rm {} +

fclean: clean
		$(RM) $(PROJECT)

version:
		@echo $(VERSION)
