#!/bin/bash
#set -e

TIME_NOW="$(date "+%b %d %Y %Hh:%Mm:%Ss %Z")"
OS_INFO="$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="')"
HOST_KERNEL="$(uname -r| sed 's/\./\\./g' | sed 's/\-/\\-/g')"
HOST_CORES="$(nproc --all)"
ZIP_NAME="Daemon-v1.02.zip"

log() {
    local message=$1
    local color=$2
    local style=$3
    local color_code="\e[${color}m"
    local style_code="\e[${style}m"
    local reset_code="\e[0m"
    echo -e "${style_code}${color_code}${message}${reset_code}"
}

device="munch"
# test_channel="-1001410447029"   # group
# test_channel="-1001366565777" # channel
test_channel="-1001356262990"      # test channel

function tg() {
    local action="$1"
    local text="$2"
    local CHAT_ID="$3"
    local initial_message="$4"
    local doc_path="$5"
    local doc_caption="$6"

    if [ "$action" == "s" ]; then
        local message_response=$(curl --request POST \
            --url "https://api.telegram.org/bot${BOT_API_KEY}/sendMessage" \
            --data "disable_web_page_preview=true" \
            --data "disable_notification=true" \
            --data "parse_mode=MarkdownV2" \
            --data "chat_id=${CHAT_ID}" \
            --data text="$text")

        if
            [ "$initial_message" == "true" ]
        then
            first_message_id=$(echo $message_response | jq .result.message_id) && last_message_id=$first_message_id
        else
            last_message_id=$(echo $message_response | jq .result.message_id)
        fi

    elif [ "$action" == "e" ]; then
        if [ -n "$doc_path" ]; then
            curl -F document=@"$doc_path" \
                "https://api.telegram.org/bot${BOT_API_KEY}/sendDocument" \
                -F chat_id="$CHAT_ID" -F caption="$doc_caption" -F "parse_mode=MarkdownV2"  2>/dev/null
        fi

        if [ -z "$last_message_id" ]; then
            echo "No message to edit. Send a message first."
            exit 1
        fi

        if
            [ "$initial_message" == "true" ]
        then
            last_message_id=$first_message_id
        fi
        
        if [ -n "$text" ]; then
            local message_response=$(curl -s --request POST \
            --url "https://api.telegram.org/bot${BOT_API_KEY}/editMessageText" \
            --data text="$text" \
            --data "disable_web_page_preview=true" \
            --data "disable_notification=true" \
            --data "parse_mode=MarkdownV2" \
            --data "chat_id=${CHAT_ID}" \
            --data "message_id=${last_message_id}")

            last_message_id=$(echo $message_response | jq .result.message_id)
        fi
    else
        echo "Invalid action: $action"
        exit 1
    fi
}

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING="$(clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"

BUILD_START=$(date +"%s")
KERNEL_DIR=$(pwd)
ZIMAGE_DIR="$KERNEL_DIR/out/arch/arm64/boot"


log "******************************************" 33 1
log "*   Checking and updating kernelSU       *" 32 1
log "******************************************" 33 1

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

log "******************************************" 33 1
log "*          Making munch_defconfig        *" 32 1
log "******************************************" 33 1

# make munch_defconfig O=out CC=clang
make munch_defconfig O=out LLVM=1 \
                ARCH=arm64 \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                NM=llvm-nm \
                OBJDUMP=llvm-objdump \
                STRIP=llvm-strip

log "******************************************" 33 1
log "*          Compiling Kernel              *" 32 1
log "******************************************" 33 1
make -j$(nproc --all) O=out \
    LLVM=1 \
    ARCH=arm64 \
    CC=clang \
    CROSS_COMPILE=aarch64-linux-gnu- \
    NM=llvm-nm \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
TOTAL_TIME="Build completed in $(($DIFF / 60)) minute\(s\) and $(($DIFF % 60)) seconds\."

mkdir -p tmp
cp -fp "$ZIMAGE_DIR/Image.gz" tmp
# cp -fp $ZIMAGE_DIR/dtbo.img tmp
mv "$ZIMAGE_DIR/dtb.img" "$ZIMAGE_DIR/dtb"
cp -fp "$ZIMAGE_DIR/dtb" tmp
cp -rp ./anykernel3/* tmp
cd tmp
zip -r -9 "tmp.zip" *
cd ..
rm *.zip
cp -fp "tmp/tmp.zip" "$ZIP_NAME"
rm -rf tmp

CAPTION='
*Device:* _Poco F4 \(munch\)_

*Build triggered at:*
*'$TIME_NOW'*

*'$TOTAL_TIME'*

*Compiler*: _AOSP Clang 17\.0\.3_
*Host OS* : _'$OS_INFO'_
*Host Kernel* : _'$HOST_KERNEL'_
*Host Cores* : _'$HOST_CORES'_

'
tg "e" "" "$test_channel" "true" "$ZIP_NAME" "$CAPTION" 2>/dev/null

log "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds." 32 1

git reset --hard
