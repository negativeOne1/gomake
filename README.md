# gomake

a collection of makefile providing simple, sensable and ci compatible targets to build, audit, develop and release go code

```bash
gomake ❯ make                                                                                                                                                                                                                                                      2 on  main

Usage:
  make <target>

General
  help              Display this help
  clean             Remove bin dir

Publishing
  build-docker      Build the docker image

Development
  build             Build executables
  dev               Run with Air
  run               Run app
  lint              Run golangci-lint linter
  lint-fix          Run golangci-lint linter and perform fixes
  gofumpt           Run gofumpt

Testing
  test              Run unit tests
  test_integration  Run integration tests

Security audit
  check-dockerfile  Check Dockerfile
  check-image       Check image
```
