# フロントエンドパッケージ

## 01. npmによるパッケージの管理

### ```package.json```ファイルの実装

#### ・バージョンを定義

```json

```

<br>

### install

#### ・インストール

インストールされていないパッケージをインストールする．

```shell
$ npm install
```

#### ・インストール時の実行権限を無視する

パッケージのインストール時に，ディレクトリの実行権限不足でインストールが停止することがある．これを無視してインストールを行う．

```shell
$ npm install --force
```

<br>

### update

#### ・インストール，アップデート

インストールされていないパッケージをインストールする．また，バージョン定義をもとに更新可能なパッケージを更新する．

```shell
$ npm update
```

<br>

### run

ユーザが定義したエイリアス名のコマンドを実行する．

```shell
$ npm run <エイリアス名>
```

あらかじめ，任意のエイリアス名を```scripts```キー下に定義する．エイリアスの中で，実行するコマンドのセットを定義する．ちなみに，実行するコマンドの中で，再度```run```コマンドを定義することも可能である．

```json
{
    "scripts": {
        "<エイリアス名>": "<実行するコマンド>",
        "dev": "npm run development",
        "development": "cross-env NODE_ENV=development node_modules/webpack/bin/webpack.js --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js",
        "watch": "npm run development -- --watch",
        "watch-poll": "npm run watch -- --watch-poll",
        "hot": "cross-env NODE_ENV=development node_modules/webpack-dev-server/bin/webpack-dev-server.js --inline --hot --disable-host-check --config=node_modules/laravel-mix/setup/webpack.config.js",
        "prod": "npm run production",
        "production": "cross-env NODE_ENV=production node_modules/webpack/bin/webpack.js --no-progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js"
    }
}
```

<br>

### NODE_OPTIONS

#### ・メモリ上限をなくす

```shell
$ export NODE_OPTIONS="--max-old-space-size=2048"
```

