const gulp     = require('gulp'),
      sass     = require('gulp-sass'),
      hash     = require('gulp-hash'),
      prefixer = require('gulp-autoprefixer'),
      uglify   = require('gulp-uglify'),
      concat   = require('gulp-concat'),
      del      = require('del');

const SRCS = {
  sass: 'source/sass/**/*.sass',
  js:   'source/js/**/*.js'
}

const DIST = {
  css: 'static/css',
  js: 'static/js'
}

gulp.task('js', (done) => {
  gulp.src(SRCS.js)
    .pipe(uglify())
    .pipe(concat('app.js'))
    .pipe(gulp.dest(DIST.js));

  done();
});

gulp.task('js-dev', (done) => {
  del(['static/js/app-*.js']);

  gulp.src(SRCS.js)
    .pipe(uglify())
    .pipe(concat('app.js'))
    .pipe(hash())
    .pipe(gulp.dest(DIST.js))
    .pipe(hash.manifest('js.json'))
    .pipe(gulp.dest('data'));

  done();
});

gulp.task('js:watch', () => {
  gulp.watch(SRCS.js, gulp.series('js-dev'));
});

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
    .pipe(prefixer({
      browsers: ['last 2 versions'],
      cascade: false
    }))
    .pipe(hash())
    .pipe(gulp.dest(DIST.css))
    .pipe(hash.manifest('css.json'))
    .pipe(gulp.dest('data'));

  done();
});

gulp.task('sass:watch', () => {
  gulp.watch(SRCS.sass, gulp.series('sass-dev'));
});

gulp.task('build', gulp.series('js', 'sass'));

gulp.task('dev', gulp.series('js-dev', 'sass-dev', gulp.parallel('js:watch', 'sass:watch')));
