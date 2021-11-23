# Stage 1: Compile and Build angular codebase
#
# # Use official node image as the base image
FROM node:latest as build

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install all the dependencies
RUN NG_CLI_ANALYTICS=false npm install

# Generate the build of the application
RUN npm run build


#FROM registry.access.redhat.com/ubi7/nginx-118
FROM image-registry.openshift-image-registry.svc:5000/openshift/nginx:1.18-ubi7
#Add application sources to a directory that the assemble script expects them
# and set permissions so that the container runs without root access
USER 0
COPY --from=build /usr/local/app/dist/sample-angular-app /tmp/src/
RUN chown -R 1001:0 /tmp/src
USER 1001
# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble
# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run
