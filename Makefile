.PHONY: build install uninstall test lint

PREFIX ?= /usr/local
BINARY = Hawg
INSTALL_PATH = $(PREFIX)/bin/hawg
PLIST_NAME = com.hawg.agent.plist

build:
	swift build -c release

test:
	swift test

lint:
	swiftlint lint --strict

install: build
	@echo "Installing hawg to $(INSTALL_PATH)..."
	install -d $(PREFIX)/bin
	install .build/release/$(BINARY) $(INSTALL_PATH)
	@echo ""
	@echo "Binary installed. Now run (without sudo):"
	@echo "  make install-agent"

install-agent:
	@echo "Installing LaunchAgent to ~/Library/LaunchAgents/..."
	@mkdir -p $(HOME)/Library/LaunchAgents
	@sed "s|{{INSTALL_PATH}}|$(INSTALL_PATH)|g" com.hawg.agent.plist.template > $(HOME)/Library/LaunchAgents/$(PLIST_NAME)
	@echo "Loading LaunchAgent..."
	-launchctl unload $(HOME)/Library/LaunchAgents/$(PLIST_NAME) 2>/dev/null
	launchctl load $(HOME)/Library/LaunchAgents/$(PLIST_NAME)
	@echo "Done. hawg is now running and will start at login."

uninstall:
	@echo "Stopping hawg..."
	-launchctl unload $(HOME)/Library/LaunchAgents/$(PLIST_NAME) 2>/dev/null
	@echo "Removing LaunchAgent..."
	rm -f $(HOME)/Library/LaunchAgents/$(PLIST_NAME)
	@echo "Removing binary (may need sudo)..."
	rm -f $(INSTALL_PATH) || sudo rm -f $(INSTALL_PATH)
	@echo "Done."
