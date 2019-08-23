import qs from 'qs';
import axios from 'axios';


const CLIENT_ID = '01a86889a163e57';
// const CLIENT_SECRET = 'bc17e1db2f7c0978279c9a664490c0c116792311';

const ROOT_URL = 'https://api.imgur.com';

export default {
    // https://api.imgur.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&response_type=REQUESTED_RESPONSE_TYPE&state=APPLICATION_STATE
    login() {
        const querystring = {
            client_id: CLIENT_ID,
            response_type: 'token',
        };

        window.location = `${ROOT_URL}/oauth2/authorize?${qs.stringify(
            querystring
        )}`;
    },

    // GET https://api.imgur.com/3/account/me/images
    fetchImages(token) {
        return axios.get(`${ROOT_URL}/3/account/me/images`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
    },

    // POST https://api.imgur.com/3/image - Uploads one at a time
    // The multiple returns have to be handled that means they have to return one promise
    // We have to take the list of promises and return one promise
    uploadImages(images, token) {
        const promises = Array.from(images).map(image => {
            const formData = new FormData();
            formData.append('image', image);

            return axios.post(`${ROOT_URL}/3/image`, formData, {
               headers: {
                   Authorization: `Bearer ${token}`
               }
            });
        });

        return Promise.all(promises);
    }
};