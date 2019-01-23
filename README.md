olragon/drupal-test
-------------------

## Run `olragon/drupal-test` and expose nginx to host port 8888

`docker run --name drupal-test -p 127.0.0.1:8888:80 --rm -t -i olragon/drupal-test`

## Run bash

`docker exec -i -t drupal-test /bin/bash`

## Run simpletest with Gitlab CI

Create file `.gitlab-ci.yml` and enable Gitlab's Pipelines for your project.
```yml
image: olragon/drupal-test
services:
  - mysql:latest
variables:
  MYSQL_DATABASE: "[MYSQL_DB_HERE]"
  MYSQL_ROOT_PASSWORD: "[MYSQL_PASSWORD_HERE]"
stages:
  - test
SimpleTest:
  stage: test
  script:
    - "CPUS_COUNT=`cat /proc/cpuinfo | grep processor | wc -l`"
    - "service nginx start && service php7.0-fpm start"
    - "rm -rf /var/www && pushd /var && drush dl drupal-7.x --drupal-project-rename=www"
    - "popd && cp -r ./ /var/www/sites/all/modules"
    - "cd /var/www && drush -y si --db-url=\"mysql://root:$MYSQL_ROOT_PASSWORD@mysql:3306/$MYSQL_DATABASE\" --account-name=admin --account-pass=123456 --site-name=\"$CI_PROJECT_NAME $CI_BUILD_REF_NAME\""
    - "drush -y en simpletest restws"
    - "php scripts/run-tests.sh --url http://localhost --concurrency $CPUS_COUNT --verbose --color --class RestWSBatchTestCase,RestWSTestCase"
```
