FROM rocker/r-ver

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

## packages needed for basic shiny functionality
RUN Rscript -e "install.packages(c('shiny', 'ggplot2'),repos='https://cloud.r-project.org')"

# install the shiny application
COPY hackathon_0.1.0.tar.gz /root/
RUN R CMD INSTALL /root/hackathon_0.1.0.tar.gz
RUN rm /root/hackathon_0.1.0.tar.gz

# set host and port
COPY Rprofile.site /usr/lib/R/etc/
EXPOSE 3838

CMD ["R", "-e hackathon::shiny_application()"]
