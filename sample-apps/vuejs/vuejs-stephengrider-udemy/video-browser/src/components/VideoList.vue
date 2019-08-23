<template>
    <ul class="list-group col-md-4">
        <!-- Create one VideoListItem for each video -->
        <!-- Also we want to convey video to child component VideoListItem, we will make use of props system -->
        <!-- We follow the same style as used for videos, v-bind:video makes temporary video available in VideoListItem -->
        <!-- key is used as optional with v-for for performance purposes -->
        <VideoListItem
                v-for="video in videos"
                :video="video"
                :key="video.etag"
                @videoSelect="onVideoSelect"
        >

        </VideoListItem>
    </ul>
</template>

<script>
import VideoListItem from './VideoListItem';

export default {
    name: "VideoList",
    // Child components are defined in components
    components: {
        VideoListItem
    },
    // To be tied with the v-bind:videos in the parent component i.e. App -->
    props: [
        'videos'
    ],
    methods: {
        onVideoSelect(video) {
            this.$emit('videoSelect', video);
        }
    }
}
</script>

<style scoped>

</style>