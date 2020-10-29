# Output Reading

Output Readingは読書した内容を投稿することで、気軽に本の内容をアウトプットできるアプリケーションです。

# DEMO

![demo](https://raw.githubusercontent.com/wiki/NakaiKazuki/output_reading/images/output_reading_demo.gif)

# Features

Output Readingでは他者がアウトプットした内容も確認することができます。  
その投稿が気に入った場合は投稿のお気に入り登録と投稿者をフォローすることができます。  
気になった本を購入する場合には、Output Reading内から楽天ブックスの商品リストを検索することが可能です。

# Requirement

* Docker
* docker-compose

# Installation

ローカル環境にDockerがインストールされていない場合は、個人の環境に合わせて下記のページからアカウント作成後にインストールしてください。

Mac    : [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)  
Windows: [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

下記のコマンドでインストールされているか確認できます。

```
$ docker -v
$ docker-compose -v
```
# Usage

このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。

```
$ git clone https://github.com/NakaiKazuki/output_reading.git
```

次にクローンしたリポジトリのディレクトリへ移動します。

```
$ cd output_reading
```

その後下記のコマンドでdockerimageを作成します。

```
$ docker-compose build
```

dockerimage作成後コンテナを起動します。

```
$ docker-compose up -d
```

コンテナ起動後に下記のコマンドでアプリのコンテナへ入ります。

```
$ docker-compose exec webapp bash
```

コンテナに入れたらデータベースへseedデータを作成します。

```
$ rails db:create db:migrate db:seed
```

その後test環境のデータベースへのマイグレーションを実行します。

```
$ rails db:migrate RAILS_ENV=test
```

テストを実行してうまく動いているかどうか確認してください。

```
$ rspec
```

テストが無事に通ったら、ブラウザからlocalhost:80に接続します。

```
http://localhost:80
```

画面右上の ログイン からログイン画面へ移動後、下記の内容を入力すると管理者権限を持ったユーザーとしてログインできます。

* メールアドレス: outputreading@example.com
* パスワード: password

# Note

本番環境:[Output Reading](https://www.output-reading.xyz/)

# Author

* 中井一樹
* Twitter : https://twitter.com/k_kyube

# License

Output Readingは[MITライセンス](https://en.wikipedia.org/wiki/MIT_License)のもとで公開されています。詳細は [LICENSE.md](https://github.com/NakaiKazuki/output_reading/blob/master/LICENSE.md) をご覧ください。
