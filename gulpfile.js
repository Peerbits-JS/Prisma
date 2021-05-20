const gulp = require('gulp')
const sass = require('gulp-sass')
const path = require('path')

gulp.task('sass', function () {
    return gulp.src(path.resolve('../F3M/sass/f3m/**/*.scss'))
        .pipe(sass())
        .pipe(gulp.dest(path.resolve('../F3M/Content/f3m')))
});