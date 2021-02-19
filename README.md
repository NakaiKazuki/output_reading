# Output Reading
 Railsチュートリアルの復習として、読んだ本をアウトプットするためのアプリを作成しました。<br >
 他社の投稿も閲覧することができ、気になった本があれば楽天ブックスから検索できるようにしています。 <br >
 スマホからもご利用いただけます。

# URL
https://output-reading.xyz/ <br >
画面中央の「ゲストログイン」のボタンから、メールアドレスとパスワードを入力せずにログインできます。
ゲストユーザーは登録情報の編集と削除のみを制限しています。

# 使用技術
- Ruby 2.7.2
- Ruby on Rails 6.0.3.4
- MySQL 5.7
- Nginx
- Puma
- AWS
  - VPC
  - EC2
  - RDS(MySQL)
  - Route53
  - S3
  - Certificate Manager
- Docker/Docker-compose
- Capistrano3
- RSpec
- 楽天ブックス書籍検索API

# 機能一覧
- ユーザー登録、ログイン機能
- 投稿機能
  - 画像投稿(carrierwave)
    - 本番環境ではS3に保存
- お気に入り機能(Ajax)
- ページネーション機能(kaminari)
- 検索機能(ransack)
- 楽天ブックス書籍検索機能(rakuten_web_service)

# テスト
- RSpec
  - モデルテスト(model)
  - コントローラーテスト(request)
  - ブラウザテスト(system)

# ローカルで使用する場合(開発環境はDockerを利用して構築します)
リポジトリを手元にクローンしてください。

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
$ rails db:create db:migrate db:seed && rails db:migrate RAILS_ENV=test
```

# 制作者

* 中井一樹
* Twitter : https://twitter.com/k_kyube

# ライセンス

Output Readingは[MITライセンス](https://en.wikipedia.org/wiki/MIT_License)のもとで公開されています。詳細は [LICENSE.md](https://github.com/NakaiKazuki/output_reading/blob/master/LICENSE.md) をご覧ください。