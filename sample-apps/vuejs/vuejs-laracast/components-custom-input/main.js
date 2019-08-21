Vue.component('coupon', {
    props: ['code'],
    template: `
        <input type="text" :value="code" @input="updateCode($event.target.value)" ref="input">
    `,
    methods: {
        updateCode(code) {
            // Any validation if required
            if (code === 'ALLFREE') {
                alert('This coupon is expired!')
                this.$refs.input.value = '';
            }
            this.$emit('input', code);
        }
    }
})

new Vue({
    el: '#app',

    data: {
        coupon: 'FREEBIE'
    }
})

