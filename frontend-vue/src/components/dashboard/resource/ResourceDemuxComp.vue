<template>
    <div>

        <div v-if="resource == 'operations'">
            <div v-if="instance.type == 'Extract'">
                <DataExtractorRegex></DataExtractorRegex>
            </div>
            <div v-if="instance.type == 'Transform'">
                <DataTransformer></DataTransformer>
            </div>
            <div v-if="instance.type == 'Load'">
                <DataLoader></DataLoader>
            </div>
        </div>

        <div v-if="resource != 'operations'">
            <BasicComp></BasicComp>
        </div>
    </div>
</template>

<script>
  import resourceCompMixin from '../mixin/ResourceCompMixin';
  import DataExtractorRegex from '../pipeline/DataExtractorRegex';
  import DataTransformer from '../pipeline/DataTransformer';
  import DataLoader from '../pipeline/DataLoader';
  import BasicComp from './BasicComp';

  export default {
    name: "ResourceDynamicForm",
    mixins: [resourceCompMixin],
    components: { BasicComp, DataExtractorRegex, DataTransformer, DataLoader },
  }
</script>
