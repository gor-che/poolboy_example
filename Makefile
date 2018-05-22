PROJECT = cheche
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

DEPS = poolboy epgsql
RELX_OPTS = --sys_config $(CURDIR)/dev/dev.config

include erlang.mk
