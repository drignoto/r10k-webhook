# r10k-webhook [![](https://images.microbadger.com/badges/image/ignoto/r10k-webhook.svg)](https://microbadger.com/images/ignoto/r10k-webhook "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/ignoto/r10k-webhook.svg)](https://microbadger.com/images/ignoto/r10k-webhook "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/ignoto/r10k-webhook.svg)](https://microbadger.com/images/ignoto/r10k-webhook "Get your own commit badge on microbadger.com")

Docker Image for deploy control-repo by r10k, using Gogs repository and webhooks.


## Description

This image using a webservice for trigger r10k command. The webservice was created
for Gogs webhooks only.

## Usage

### Requirements

*   [Docker](https://www.docker.com/)
*   [Gogs](https://gogs.io/)

This image are built and hosted automatically on Docker Hub at [ignoto/r10k-webhook](https://hub.docker.com/r/ignoto/r10k-webhook/)

Pull with:

```bash
$ docker pull ignoto/r10k-webhook
```

### Env variables and data

The container has two ENV variables for the config:

*   `PORT`: The port that listen the webservice.
*   `SECRET`: The secret used by Gogs Webhook.

If not set, the following defaults will be used:

*   Port: `9001`
*   Secret: `Changeme`

For the SSH keys, the container look for the key files at `/srv/deploy-keys/private-key`
and `/srv/deploy-keys/private-key.pub` and will use them if found.

### Use

First you need **Gogs** server. For the **control-repo** proyect, you need a webhook
in this proyect with:

*   **Payload URL:** The host that execute this container
*   **Type of content:** application/json
*   **Secret:** The `SECRET` ENV variable.

Second, you need to add the `/etc/puppetlabs/` in the container. It's necessary that Puppet has well config, with the `r10k` folder and config file.

The execution of the container has this form:

```bash
$ docker run -p 9001:9001 \
-v /srv/puppetlabs:/etc/puppetlabs \
-v /srv/gogs-deploy:/srv/deploy-keys \
ignoto/r10k-webhook
```

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1.  Fork it: <https://github.com/drignoto/r10k-webhook/fork>
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Make changes.
4.  Commit your changes (`git commit -am 'Add some feature'`).
5.  Push to the branch (`git push origin my-new-feature`).
6.  Create a new Pull Request.
