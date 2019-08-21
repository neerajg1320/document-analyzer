new Vue({
    el: '#app',
    data: {
        skills: []
    },
    mounted() {
        // Make an ajax request to our server

        // we will use axios
        axios.get('/skills')
            .then(response => this.skills = response.data);
    }
});