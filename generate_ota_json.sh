#!/bin/sh

# Exit on error
set -e

if [ "$1" ]; then
  # Set input variables
  file_path="$1"
  file_name=$(basename "$file_path")
  DEVICE=$(echo $TARGET_PRODUCT | cut -d "_" -f2)

  # Check if input file exists
  if [ -f "$file_path" ]; then
    # Set file variables
    file_size=$(stat -c%s "$file_path")
    id=$(cat "$file_path.sha256sum" | cut -d' ' -f1)
    datetime=$(grep ro\.build\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2)

    # Set variables
    full_rom_version=$(grep ro\.lineage\.version ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2 | cut -d "v" -f2)
    if [ -z "$full_rom_version" ]; then
      full_rom_version=$(echo "$file_name" | cut -d'-' -f2)
    fi
   
    custom_build_type=$(grep ro\.lineage\.releasetype ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2)
    if [ -z "$custom_build_type" ]; then
      custom_build_type=$(echo "$file_name" | cut -d'-' -f4)
    fi
    rom_version=$(echo "$full_rom_version" | grep -oE '^[0-9]{1,2}\.[0-9]')
    formatted_date=$(date -d "@$datetime" +"%Y%m%d")

    # Create OTA JSON
    if [ "$rom_version" != "" ]; then
      output_dir=$(dirname "$file_path")
      output_file="$output_dir/ota.json"

      # Generate OTA JSON content
      printf "{\n  \"response\": [\n    {\n      \"datetime\": %s,\n      \"filename\": \"%s\",\n      \"id\": \"%s\",\n      \"romtype\": \"%s\",\n      \"size\": %d,\n      \"url\": \"ChangeToYourOwnURL\",\n      \"version\": \"%s\"\n    }\n  ]\n}\n" \
        "$datetime" "$file_name" "$id" "$custom_build_type" "$file_size" "$formatted_date" "$file_name" "$rom_version" > "$output_file"

      # Print OTA JSON location
      echo "OTA JSON is located in: $output_file"
    fi
  fi
else
  # Print error
  echo "No input file provided."
  exit 1
fi