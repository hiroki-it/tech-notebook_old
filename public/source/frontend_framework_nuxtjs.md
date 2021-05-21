# Nuxt.js

## コマンド

### build

Targetオプションに```server```を割り当て，アプリケーションをWebpackでビルドする．Webpackにより，JavaScriptとCSSはminifyされる．minifyにより，不要な改行やインデントが削除され，動作はそのままで圧縮される．テストフレームワークはNode.jsを使用して動かす必要があるため，SSGアプリケーションでもテスト時には```build```コマンドが必要になる．

```shell
$ nuxt build
```

<br>

### generate

Targetオプションに```static```を割り当て，静的ファイルをビルドする．データベースに格納したデータ（例：画像ファイルパス）を元にビルドすることも可能である．

```shell
$ nuxt generate
```

<br>

## 設定ファイル

### ```env```ファイル

```sh
# API側のURL（フロントエンドからのリクエスト向け）
API_URL=http://web:80/
# API側のURL（外部サーバからのリクエスト向け）
API_URL_BROWSER=http://localhost:8500/
# API側のOauth認証の情報
OAUTH_CLIENT_ID=
OAUTH_CLIENT_SECRET=
# GoogleMapのURL
GOOGLE_MAP_QUERY_URL=https://www.google.com/maps/search/?api=1&query=
# ホームパス
HOME_PATH=/
```

<br>

### ```nuxt.config.js```ファイル

Nuxtが標準で用意している設定を上書きできる．

参考：https://ja.nuxtjs.org/docs/2.x/directory-structure/nuxt-config#nuxtconfigjs

```javascript
import { Configuration } from '@nuxt/types'

const nuxtConfig: Configuration = {

}
```



