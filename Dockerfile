# 元にするイメージ
FROM ruby:2.7.2
# コンテナを機能させるまでの準備のコマンドを実行する
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs imagemagick vim

RUN mkdir /output_reading_docker
# 環境変数を設定する
ENV APP_ROOT /output_reading_docker
# コマンドを実行するディレクトリを設定する
WORKDIR $APP_ROOT
# ホストのファイルをコンテナにコピーする
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
# 既出
RUN gem install bundler
RUN bundle install
COPY . $APP_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN mkdir -p tmp/sockets
