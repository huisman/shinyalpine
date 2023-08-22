# Define base image and install glibc
FROM alpine as base
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget -q -O glibc-2.35-r1.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk
RUN wget -q -O glibc-bin-2.35-r1.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk
RUN apk add --no-cache glibc-2.35-r1.apk glibc-bin-2.35-r1.apk \
    && rm glibc-2.35-r1.apk \
    && rm glibc-bin-2.35-r1.apk
    
# Workaround for bug in alpine-glibc?
# See https://github.com/sgerrand/alpine-pkg-glibc/issues/175 and 181
RUN ln -fs /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Define build image and compile shinyserver from source
FROM base as build
RUN apk add --no-cache R R-dev git build-base cmake python3

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN R -e "install.packages(c('shiny'), INSTALL_opts=c('--no-docs','--no-help', '--no-html'))"

COPY install_shiny_server.sh .
RUN sh install_shiny_server.sh

# Build final stage
FROM basealpine

COPY post_install_shiny_server.sh .
RUN sh post_install_shiny_server.sh \
    && rm post_install_shiny_server.sh

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh

ENV SHINY_LOG_STDERR 1

# Copy compiled programs from build image
COPY --from=build /usr/local/shiny-server/ /usr/local/shiny-server
COPY --from=build /usr/lib/R/ /usr/lib/R 
COPY --from=build /root/.Rprofile /root/.Rprofile
COPY --from=build /lib64/ /lib64

# Install R
RUN apk add --no-cache R

# Copy hello world app
COPY app.R /srv/shiny-server/app.R

WORKDIR /srv/shiny-server
CMD /usr/bin/shiny-server.sh

