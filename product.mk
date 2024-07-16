#
# Copyright (C) 2024 Panagiotis Englezos <panagiotisegl@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#

# Fonts
PRODUCT_COPY_FILES += \
    vendor/extra/fonts/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml \
    vendor/extra/fonts/InterVariable.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/InterVariable.ttf \
    vendor/extra/fonts/InterVariable-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/InterVariable-Italic.ttf

# Overlays
PRODUCT_PACKAGES += \
    CertificationOverlay \
    LineageUpdaterOverlay \
    FontInterOverlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)