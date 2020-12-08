# 元にするイメージ
FROM ruby:2.6.6
# コンテナを機能させるまでの準備のコマンドを実行する
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs imagemagick 

# 署名を追加(chromeのインストールに必要) -> apt-getでchromeと依存ライブラリをインストール
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qq \
    && apt-get install -y google-chrome-stable libnss3 libgconf-2-4

# chromedriverの最新をインストール
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/

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
