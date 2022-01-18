CWD := $(strip $(patsubst %/, %, $(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

.PHONY: lint
lint:
	docker run --rm \
		--volume "$(CWD):/mnt" \
		koalaman/shellcheck timeout.sh
