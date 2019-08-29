const debug = true;

export default {

  async execute ({ client, method, url, token, data }) {
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
    if (token) {
      headers.Authorization = `token ${token}`;
    }

    if (Object.keys(headers).length > 0) {
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
