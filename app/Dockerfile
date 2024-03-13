# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff:latest .
#
# 3. Run with: 
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
# FROM alpine:latest as dependencies

# RUN apk add --no-cache \
#     nodejs npm 

# COPY package.json  .
# RUN npm install 

# FROM alpine:latest

# LABEL org.label-schema.schema-version="1.0"
# LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

# RUN apk add --no-cache \
#     nodejs npm \
#     vim

# RUN adduser --system app --home /app
# USER app
# WORKDIR /app
# COPY . /app
# COPY --from=dependencies node_modules ./node_modules

# CMD npm start

# EXPOSE 3000


# -------------------------------------------------------------------
# Minimal dockerfile from node js 13 alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff_app:latest .
#
# 3. Run with: 
#	docker run -p 3000:3000 --name alpine_timeoff timeoff_app
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
#############
# Use Node.js 13 Alpine as the base image for dependencies
FROM node:13-alpine as dependencies

# Install dependencies
RUN apk add --no-cache \
    nodejs npm 

# Set the working directory in the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install 

# Use Node.js 13 Alpine as the base image for the application
FROM node:13-alpine

# Add metadata labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

# Install additional packages
RUN apk add --no-cache \
    vim

# Create a system user and set the working directory
RUN adduser --system app --home /app
USER app
WORKDIR /app

# Copy application files and node_modules from dependencies
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Start the application
CMD npm start

# Expose port 3000
EXPOSE 3000