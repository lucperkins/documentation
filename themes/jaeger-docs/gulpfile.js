const gulp = require('gulp'),
      sass = require('gulp-sass'),
      del  = require('del');

const SRCS = {
  sass: 'source/sass/**/*.sass',
  js:   'source/js/**/*.js'
}

const DIST = {
  css: 'dist/css',
  js: 'dist/js'
}

gulp.task('sass', (done) => {
  gulp.src(SRCS.sass)
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(gulp.dest(DIST.css));
  done();
});

gulp.task('sass-dev', (done) => {
  del(['dist/css/style-*.css']);

  gulp.src(SRCS.sass)
    .pipe(gulp.dest())

  done();
});

gulp.task('sass:watch', () => {
  gulp.watch(SRCS.sass, gulp.series('sass-dev'));
});

gulp.task('build', gulp.series('sass'));

gulp.task('dev', gulp.parallel('sass-watch'));
