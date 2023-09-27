# Makefile for a Bash Script

# Variables
SCRIPT_NAME = ./phonessh.sh
INSTALL_DIR = ~/.local/bin/

# Targets
.PHONY: install uninstall

# Default target: Run the script
run:
	./$(SCRIPT_NAME)

# Install the script to the specified directory
install:
	cp $(SCRIPT_NAME) $(INSTALL_DIR)/$(SCRIPT_NAME)
	chmod +x $(INSTALL_DIR)/$(SCRIPT_NAME)

# Uninstall the script from the installation directory
uninstall:
	rm -f $(INSTALL_DIR)/$(SCRIPT_NAME)

# Clean any temporary or generated files (if needed)
clean:
	# Add clean-up commands here if applicable

# Help target: Display available targets and their descriptions
help:
	@echo "Available targets:"
	@echo "  run         : Run the script"
	@echo "  install     : Install the script to $(INSTALL_DIR)"
	@echo "  uninstall   : Uninstall the script from $(INSTALL_DIR)"
	@echo "  clean       : Clean any temporary or generated files"
	@echo "  help        : Display this help message"

# By default, display the help message
.DEFAULT_GOAL := help
