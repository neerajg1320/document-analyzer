window.Event = new Vue();

Vue.component('coupon', {
    template: '<input placeholder="Enter you coupon code" @blur="onCouponApplied">',
    methods: {
        onCouponApplied() {
            Event.$emit('applied', this.coupon);
        }
    }
})


new Vue({
    el: '#root',
    methods: {
        onCouponApplied() {
            this.couponApplied = true;
        }
    },
    data: {
        couponApplied: false
    },
    created() {
        Event.$on('applied', () => {
            alert('Received applied from Event');
        });
    }
});

