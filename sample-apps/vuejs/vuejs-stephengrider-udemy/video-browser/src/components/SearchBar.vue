<template>
    <div>
        <!-- <input v-on:input="onInput"/> -->
        <input @input="onInput"/>
    </div>
</template>

<script>
export default {
    name: "SearchBar",
    methods: {
        onInput: function(event) {
            // console.log(event.target.value);
            this.$emit('termChange', event.target.value);
        }
    }
}
</script>

<!-- scoped ensures that css is applied to template in this component only -->
<style scoped>
    input {
        width: 75%;
    }

    div {
        text-align: center;
        margin: 20px;
    }
</style>