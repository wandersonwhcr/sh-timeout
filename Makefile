PWD := $(strip $(patsubst %/, %, $(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

.PHONY: lint
lint:
	docker run --rm \
		--volume "$(PWD):/mnt" \
		koalaman/shellcheck timeout.sh
