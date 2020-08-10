# バックエンドのデバッグの豆知識

## 01. ```var_dump()```によるデバッグ

### ローカル環境 vs テスト環境

ローカル環境とテスト環境で，ブラウザのデベロッパーツール＞Network＞出力先ページのPreviewタブまたはResponseタブを比較し，キーや配列に格納されている値がどう異なっているかを調べる．　



### ```var_dump($var)```

#### ・変数の中身の確認方法

ブラウザのデベロッパーツール＞Network＞出力先ページのPreviewタブまたはResponseタブ，で確認することができる．

#### ・小ネタ

変数の中身が出力されていなかったら，```exit```をつけてみる．



### ```var_dump($var)``` & ```throw new \Exception("")```

#### ・変数の中身の確認方法

ブラウザのデベロッパーツール＞Network＞出力先ページのPreviewタブで例外エラー画面が表示される．エラー画面の上部で，```var_dump($var)```の結果を確認することができる．

#### ・小ネタ

クラスを読み込むために，```Exception```の前に，```\```（逆スラッシュ）をつけること．



### ```throw new \Exception(var_dump($var))```

#### ・変数の中身の確認方法

ブラウザのデベロッパーツール＞Network＞出力先ページのPreviewタブで例外エラー画面が表示される．例外エラーの内容として，```var_dump($var)```の結果を確認することができる．

#### ・小ネタ

クラスを読み込むために，```Exception```の前に，```\```（逆スラッシュ）をつけること．



### ```var_dump()```の結果がうまく表示されない時の対処方法

#### ・ロジックが別のところを通過している

この場合，```var_dump()```を通過していないと考えられる．いろいろなところで，```var_dump("文字列")```を行い，どこにロジックが通過しているのかを確認する．

#### ・文字コードが異なる

以下を，```var_dump()```よりも上流に追加する．

```PHP
<?php
header('Content-Type: text/html; charset=UTF-8');
```



## 02. Xdebugによるデバッグ

### 導入方法

#### 1. ローカルサーバへのインストール

ローカルサーバで以下のコマンドを実行．

```bash
sudo pecl install xdebug-2.2.7
```

#### 2. Xdebugの設定

Xdebugのあるローカルサーバから見て，PhpStromビルトインサーバを接続先と見なす．

```ini
zend_extension=/usr/lib64/php/modules/xdebug.so

xdebug.default_enable=1
# リモートデバッグの有効化．
xdebug.remote_enable=1

# DBGプロトコル
xdebug.remote_handler=dbgp

# エディタサーバのプライベートIPアドレス．
xdebug.remote_host=10.0.2.2

# エディタサーバの解放ポート．
xdebug.remote_port=9001

# 常にデバッグセッションを実行．
xdebug.remote_autostart=1

# DBGpハンドラーに渡すIDEキーを設定．
xdebug.idekey=PhpStorm
```

#### 3. ローカルサーバを再起動

```bash
sudo service httpd restart
```

#### 4. PhpStormビルトインサーバの設定



### デバッグにおける通信の仕組み

#### 1. エディタサーバの構築

エディタはサーバを構築し，ポート```9000```を開放する．

#### 2. エディタからデバッガーエンジンへのリクエスト

デバッガーエンジン（Xdebug）はポート```80```を開放する．エディタサーバはこれに対して，セッション開始のリクエストをHTTPプロトコルで送信する．

#### 3. デバッガーエンジンからサーバへのリクエスト

デバッガーエンジン（Xdebug）はセッションを開始し，エディタサーバのポート```9000```に対して，レスポンスを送信する．

#### 4. Breakpointの設定

エディタサーバは，デバッガーエンジンに対して，Breakpointを設定するリクエストを送信する．

#### 5. DBGプロトコル：Debuggerプロトコルによる相互通信の確立

DBGプロトコルを使用し，エディタサーバとデバッガーエンジンの間の相互通信を確立する．

#### 6. 相互通信の実行

エディタは，デバッガーエンジンに対してソースコードを送信する．デバッガーエンジンは，Breakpointまでの各変数の中身を解析し，エディタサーバに返信する．

![Xdebug仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Xdebug仕組み.png)

