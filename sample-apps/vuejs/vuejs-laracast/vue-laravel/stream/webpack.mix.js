let mix = require('laravel-mix');


// mix.js('src/app.js', 'dist/').sass('src/app.scss', 'dist/');

mix.js('resource/js/app.js', 'public/js')
    .sass('resource/sass/app.js', 'public/css');
