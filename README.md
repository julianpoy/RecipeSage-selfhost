<a href="https://recipesage.com"><img align="left" width="100" height="100" src="https://github.com/julianpoy/RecipeSage/raw/master/packages/frontend/src/assets/imgs/logo_green.png"></img></a>

# RecipeSage Self-Hosting Toolkit

<br />

[RecipeSage](https://recipesage.com) is a free personal recipe keeper, meal planner, and shopping list organizer for Web, IOS, and Android. It can be used to share recipes, shopping lists, and meal plans with your family & friends, as well as import (grab) recipes from any URL on the web.

This repository contains the configuration needed to run your own, personal instance of [RecipeSage](https://recipesage.com).

The docker images used here are based on the same version that the official [RecipeSage](https://recipesage.com) uses in the cloud for the hosted instance. I'm mostly focused on the official hosted instance, but please let me know if there are issues when attempting to run it locally!

### License/Usage Restrictions

Please note that this repository and all public RecipeSage branding, docker images, code, binaries, and everything else are for personal, private (non-public), non commercial use only. All RecipeSage branding is not licensed for reuse.

Warning: There are portions of the software that may not work. I don't warranty the functionality here. You're in charge of making backups and making sure you don't lose data, especially when updating!

## Setup

You'll need Docker to run [RecipeSage](https://recipesage.com) locally. Although you _can_ attempt to run it without Docker, you're on your own.

To start, simply start all containers:
`docker-compose up -d`

On first run, and when updating, you'll need to run migrations:
`docker-compose exec api /app/migrate`

The app should be available at port 80. You can change that by changing [this](https://github.com/julianpoy/RecipeSage-selfhost/blob/a1133c51af24ca78f9bc9537e147411b5e7e311a/docker-compose.yml#L8) to something else, such as `3000:80` for port 3000.

### Updating

First, take a look at the changelog below for any special upgrade notes. Then follow the steps below.

As with any migration/upgrade, I recommend taking a backup of your volumes before migrating to avoid any potential data loss.

Update your local copy of this repo with the latest from this repository. If cloned with Git, this is as simple as `git pull`.

Update your local images: `docker-compose pull`.

Then, down & up the containers: `docker-compose down && docker-compose up -d`

Finally, run any pending migrations:
`docker-compose exec api /app/migrate`

<br />


## Customization

The following sections provide some information on customizing your instance. Following the "setup" section is enough to get you running with a RecipeSage instance like that of the official site.

### Disabling Registration  

If you want to disable registration, **after** you have registered yourself as a user, add this to the top of the docker environment variables: 
`DISABLE_REGISTRATION=true` 

Then, down & up the containers: `docker-compose down && docker-compose up -d`

When registration is disabled, the registration screen will still appear but will fail with an error if anyone tries to register.

### Bonus Features

The "bonus features" from the hosted version can be activated by running the following command (swap out the email address with your account email).
Please contribute to the development & maintenance of RecipeSage at https://recipesage.com/#/contribute -- Julian.

`docker-compose exec api /app/activate example@example.com`

### Container Structure

This section is here just to explain the purpose of each container and why it's necessary. Following Docker principles, every part of the application is compartmentalized into it's own container with it's own singular responsibility. I've described what role each plays in making the application do what it does.

The `proxy` container facilitates divvying up requests between the `api`, the `static` (frontend, and the `minio` container. Without it, you'd need to route requests yourself, such as properly directing requests that head to `/api/*` to the `api` container, and requests that go to any other path on `/*` to the `static` container.

The `static` container is a very simple image with the prebuilt frontend assets for that version of RecipeSage. The application cannot run without it.

The `api` container facilitates all data storage for the application. The application cannot run without it.

The `elasticsearch` container facilitates the hyper-accurate fuzzysearch for the app. Without it, search within the app will not work.

The `pushpin` container is a broker for all websocket connections. Without it, all realtime interactions between multiple users won't work and will require a reload to get new content, such as when a shopping list item is checked off.

The `postgres` container is the database. The application cannot run without it.

The `browserless` container is a virtual web browser that is used to scrape recipe data when you paste a URL into the "autofill" feature of the app. Without it, the recipe scraper _should still work_, but will fall back to JSDOM which will be significantly less accurate and may contain formatting errors.

The `ingredient-instruction-classifier` container facilitates machine learning classification of ingredients and instructions, which is used to improve accuracy during the "autofill" feature. Without it, the recipe _should still work_, but will be a bit less accurate or may not be able to pull ingredients or instructions from poorly formatted webpages.

The `minio` container stores photos/images for the recipes. It could be replaced with AWS's S3 service if preferred. 

## Changelog

### v1.2.0

Update RecipeSage image to v2.9.0, ElasticSearch image to v8.4.3, and Browserless to 1.53.0.

**Upgrade note:** You must first upgrade your elasticsearch container image to v7.17 before upgrading to this new version.

### v1.1.1

Fix public access permissions for new minio installations. 

### v1.1.0

Move minio behind app proxy.

**Note:** If you're upgrading from an earlier version of these selfhost configs, you'll need to make sure to continue to expose 9000 on the Minio container in order to maintain access to images uploaded before this change, **or** update the image path in the DB.

### v1.0.0

Initial release.

