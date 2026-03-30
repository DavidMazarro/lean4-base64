.PHONY: build clean rebuild test help

all: build

build:
	lake build

clean:
	lake clean

rebuild: clean build

test:
	lake build tests
	.lake/build/bin/tests

help:
	@echo "Available targets:"
	@echo "  build   - Build the library"
	@echo "  clean   - Clean build artifacts"
	@echo "  rebuild - Clean and rebuild"
	@echo "  test    - Build and run tests"
	@echo "  help    - Show this help"
