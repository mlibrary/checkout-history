FROM ruby:2.7.2
ARG UNAME=app
ARG UID=1000
ARG GID=1000

LABEL maintainer="mrio@umich.edu"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim

#so wait-for works
RUN apt install -y netcat

RUN gem install bundler:2.1.4


RUN groupadd -g ${GID} -o ${UNAME}
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash ${UNAME}
RUN mkdir -p /gems && chown ${UID}:${GID} /gems


COPY --chown=${UID}:${GID} Gemfile* /app/
USER $UNAME

ENV BUNDLE_PATH /gems

ENV ALMA_API_KEY YOUR_ALMA_API_KEY
ENV ALMA_API_HOST http://falma:4567
ENV CIRC_REPORT_PATH /circ/report/path
ENV PATRON_REPORT_PATH /patron/report/path
ENV MYSQL_ROOT_PASSWORD mysqlrootpassword
ENV DATABASE_HOST database

WORKDIR /app
RUN bundle install

COPY --chown=${UID}:${GID} . /app

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
