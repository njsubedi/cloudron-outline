Outline is set up to authenticate only with an existing OIDC server, like Cloudron itself.

On your OIDC Provider, follow these steps:

1. Create a new client called `outline_app`, and set access type to *Confidential*.
2. Set valid *Redirect URL* to `<outline.example.com>/auth/oidc.callback`, replacing `outline.example.org` with the
   domain where Outline is installed.
3. Note down the *Client ID* and *Client Secret*.
4. On the Outline app, add/set the following values to the `/app/data/env` file using the terminal or File manager, then
   restart the app.

```yaml
# Display name to show on login page. Eg. "Log in with My Cloudron".
OIDC_DISPLAY_NAME="My Cloudron"
OIDC_USERNAME_CLAIM=preferred_username
OIDC_SCOPES="openid profile email"

# The Client ID and Client Secret from the OIDC Server.
OIDC_CLIENT_ID=<your-client-id>
OIDC_CLIENT_SECRET=<your-client-secret>

# Required URLs for authentication using Oauth 2.0
# For example, on Keycloak running on the domain <auth.example.com>
# And, the client is added to the reaml called "cloudron"
OIDC_AUTH_URI=https://my.example.com/openid/auth
OIDC_TOKEN_URI=https://my.example.com/openid/token
OIDC_USERINFO_URI=https://my.example.com/openid/me



```

Once the app is restarted, you should see an option to log in with your OIDC server.