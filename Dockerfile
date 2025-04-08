#FROM node:20
FROM node:20.18.3-alpine3.21 AS builder
WORKDIR /opt/backend
COPY scripts/* .
RUN npm install


FROM node:20.18.3-alpine3.21
RUN addgroup -S naveen && adduser -S naveen -G naveen && \
    mkdir /opt/backend && \
    chown -R naveen:naveen /opt/backend
#### ACTUALLY IT SHOULD BE ONLY MYSQL BUT I CHANGED TO MYSQL-SVC TO WORK K8 DEPLOYMENT. ITS A SERVICE TO SERVICE COMMUNICATION.
ENV DB_HOST="mysql-svc" 
WORKDIR /opt/backend
USER naveen
COPY --from=builder /opt/backend /opt/backend
CMD ["node", "index.js"]