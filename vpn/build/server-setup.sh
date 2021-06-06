#!/bin/bash
vpncmd_server () {
    /usr/bin/vpncmd localhost /SERVER /CSV /CMD "$@"
}
vpncmd_hub () {
    /usr/bin/vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD "$@"
}