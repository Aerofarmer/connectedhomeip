OUT_DIR=out/all-clusters-app-ota
ANYCLOUD_DIR=third_party/p6/p6_sdk/libs/anycloud-ota/

./scripts/examples/gn_p6_example.sh examples/all-clusters-app/p6 "$OUT_DIR" chip_enable_ota_requestor=true build_update_image=true

mv "$OUT_DIR"/chip-p6-clusters-example.hex "$OUT_DIR"/chip-p6-clusters-example.unsigned.hex

./"$ANYCLOUD_DIR"/scripts/sign_script.bash "$OUT_DIR"/ chip-p6-clusters-example python3 arm-none-eabi-objcopy "-O ihex" "" "$ANYCLOUD_DIR"/source/mcuboot/scripts/ imgtool_v1.7.0/imgtool.py sign 0xFF 0x400 3584 1.0.0 0x00018000 0x001C0000 arm-none-eabi-objcopy "-k $ANYCLOUD_DIR/source/mcuboot/keys/cypress-test-ec-p256.pem"

if [ -f "$OUT_DIR"/chip-p6-clusters-example.ota ]; then
    rm "$OUT_DIR"/chip-p6-clusters-example.ota
fi

src/app/ota_image_tool.py create -v 0xFFF1 -p 0x8000 -vn 2 -vs "2.0" -da sha256 "$OUT_DIR"/chip-p6-clusters-example.bin "$OUT_DIR"/chip-p6-clusters-example.ota
