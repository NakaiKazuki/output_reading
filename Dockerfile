# 元にするイメージ
FROM ruby:2.6.6
# コンテナを機能させるまでの準備のコマンドを実行する
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs imagemagick

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
RUN mkdir -p tmp/sockets
# コンテナ起動時のポートを設定する
EXPOSE 3000
