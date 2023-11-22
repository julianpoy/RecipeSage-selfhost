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

1. You'll need Docker to run [RecipeSage](https://recipesage.com) locally. Although you _can_ attempt to run it without Docker, you're on your own.
2. Start all containers with `docker compose up -d`
3. On first run, and when updating, you'll need to run database migrations with `./migrate.sh`
4. The app should be available at port 80. You can change that by changing [this](https://github.com/julianpoy/RecipeSage-selfhost/blob/a1133c51af24ca78f9bc9537e147411b5e7e311a/docker-compose.yml#L8) to something else, such as `3000:80` for port 3000.

### Updating

First, take a look at the changelog below for any special upgrade notes. Then follow the steps below.

As with any migration/upgrade, I recommend taking a backup of your volumes before migrating to avoid any potential data loss.

Update your local copy of this repo with the latest from this repository. If cloned with Git, this is as simple as `git pull`.

Update your local images: `docker compose pull`.

Then, down & up the containers: `docker compose down --remove-orphans && docker compose up -d`

Finally, run any pending migrations with `./migrate.sh`

<br />


## Customization

The following sections provide some information on customizing your instance. Following the "setup" section is enough to get you running with a RecipeSage instance like that of the official site.

### Disabling Registration  

If you want to disable registration, **after** you have registered yourself as a user, add this to the top of the docker environment variables: 
`DISABLE_REGISTRATION=true` 

Then, down & up the containers: `docker compose down && docker compose up -d`

When registration is disabled, the registration screen will still appear but will fail with an error if anyone tries to register.

### Bonus Features

The "bonus features" from the hosted version can be activated by running the following command (swap out the email address with your account email).
Please contribute to the development & maintenance of RecipeSage at https://recipesage.com/#/contribute -- Julian.

`./activate.sh example@example.com`

### FAQ

#### Ingredient instruction classifier container repeatedly crashing

It's fairly common that older CPUs (often shipped in prebuilt NASes) do not support the AVX instruction set required to run the machine learning model that the ingredient-instruction-classifier hosts. You'll an error message such as this one when encountering this issue:

> Illegal Instruction (core dumped)

Since the ingredient-instruction-classifier container is not _required_ by RecipeSage, it can be removed/disabled from the docker-compose file if you don't have AVX instruction set support. Without the ingredient-instruction-classifier container, the automatic recipe import feature will still work on the majority of sites, but will be unable to pull content from sites that are particularly poorly formatted, or that have no metadata at all.

#### I'm seeing an "unexpected error occurred" error when trying to register

This is most frequently because the migration script has not been run successfully. Note that if you change the name of the containers in the docker-compose file, the migration script will not be able to run the required migration script within the container, and you must do so by exec-ing into the container yourself, similar to what the script does.

#### Container Structure

This section is here just to explain the purpose of each container and why it's necessary. Following Docker principles, every part of the application is compartmentalized into it's own container with it's own singular responsibility. I've described what role each plays in making the application do what it does.

The `proxy` container facilitates divvying up requests between the `api`, the `static` (frontend, and the `minio` container. Without it, you'd need to route requests yourself, such as properly directing requests that head to `/api/*` to the `api` container, and requests that go to any other path on `/*` to the `static` container.

The `static` container is a very simple image with the prebuilt frontend assets for that version of RecipeSage. The application cannot run without it.

The `api` container facilitates all data storage for the application. The application cannot run without it.

The `elasticsearch` container facilitates the hyper-accurate fuzzysearch for the app. Without it, search within the app will not work.

The `pushpin` container is a broker for all websocket connections. Without it, all realtime interactions between multiple users won't work and will require a reload to get new content, such as when a shopping list item is checked off.

The `postgres` container is the database. The application cannot run without it.

The `browserless` container is a virtual web browser that is used to scrape recipe data when you paste a URL into the "autofill" feature of the app. Without it, the recipe scraper _should still work_, but will fall back to JSDOM which will be significantly less accurate and may contain formatting errors.

The `ingredient-instruction-classifier` container facilitates machine learning classification of ingredients and instructions, which is used to improve accuracy during the "autofill" feature. Without it, the recipe _should still work_, but will be a bit less accurate or may not be able to pull ingredients or instructions from poorly formatted webpages.

## Changelog

### v3.1.0

`docker-compose` has been officially deprecated, so the app has migrated to using `docker compose`.

Full ARM64 support is now official. All containters have associated ARM64 platform builds.

### v3.0.0

ElasticSearch has been removed in favor of TypeSense. You can remove any old ElasticSearch related containers or volumes if you choose (though the application still remains fully compatible with ElasticSearch, should you keep `SEARCH_PROVIDER` as elasticsearch as well as ElasticSearch related environment variables the same).

No data will be lost if you choose to switch to TypeSense. TypeSense will be populated on your first login to the app after upgrading. TypeSense is faster for RecipeSage purposes, as well as less memory-intensive.

### v2.0.0

Revamp selfhosting configs. Use local filesystem rather than minio.

**Important upgrade notes:**
(none of this applies to new users, only those with existing data)

The new docker compose.yml no longer uses minio, and instead writes directly to the local filesystem.
You'll need to keep your minio instance from the [old Dockerfile](https://github.com/julianpoy/RecipeSage-selfhost/blob/13dd943fb1c9a9d0d74cb1af21ef40bd585e2033/docker-compose.yml#L100-L108) along with it's [volume definition](https://github.com/julianpoy/RecipeSage-selfhost/blob/main/docker-compose.yml#L126-L127).

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

