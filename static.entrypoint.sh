#!/bin/sh

sed -i 's|<base href="\/">.*|<base href="/"><script>window.API_BASE_OVERRIDE = '${API_BASE_OVERRIDE}';</script>|i' /usr/share/nginx/html/index.html

