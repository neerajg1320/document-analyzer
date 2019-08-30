<template>
    <div>

        <div v-if="resource == 'operations' && instance.type == 'Extract'">
            <DataExtractorRegex></DataExtractorRegex>
        </div>
        <div v-if="resource == 'operations' && instance.type == 'Transform'">
            <DataTransformer></DataTransformer>
        </div>
        <div v-if="resource == 'operations' && instance.type == 'Load'">
            <DataLoader></DataLoader>
        </div>

        <div v-if="resource != 'operations'">
            <ResourceBasic></ResourceBasic>
        </div>
    </div>
</template>

<script>
  import resourceCompMixin from '../mixin/ResourceCompMixin';
  import DataExtractorRegex from '../pipeline/DataExtractorRegex';
  import DataTransformer from '../pipeline/DataTransformer';
  import DataLoader from '../pipeline/DataLoader';
  import ResourceBasic from './ResourceBasic';

  export default {
    name: "ResourceDynamicForm",
    mixins: [resourceCompMixin],
    components: { ResourceBasic, DataExtractorRegex, DataTransformer, DataLoader },
  }
</script>
