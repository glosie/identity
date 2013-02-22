# identity

Based on the concept of web-based Heroku user management not belonging in the API over the long-term, Identity pulls session-based authentication out of API and provides a drop-in replacement for the Heroku OAuth API that OAuth clients can use instead.

OAuth session management is achieved without any special API permissions by a "meta-OAuth" provider implementation. Identity first authorizes itself to get access to a user's account, then authorizes other consumers that use it as a target by proxying calls to the API (but using only the JSON authentication APIs).

## Operations

See [operations](https://github.com/heroku/identity/tree/master/operations.md).

## Usage

``` bash
bundle install
foreman start
# check localhost:5000
```

## Platform Install

```
# should be the running domain of your app for cookies to work
heroku config:add COOKIE_ENCRYPTION_KEY=...
heroku config:add DASHBOARD_URL="https://dashboard.heroku.com"
heroku config:add HEROKU_API_URL="https://api.heroku.com"
heroku config:add HEROKU_OAUTH_ID=...
heroku config:add HEROKU_OAUTH_SECRET=...
git push heroku master
```

## Test

``` bash
bin/test
```

### Installations

* `id-production`: https://id.heroku.com
    * Consumed by:
        * `dashboard-dev`: https://dashboard-dev.herokuapp.com
        * `dashboard-staging`: https://dashboard-dev.herokuapp.com
        * `oauth-example`: https://oauth-example.herokuapp.com
* `id-staging`: https://id-staging.herokuapp.com
    * Consumed by:
        * `dashboard-brandur`: https://dashboard-brandur.herokuapp.com
        * `oauth-example-staging`: https://oauth-example-staging.herokuapp.com
