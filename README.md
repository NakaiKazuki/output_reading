# Output Reading

Output Readingでは読んだ本の内容を章ごとに分けてアウトプットし、その内容をいつでも確認することが可能なアプリケーションです。  

# デモ

![demo](https://raw.githubusercontent.com/wiki/NakaiKazuki/output_reading/images/output_reading_demo.gif)

# 特徴

Output Readingでは読んだ本の内容を章ごとに分けて書き出すことで、その章の内容をより深く掘り下げることができます。  
章ごとに分割して投稿することができるため、見返す場合には投稿内容が本のどのあたりに書かれているかがすぐ確認できます。  

また、Output Readingでは他者が書き出した本の内容も確認することができます。   
その投稿が気に入った場合は投稿のお気に入り登録と投稿者をフォローすることができます。  
投稿を見て気になった本を購入する場合には、Output Reading内から楽天ブックスの商品リストを検索することが可能です。

# 必要要件

* Docker
* docker-compose

#  インストール

ローカル環境にDockerがインストールされていない場合は、下記のリンクからアカウント作成後にインストールしてください。

[Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)  

下記のコマンドでインストールされているか確認できます。

```
$ docker -v
$ docker-compose -v
```

# 使い方

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

#　その他

本番環境:[Output Reading](https://www.output-reading.xyz/)  

本番環境のページではユーザー登録無しで下記の機能を利用することが可能です。
* 投稿タイトル一覧の確認
* 投稿の詳細の確認
* 投稿者のプロフィール確認
* 楽天ブックスで検索

# 作者

* 中井一樹
* Twitter : https://twitter.com/k_kyube

# ライセンス

Output Readingは[MITライセンス](https://en.wikipedia.org/wiki/MIT_License)のもとで公開されています。詳細は [LICENSE.md](https://github.com/NakaiKazuki/output_reading/blob/master/LICENSE.md) をご覧ください。
