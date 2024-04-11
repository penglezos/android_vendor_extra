#
# Copyright (C) 2024 Panagiotis Englezos <panagiotisegl@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#

# Overlays
PRODUCT_PACKAGES += \
    CertificationOverlay \
    LineageUpdaterOverlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)