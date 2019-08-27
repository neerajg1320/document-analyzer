<template>
    <div>
        <h1>Operation List</h1>
        <ul>
            <li v-for="operation in instances" :key="operation.id">
                <OperationCard :instance="operation"></OperationCard>
            </li>
        </ul>
    </div>
</template>

<script>
  import OperationCard from './OperationCard';

  export default {
    name: "OperationList",
    components: {
      OperationCard
    },
    props: ['instances']
  }
</script>

<style scoped>

</style>
