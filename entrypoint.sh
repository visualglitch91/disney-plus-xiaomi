#!/bin/sh

# Assign the fixed input APK file path
APK_FILE="/data/disney-plus.apk"
OUTPUT_DIR="/data"

# Ensure the input APK file exists
if [ ! -f "$APK_FILE" ]; then
  echo "Error: Input APK file not found at /data/disney-plus.apk."
  exit 1
fi

# Create a temporary directory to work with
TMP_DIR=$(mktemp -d)
SOURCE_DIR="$TMP_DIR/source"
MODIFIED_APK="$TMP_DIR/modified.apk"
ZIPALIGNED_APK="$TMP_DIR/aligned.apk"

# Decompile the APK file
sh /app/apktool d -f "$APK_FILE" -o "$SOURCE_DIR"

# Replace all references in files from "Xiaomi" to "NOOP"
find "$SOURCE_DIR" -type f -exec sed -i 's/Xiaomi/NOOP/g' {} +
find "$SOURCE_DIR" -type f -exec sed -i 's/xiaomi/NOOP/g' {} +

# Recompile the modified files
sh /app/apktool b "$SOURCE_DIR" -o "$MODIFIED_APK"

/app/android-13/zipalign -p -v 4 "$MODIFIED_APK" "$ZIPALIGNED_APK"

# Zip align the modified APK file
java -jar /app/uber-apk-signer.jar --apks "$ZIPALIGNED_APK" --out "$OUTPUT_DIR" --skipZipAlign --debug

ls $TMP_DIR

# Clean up temporary directory
rm -rf "$TMP_DIR"
