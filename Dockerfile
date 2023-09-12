# Set the base image for the build, using the Golang Alpine image 1.19.13.
FROM golang:1.19.13-alpine AS builder

# Set the working directory in the container for the build.
WORKDIR /go/src/app

# Copy all content from the local directory to the working directory in the container.
COPY . .

# Initialize a Go module (if it doesn't already exist) and compile the source code into an executable named 'server'.
RUN go mod init && \
    go build -o server .

# Define a new stage based on an empty ("scratch") image to create a minimal image.
FROM scratch

# Copy the 'server' executable generated in the previous stage to the working directory in the final container.
COPY --from=builder /go/src/app/server /go/src/app/server

# Expose port 80 so that the container can receive connections on port 80.
EXPOSE 80

# Define the command to be executed when the container is started, which is the 'server' executable.
CMD ["/go/src/app/server"]
