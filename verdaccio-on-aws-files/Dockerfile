FROM verdaccio/verdaccio:5

ADD config.yaml /verdaccio/conf/config.yaml
USER root
ENV NODE_ENV=production
RUN npm install -g verdaccio-aws-s3-storage
USER verdaccio
