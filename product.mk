#
# Copyright (C) 2024 Panagiotis Englezos <panagiotisegl@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit Certification makefile
$(call inherit-product-if-exists, vendor/certification/config.mk)

# Overlays
PRODUCT_PACKAGES += \
    LineageUpdaterOverlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)