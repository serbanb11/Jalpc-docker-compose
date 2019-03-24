FROM nginx:stable

# Inspiration:
# https://hub.docker.com/r/gaafar/cron/

# Install cron, certbot, bash, plus any other dependencies
RUN apt-get update \
   && apt-get install -y cron bash wget
RUN mkdir -p /webroots/ /scripts

# /webroots/DOMAIN.TLD/.well-known/... files go here
VOLUME /webroots
VOLUME /etc/letsencrypt

# /webroots/DOMAIN.TLD will be mounted 
# into each proxy as http://DOMAIN.TLD/.well-known
#
# /scripts will contain certbot and other scripts

COPY register /scripts/
RUN chmod +x /scripts/register

WORKDIR /scripts
RUN wget https://dl.eff.org/certbot-auto
RUN chmod a+x ./certbot-auto
# Run certbot-auto so that it installs itself
RUN /scripts/certbot-auto -n certificates

# This installs a Crontab entry which 
# runs "certbot renew" on several days a week at 03:22 AM
#
RUN echo "22 03 * * 2,4,6,7 root /scripts/certbot-auto renew" >/etc/cron.d/certbot

# Run both nginx and cron together
CMD [ "sh", "-c", "nginx && cron -f" ]
