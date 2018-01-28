const gulp     = require('gulp'),
      sass     = require('gulp-sass'),
      hash     = require('gulp-hash'),
      prefixer = require('gulp-autoprefixer'),
      del      = require('del');

const SRCS = {
  sass: 'source/sass/**/*.sass',
  js:   'source/js/**/*.js'
}

const DIST = {
  css: 'static/css',
  js: 'static/js'
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
  del(['static/css/style-*.css']);

  gulp.src(SRCS.sass)
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(hash())
    .pipe(prefixer({
      browsers: ['last 2 versions'],
      cascade: false
    }))
    .pipe(gulp.dest(DIST.css))
    .pipe(hash.manifest('css.json'))
    .pipe(gulp.dest('data'));

  done();
});

gulp.task('sass:watch', () => {
  gulp.watch(SRCS.sass, gulp.series('sass-dev'));
});

gulp.task('build', gulp.series('sass'));

gulp.task('dev', gulp.series('sass-dev', gulp.parallel('sass:watch')));
