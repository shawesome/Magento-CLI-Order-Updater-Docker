# Docker Setup for Magento CLI Order Updater

A docker-compose setup which creates a debian box running Magento 2.4.0 and the https://github.com/shawesome/Magento-CLI-Order-Updater module.

## Pre-requisites

- Docker (I'm running 19.03.11)
- Docker Compose (I'm running 1.17.1)

## Instructions

You'll need to copy in a valid `auth.json` file into `docker/magento/conf/auth.json`. It should look something like this

```
{
  "http-basic": {
    "repo.magento.com": {
      "username": "your public key",
      "password": "your private key"
    }
  }
}
```

If you've installed Magento via composer previously, then you'll find the file at `~/.composer/auth.json`.

Next, if you want to access the Magento instance via your web browser you'll need an entry in your `/etc/hosts` like:

```
127.0.0.1 martin.local
```

After that, you should be able to spin up the instance with:

```
docker-compose up
```

You'll know the environment has finished building when you get the prompt "Launching nginx and php..". Be aware, the first
build can take some time.
