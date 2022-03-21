FROM registry.gitlab.insales.ru/dev/rubybase/builder/2.7-ubuntu20.04:latest as builder
ARG RAILS_ENV=production
ADD . /app
WORKDIR /app
RUN sed -i 's/archive.ubuntu.com/ru.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y libldap-dev libsasl2-dev
RUN cp config/database.yml.template config/database.yml
# RUN cp config/secrets.yml.k8s config/secrets.yml
RUN bundle check --deployment --path=vendor --without development:test || bundle install --deployment --jobs=4 --path=vendor  --without development:test
RUN bundle exec rake assets:precompile


FROM nginx:stable-alpine
COPY --from=builder /app/public/ /public/
COPY public /public/
RUN find /public/ -type f  -exec gzip -k -9 {} \;
COPY devops/nginx/default.conf /etc/nginx/conf.d
