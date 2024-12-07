SHELL := /bin/bash

# Variables
PYTHON = python3
PIP = $(PYTHON) -m pip
VENV = .venv
ACTIVATE = source $(VENV)/bin/activate
REQUIREMENTS = requirements.txt

# Default target
.DEFAULT_GOAL := help

## Help: List available make commands
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

## Setup: Create virtual environment and install dependencies
setup: $(VENV)/bin/activate ## Set up virtual environment and install dependencies
$(VENV)/bin/activate:
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install --upgrade pip
	$(ACTIVATE) && $(PIP) install -r $(REQUIREMENTS)
	$(ACTIVATE)

## Run: Run the main application
run: ## Run the main Python application
	$(ACTIVATE) && $(PYTHON) main.py

## Test: Run all tests
test: ## Run tests with pytest
	$(ACTIVATE) && pytest tests/

## Lint: Check code with flake8
lint: ## Lint code using flake8
	$(ACTIVATE) && flake8 src/

## Clean: Remove temporary files and the virtual environment
clean: ## Clean up temporary files and remove virtual environment
	rm -rf $(VENV) __pycache__ .pytest_cache *.pyc .coverage
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete

## Install: Install dependencies without creating a virtual environment
install: ## Install Python dependencies globally or in the current environment
	$(PIP) install -r $(REQUIREMENTS)

## Freeze: Freeze the installed dependencies into requirements.txt
freeze: ## Save installed dependencies to requirements.txt
	$(PIP) freeze > $(REQUIREMENTS)

## Format: Format code using Black
format: ## Format code with Black
	$(ACTIVATE) && black src/

## Upgrade: Upgrade all installed packages
upgrade: ## Upgrade all Python packages
	$(ACTIVATE) && $(PIP) install --upgrade -r $(REQUIREMENTS)

.PHONY: help setup run test lint clean install freeze format upgrade
