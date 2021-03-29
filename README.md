# RecipeSage

[RecipeSage](https://recipesage.com) is a free personal recipe keeper, meal planner, and shopping list organizer for Web, IOS, and Android. It can be used to share recipes, shopping lists, and meal plans with your family & friends, as well as import (grab) recipes from any URL on the web.

This repository contains the configuration needed to run your own, personal instance of [RecipeSage](https://recipesage.com).

The docker images used here are based on the same version that the official [RecipeSage](https://recipesage.com) uses in the cloud for the hosted instance. I'm mostly focused on the official hosted instance, but please let me know if there are issues when attempting to run it locally!

## License/Usage Restrictions

Please note that this repository and all public RecipeSage branding, docker images, code, binaries, and everything else are for personal, private (non-public), non commercial use only. All RecipeSage branding is not licensed for reuse.

Warning: There are portions of the software that may not work. I don't warranty the functionality here. You're in charge of making backups and making sure you don't lose data, especially when updating!

## Setup

You'll need Docker to run [RecipeSage](https://recipesage.com) locally. Although you _can_ attempt to run it without Docker, it likely won't work or will be buggy.

To start, simply start all containers:
`docker-compose up -d`

On first run, and when updating, you'll need to run migrations:
`docker-compose exec api /app/migrate`

I strongly recommend taking a backup of your volumes before migrating to avoid any potential data loss.

RecipeSage _really_ depends on AWS S3 for image storage, but I've stubbed in fake S3 via Minio. I _highly_ suggest setting up an AWS account with S3 and using that rather than Minio. That said, Minio seems to work just fine in my limited testing, so YMMV.

If you're not going to use minio, and are going to use S3 proper, you'll want to remove the minio-specific environment variables (marked with comments), and plug in your AWS credentials.

You'll likely want to put this behind some type of reverse proxy (I recommend nginx) to add SSL (I recommend Lets Encrypt). As-is, the container consumes port 80 on the host system. You can easily change that to another host port as desired.

## Updating

Update your local images: `docker-compose pull`
Then, down & up the containers: `docker-compose down && docker-compose up -d`

## Bonus Features

The "bonus features" from the hosted version can be activated by running the following command (swap out the email address with your account email).
Please contribute to the development & maintenance of RecipeSage at https://recipesage.com/#/contribute -- Julian.

`docker-compose exec api /app/activate example@example.com`

## Changelog

### v1.1.0

Move minio behind app proxy.

**Note:** If you're upgrading from an earlier version of these selfhost configs, you'll need to make sure to continue to expose 9000 on the Minio container in order to maintain access to images uploaded before this change, **or** update the image path in the DB.

### v1.0.0

Initial release.

