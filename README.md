# RecipeSage Self Hosting

This repository contains the configuration needed to run your own, personal instance of RecipeSage.

Please note that this repository and all public RecipeSage branding, docker images, code, binaries, and everything else are for personal, private, non commercial use only. All RecipeSage branding is not licensed for reuse.

Warning: There are portions of the software that may not work. I don't warranty the functionality here. You're in charge of making backups and making sure you don't lose data, especially when updating!

These images are based on the same version that RecipeSage uses in the cloud for the hosted instance. I'm mostly focused on the hosted instance, but please let me know if there are issues when attempting to run it locally!

# Setup

You'll need Docker to run RecipeSage locally. Although you _can_ attempt to run it without Docker, it likely won't work or will be buggy.

To start, simply start all containers:
`docker-compose up -d`

On first run, and when updating, you'll need to run migrations:
`docker-compose exec api /app/migrate`

I strongly recommend taking a backup of your volumes before migrating to avoid any potential data loss.

RecipeSage _really_ depends on AWS S3 for image storage, but I've stubbed in fake S3 via Minio. I _highly_ suggest setting up an AWS account with S3 and using that rather than Minio. That said, Minio seems to work just fine in my limited testing, so YMMV.
