# Cairo Controller Account - Makefile
#
# This Makefile provides common development tasks for the Cairo Controller Account project.

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build             Build the Cairo contracts"
	@echo "  test              Run all tests"
	@echo "  fmt               Format Cairo code"
	@echo "  clean             Clean build artifacts"
	@echo "  setup-pre-commit  Set up pre-commit hooks"
	@echo "  lint              Run all linting (format + check)"
	@echo "  lint-check        Run linting checks without formatting"
	@echo "  lint-cairo        Run Cairo linting only"
	@echo "  lint-prettier     Run prettier linting only"

# Build targets
.PHONY: build
build:
	scarb build

.PHONY: test
test:
	scarb test

.PHONY: fmt
fmt:
	scarb fmt

.PHONY: clean
clean:
	rm -rf target/

# Pre-commit setup
.PHONY: setup-pre-commit
setup-pre-commit:
	./bin/setup-pre-commit

# Linting targets
.PHONY: lint
lint:
	./bin/lint

.PHONY: lint-check
lint-check:
	./bin/lint --check-only

.PHONY: lint-cairo
lint-cairo:
	./bin/cairo-lint

.PHONY: lint-prettier
lint-prettier:
	./bin/prettier-lint

# Development shortcuts
.PHONY: dev-setup
dev-setup: setup-pre-commit
	@echo "✅ Development environment setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  make build    # Build the contracts"
	@echo "  make test     # Run tests"
	@echo "  make lint     # Check code quality"