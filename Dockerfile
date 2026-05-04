FROM rocker/shiny:4.3.3

# Install system libraries (fixed)
RUN apt-get update && apt-get install -y \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('shiny','shinydashboard','httr2','data.table','dplyr','ggplot2','leaflet','sf','lidR','rlas'), repos='https://cloud.r-project.org/')"

# Copy app
COPY . /srv/shiny-server/

# Configure port for Render
RUN echo "run_as shiny;" > /etc/shiny-server/shiny-server.conf && \
    echo "server { listen 10000; location / { site_dir /srv/shiny-server; log_dir /var/log/shiny-server; directory_index on; } }" >> /etc/shiny-server/shiny-server.conf

EXPOSE 10000

CMD ["/usr/bin/shiny-server"]
