.PHONY: setup clean help

# Directories and files to be cleaned up
TEMP_DIRS = /tmp/pom
TEMP_FILES = /tmp/pom/pomodoro_timer.pid /tmp/pom/pomodoro_work_time.txt /tmp/pom/pomodoro_break_time.txt

# Setup dependencies or initial setup
setup:
	@echo "Setting up the Pomodoro timer environment..."
	sudo ./scripts/install.sh
	@echo "Setup complete."

# Clean up generated files (PID and time files)
clean:
	@echo "Cleaning up generated files..."
	sudo rm -rf $(TEMP_DIRS)
	rm -f $(TEMP_FILES)
	@echo "Cleanup complete."

# Display help message
help:
	@echo "Makefile for Pomodoro Timer"
	@echo ""
	@echo "Usage:"
	@echo "  make setup     # Setup the environment (e.g., create necessary directories)"
	@echo "  make clean     # Clean up generated files (PID and time files)"
	@echo "  make help      # Display this help message"
