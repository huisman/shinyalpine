# Shinyalpine
Dockerfile for compiling and running [Shiny-Server](https://github.com/rstudio/shiny-server) on an [Alpine Linux](https://www.alpinelinux.org/) base image.

## Disclaimer: 
It is not recommended to use this Docker image in production. 

## Necessary tricks to get Shiny-Server compiling on an Alpine image

The official instructions for building Shiny-Server from source can be found [here](https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source). This image mostly follows the offical guide but also incorporates a couple of necessary 'tricks'/adjustments. 

* Install [Glibc](https://github.com/sgerrand/alpine-pkg-glibc) support for Alpine.
    * Fix a missing lib64 symlink (see [175](https://github.com/sgerrand/alpine-pkg-glibc/issues/175) and [181](https://github.com/sgerrand/alpine-pkg-glibc/issues/181)).
* Explicitly install `node-gyp`.
* Edit Shiny-server source code to use `su -l` instead of `su --login` (not available in busybox `su`).
* Use `adduser -S shiny` instead of `useradd` to create user.

## Known warnings: 
`/usr/local/shiny-server/ext/node/bin/shiny-server: /usr/lib/libstdc++.so.6: no version information available (required by /usr/local/shiny-server/ext/node/bin/shiny-server)`

At startup, Shiny-Server gives a warning about missing version information related to `/usr/lib/libstdc++.so.6`. This appears to be harmless.


