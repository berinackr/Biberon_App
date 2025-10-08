# Changelog

## [0.0.11](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.10...server-v0.0.11) (2024-08-28)


### Bug Fixes

* changed verify code to numbers and fixed google signin email verification ([324e7c8](https://github.com/av-erencelik/biberon-api/commit/324e7c8edd6f37295d46679df082c86d2e9ebddf))

## [0.0.10](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.9...server-v0.0.10) (2024-08-23)


### Features

* made api to accept rich text and store efficiently ([307cccb](https://github.com/av-erencelik/biberon-api/commit/307cccb4d20eab96949303b93f2a4a164f4260e9))

## [0.0.9](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.8...server-v0.0.9) (2024-06-21)


### Bug Fixes

* bookmark endpoint incorrect total answer count ([9c0211d](https://github.com/av-erencelik/biberon-api/commit/9c0211dffe00ffe4e68ae306f2116cacb473f9fa))

## [0.0.8](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.7...server-v0.0.8) (2024-05-22)


### Features

* added s3 integration with profile photo update endpoints ([0aa9a3c](https://github.com/av-erencelik/biberon-api/commit/0aa9a3c941e6fe61238d8cfcd9284d53bd75a30f))
* changed prisma client with kysely ([c6aa32a](https://github.com/av-erencelik/biberon-api/commit/c6aa32a85854661100aa3166463eb61ffffe574d))
* forum endpoints ([6aaf534](https://github.com/av-erencelik/biberon-api/commit/6aaf5347caedec875a2ee7ead712da22c7e35a74))

## [0.0.7](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.6...server-v0.0.7) (2024-04-04)


### Features

* fix dep ([eec05d4](https://github.com/av-erencelik/biberon-api/commit/eec05d48919dd97a8df92a7598cc4a5174c180c2))

## [0.0.6](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.5...server-v0.0.6) (2024-04-01)


### Features

* added fetus info to update and create pregnancy ([e52b0b3](https://github.com/av-erencelik/biberon-api/commit/e52b0b36e8b4aa79a05769fdb1cf587d5feb35b3))
* added patch endpoint for updating user profile ([5937dc3](https://github.com/av-erencelik/biberon-api/commit/5937dc3ce1c0c127a171b9abbab20ed7873052dc))
* refactor of profile creation ([d51d8ce](https://github.com/av-erencelik/biberon-api/commit/d51d8cea8db453d1bcc48f3803177c62ac7bf5c3))
* return only one baby on profile ([084953b](https://github.com/av-erencelik/biberon-api/commit/084953b78cc3c8e8e673bd6509f02736c5552522))


### Bug Fixes

* added missing validation error messages ([2f100b2](https://github.com/av-erencelik/biberon-api/commit/2f100b2a4a2e663a7be7e32d3f418a2cf0b4da29))
* create pregnancy with null values even if the user is not pregnant ([21998fe](https://github.com/av-erencelik/biberon-api/commit/21998fe808084c95c0a2e47f1bd4cd5f172327b9))
* create profile on social login ([f0e795e](https://github.com/av-erencelik/biberon-api/commit/f0e795e986b5c88686450cab1909a24521484497))

## [0.0.5](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.4...server-v0.0.5) (2024-03-07)


### Bug Fixes

* decrease image size ([d67cd2f](https://github.com/av-erencelik/biberon-api/commit/d67cd2fbfe6fff0e7d1dd514c91117d52f72bdb3))

## [0.0.4](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.3...server-v0.0.4) (2024-03-06)


### Bug Fixes

* db seed ([ee336c8](https://github.com/av-erencelik/biberon-api/commit/ee336c8648e3073dcd0a12fe3782e1f5d3215a97))

## [0.0.3](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.2...server-v0.0.3) (2024-03-06)


### Bug Fixes

* **docker:** seed database when env is dev ([33c835a](https://github.com/av-erencelik/biberon-api/commit/33c835a2f05727d2bb9e4f7e6eeb14f142933261))

## [0.0.2](https://github.com/av-erencelik/biberon-api/compare/server-v0.0.1...server-v0.0.2) (2024-03-06)


### Features

* added localization for errors ([c0a2fd6](https://github.com/av-erencelik/biberon-api/commit/c0a2fd67167ad840943bd016641ee34947292b6a))
* added verify and resend verify email endpoints ([c0a2fd6](https://github.com/av-erencelik/biberon-api/commit/c0a2fd67167ad840943bd016641ee34947292b6a))
* **user:** added forgot password endpoints ([7d05bec](https://github.com/av-erencelik/biberon-api/commit/7d05bec2e63075cc8705a0cec75c9bb50eaa5df6))
