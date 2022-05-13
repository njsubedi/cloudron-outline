## What

Run [Outline](https://www.getoutline.com/) on [Cloudron](https://cloudron.io)

## Why

Outline can authenticate users from a OpenID / SAML Provider like Keycloak, and use any s3 compatible backend for
storage. Cloudron provides a perfect environment to self-host Outline.

## Build and Install

- Install Cloudron CLI on your machine: `npm install -g cloudron-cli`.
- Install Docker, and make sure you can push to docker hub, or install the docker registry app in your own Cloudron.
- Log in to your Cloudron using cloudron cli: `cloudron login <my.yourdomain.tld>`.
- Build and publish the docker image: `cloudron build`.
- If you're using your own docker registry, name the image properly,
  like `docker.example-cloudron.tld/john_doe/cloudron-outline`.
- Log in to Docker Hub and mark the image as public, if necessary.
- Install the app `cloudron install -l <auth.yourdomain.tld>`
- Look at the logs to see if everything is going as planned.

Refer to the [Cloudron Docs](https://docs.cloudron.io/packaging/cli) for more information.

## Tutorial
Refer to [this article](https://blog.yarsalabs.com/self-hosting-outline-wiki-on-cloudron/) for setting up Minio for storage and Keycloak for authentication.

## Third-party Intellectual Properties

All third-party product names, company names, and their logos belong to their respective owners, and may be their
trademarks or registered trademarks.
