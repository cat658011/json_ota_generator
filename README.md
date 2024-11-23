# OTA JSON Generator

A simple script to generate OTA JSON for LineageOS-based ROMs.

## Usage

### Step 1: Clone the Repository

```bash
git clone https://github.com/cat658011/json_ota_generator vendor/lineage/OTA
```

### Step 2: Update the Download Link
Modify the download link to point to your own server.

### Step 3: Integrate the Script
Insert the following line into the `vendor/lineage/build/tasks/bacon.mk` file, prior to generating the SHA256 hash:

```makefile
$(hide) ./vendor/lineage/OTA/generate_ota_json.sh $(LINEAGE_TARGET_PACKAGE)
```

### Final Steps
Once you've made the changes, start building your ROM. The script will display a message indicating the location of the OTA JSON file.

