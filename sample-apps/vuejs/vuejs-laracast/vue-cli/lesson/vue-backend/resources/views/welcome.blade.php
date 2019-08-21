<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>


    </head>
    <body>

    <div id="app">
        <ul>
            <!-- @ is the way of the telling the blade compiler to ignore and let vue process -->
            <li v-for="skill in skills" v-text="skill"></li>
        </ul>
    </div>

    <!-- Since we are not using npm. We reference javascript libraries from CDN -->
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

    <script src="/js/app.js"></script>
    </body>
</html>
