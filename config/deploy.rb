# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

# Capistranoでの必須の設定
set :application, "output_reading"
set :repo_url, "git@github.com:NakaiKazuki/output_reading.git"

# タスクでsudoなどを行う際に必要
set :pty, true
# シンボリックリンクのファイルを指定、具体的にはsharedに入るファイル
append :linked_files, "config/master.key"
# シンボリックリンクのディレクトリを生成
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "public/storage"
# 環境変数の設定
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
# 保存しておく過去分のアプリ数
set :keep_releases, 3

namespace :deploy do
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rails, 'db:create'
        end
      end
    end
  end
end
