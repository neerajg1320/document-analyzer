const debug = true;

export default {

  async execute ({ client, method, url, auth_token, data }) {
    // When you authenticate with OIDC, an access token is persisted locally
    // in the browser.
    // Inject the accessToken for each request
    // let accessToken = await Vue.prototype.$auth.getAccessToken()
    const request = {
      method,
      url: url,
    };

    if (data) {
      request.data = data;
    }

    const headers = {};
    if (auth_token) {
      headers.Authorization = `token ${auth_token}`;
    }

    if (headers.length > 0) {
      request.headers = headers;
    }

    if (debug) {
      console.log("request:", request);
    }

    return client(request)
      .then(response => {
        if (debug) {
          console.log("response", response);
        }
        return response.data
      })
  },
}
