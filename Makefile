PROJECT_NAME := PortfolioMobileiOS
SCHEME := PortfolioMobileiOS
PROJECT := PortfolioMobileiOS.xcodeproj

BUILD_DIR := build
ARCHIVE_PATH := $(BUILD_DIR)/$(PROJECT_NAME).xcarchive
EXPORT_PATH := $(BUILD_DIR)/export
EXPORT_OPTIONS := ExportOptions.plist

.PHONY: ipa archive export clean

ipa: clean archive export
	@echo "IPAを作成しました: $(EXPORT_PATH)/$(PROJECT_NAME).ipa"
	@open "$(EXPORT_PATH)"

archive:
	@mkdir -p "$(BUILD_DIR)"
	xcodebuild archive \
		-project "$(PROJECT)" \
		-scheme "$(SCHEME)" \
		-configuration Release \
		-destination "generic/platform=iOS" \
		-archivePath "$(ARCHIVE_PATH)" \
		-allowProvisioningUpdates

export:
	xcodebuild -exportArchive \
		-archivePath "$(ARCHIVE_PATH)" \
		-exportPath "$(EXPORT_PATH)" \
		-exportOptionsPlist "$(EXPORT_OPTIONS)" \
		-allowProvisioningUpdates

clean:
	@rm -rf "$(BUILD_DIR)"
