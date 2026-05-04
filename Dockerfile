FROM rocker/shiny:4.3.3

# Install required R packages
RUN R -e "install.packages(c('shiny','shinydashboard','httr2'), repos='https://cloud.r-project.org/')"

# Copy your app into container
COPY . /srv/shiny-server/

# Configure Shiny Server to use Render's port
RUN echo "run_as shiny;" > /etc/shiny-server/shiny-server.conf && \
    echo "server {" >> /etc/shiny-server/shiny-server.conf && \
    echo "  listen 10000;" >> /etc/shiny-server/shiny-server.conf && \
    echo "  location / {" >> /etc/shiny-server/shiny-server.conf && \
    echo "    site_dir /srv/shiny-server;" >> /etc/shiny-server/shiny-server.conf && \
    echo "    log_dir /var/log/shiny-server;" >> /etc/shiny-server/shiny-server.conf && \
    echo "    directory_index on;" >> /etc/shiny-server/shiny-server.conf && \
    echo "  }" >> /etc/shiny-server/shiny-server.conf && \
    echo "}" >> /etc/shiny-server/shiny-server.conf

# Expose Render port
EXPOSE 10000

# Start Shiny Server
CMD ["/usr/bin/shiny-server"]
