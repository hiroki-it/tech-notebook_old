# 目次

<!-- TOC -->

- [01-01. 仮想サーバ（仮想マシン）vs. コンテナ](#01-01-仮想サーバ仮想マシンvs-コンテナ)
    - [:pushpin: ホスト型仮想化](#pushpin-ホスト型仮想化)
    - [:pushpin: ハイパーバイザー型仮想化](#pushpin-ハイパーバイザー型仮想化)
    - [:pushpin: コンテナ型仮想化](#pushpin-コンテナ型仮想化)
- [01-02. 各仮想化のパフォーマンスの比較](#01-02-各仮想化のパフォーマンスの比較)
    - [:pushpin: 起動速度の違い](#pushpin-起動速度の違い)
    - [:pushpin: 処理速度の違い](#pushpin-処理速度の違い)
- [02-01. Providerによる仮想サーバ（仮想マシン）の構築](#02-01-providerによる仮想サーバ仮想マシンの構築)
    - [:pushpin: Providerの操作](#pushpin-providerの操作)
    - [:pushpin: Provisionerの操作](#pushpin-provisionerの操作)
    - [:pushpin: VagrantによるProviderとProvisionerの操作](#pushpin-vagrantによるproviderとprovisionerの操作)
- [03-01. Symfonyによるビルトインサーバの構築](#03-01-symfonyによるビルトインサーバの構築)
- [04-01. Dockerによるコンテナの構築](#04-01-dockerによるコンテナの構築)
    - [:pushpin: Dockerの操作](#pushpin-dockerの操作)
- [04-02. コンテナにssh接続するまでの手順](#04-02-コンテナにssh接続するまでの手順)
    - [:pushpin: 手順の流れ](#pushpin-手順の流れ)
    - [:pushpin: ベースとなるDockerイメージのインストール](#pushpin-ベースとなるdockerイメージのインストール)
    - [:pushpin: ベースとなるDockerイメージのカスタマイズとビルド](#pushpin-ベースとなるdockerイメージのカスタマイズとビルド)
    - [:pushpin: コンテナレイヤーの生成，コンテナの構築](#pushpin-コンテナレイヤーの生成コンテナの構築)
    - [:pushpin: 構築されたコンテナの起動／停止](#pushpin-構築されたコンテナの起動／停止)
    - [:pushpin: 起動中のコンテナにssh接続](#pushpin-起動中のコンテナにssh接続)
- [04-03. コンテナの種類](#04-03-コンテナの種類)
    - [:pushpin: Data Volumeコンテナ](#pushpin-data-volumeコンテナ)
- [04-04. コンテナ間の仮想ネットワーク](#04-04-コンテナ間の仮想ネットワーク)
    - [:pushpin: bridgeネットワーク](#pushpin-bridgeネットワーク)
    - [:pushpin: noneネットワーク](#pushpin-noneネットワーク)
    - [:pushpin: hostネットワーク](#pushpin-hostネットワーク)
- [04-05. docker-compose.ymlによる全手順の自動化](#04-05-docker-composeymlによる全手順の自動化)
    - [:pushpin: docker-compose.ymlの記述方法](#pushpin-docker-composeymlの記述方法)
- [05-01. ライブラリとパッケージ](#05-01-ライブラリとパッケージ)
    - [:pushpin: ライブラリとパッケージの大まかな違い](#pushpin-ライブラリとパッケージの大まかな違い)
    - [:pushpin: ライブラリマネージャ](#pushpin-ライブラリマネージャ)
    - [:pushpin: パッケージマネージャ](#pushpin-パッケージマネージャ)

<!-- /TOC -->
## 01-01. 仮想サーバ（仮想マシン）vs. コンテナ

自身の開発環境でWebサイトを動かしたい場合，まず，パソコン内にLinux環境のWebサーバ，APサーバ，DBサーバなどの物理サーバを仮想的に構築する．そして，自身のパソコンをクライアント，各仮想サーバをリクエスト先に見立てて，SSHプロトコルを用いてこれらのサーバにリモートログインする．仮想環境の構築方法にはいくつか種類がある．

### :pushpin: ホスト型仮想化

ホストOS上で，各サーバを仮想的に構築する．

**【Provider例】**

VMware Workstation，Oracle VM VirtualBox

![ホスト型仮想化](https://user-images.githubusercontent.com/42175286/60386396-3afbd080-9acf-11e9-9094-f61aa839dc04.png)



### :pushpin: ハイパーバイザー型仮想化

BIOSから起動したハイパーバイザー上で，各サーバを仮想的に構築する（※ホストOSは用いない）．

**【Provider例】**

VMware vSphere Hypervisor，Xen，KVM

![ハイパーバイザー型仮想化](https://user-images.githubusercontent.com/42175286/60386395-3afbd080-9acf-11e9-9fbe-6287753cb43a.png)



### :pushpin: コンテナ型仮想化

ホストOS上で，サーバではなく，サーバとしての機能を持つコンテナを仮想的に構築する．カーネルのリソースを分割できるNamespace（PID namespace，Network namespace，UID namespace）とControl Groupsを用いて，単一のOS上に独立したコンテナを構築する．

→ DockerToolboxがちょい違う

**【Provider例】**

Docker，LXC，OpenVZ

![コンテナ型仮想化](https://user-images.githubusercontent.com/42175286/60386394-3afbd080-9acf-11e9-96fd-321a88dbadc5.png)



## 01-02. 各仮想化のパフォーマンスの比較

### :pushpin: 起動速度の違い

ホスト型とハイパーバイザ型では，ハードウェア（CPU，メモリ，ハードディスク）とゲストOSを仮想化することが必要である．一方で，コンテナ型では，ハードウェアとゲストOSの仮想化は行わず，namespaceを用いてコンテナを構成するため，その分起動が速い．

![サーバ仮想化](https://user-images.githubusercontent.com/42175286/60386143-57e2d480-9acc-11e9-88b7-99a566346aba.png)



### :pushpin: 処理速度の違い

ゲストOS上のアプリを操作する場合，ホスト型とハイパーバイザ型では，ハードウェアやハイパーバイザーを経由する必要がある．この分だけ，時間（Overhead）を要する．一方で，コンテナ型では，各コンテナがホストOSとカーネルを共有するため，Overheadが小さい．

![仮想化](https://user-images.githubusercontent.com/42175286/60386143-57e2d480-9acc-11e9-88b7-99a566346aba.png)

- **Overheadの比較**

sysbenchというベンチマークツールを用いて，CPU・メモリ・ファイルI/Oに着目し，物理マシン・コンテナ型仮想化（Docker）・ホスト型仮想化（VirtualBox）のパフォーマンスを比較．

![各仮想化の比較](https://user-images.githubusercontent.com/42175286/60386476-27049e80-9ad0-11e9-92d8-76eed8927392.png)



## 02-01. Providerによる仮想サーバ（仮想マシン）の構築

![Vagrantの仕組み_オリジナル](https://user-images.githubusercontent.com/42175286/60393574-b18de200-9b52-11e9-803d-ef44d6e50b08.png)



### :pushpin: Providerの操作

基本ソフトウェアにおける制御プログラムや一連のハードウェアを仮想的に構築できる．これを，仮想サーバ（仮想マシンとも）という．構築方法の違いによって，『ホスト型』，『ハイパーバイザ型』に分類できる．



### :pushpin: Provisionerの操作

Providerによって構築された仮想サーバに，Web開発のためのソフトウェアをインストールできる．具体的には，プログラミング言語やファイアウォールをインストールする．

- **Ansible**

Ansibleでは，ymlの文法を用いて関数処理を実行できる．

| ファイル名   | 役割                                   |
| ------------ | -------------------------------------- |
| playbook.yml | ソフトウェアのインストールタスクの手順 |
| inventory/*  | 反映先のサーバの情報                   |
| group_vars/* | 複数のサーバへの設定                   |
| host_vars/*  | 単一のサーバへの設定                   |



### :pushpin: VagrantによるProviderとProvisionerの操作

ProviderとProvisionerの操作を自動化できる．チームメンバーが別々に仮想サーバを構築する場合，ProviderとProvisionerの処理によって作られる仮想サーバの環境に，違いが生じてしまう．Vagrantを使う場合，ProviderとProvisionerによる処理方法は，Vagrantfileに記述されている．このために，Vagrantを用いれば，チームメンバーが同じソフトウェアの下で，仮想サーバを構築し，ソフトウェアをインストールすることができる．

- **サーバの情報の管理方法**

サーバの情報は，ENVファイルで以下の様に管理する．

```php
#=======================================
# Webサーバ情報
#=======================================
WEB_HOST="XXX.X.X.X"

#=======================================
# データベースサーバ情報
#=======================================
DB_HOST="YYY.Y.Y.Y"
DB_NAME="example"
DB_USER="hiroki"
DB_PASSWORD="12345"
```

- **主な```vagrant```コマンド**

| コマンド                        | 処理                       |
| ------------------------------- | :------------------------- |
| **```vagrant up```**            | 仮想サーバ起動             |
| **```vagrant halt```**          | 仮想サーバ停止             |
| **```vagrant ssh```**           | 仮想サーバへのリモート接続 |
| **```vagrant global-status```** | 起動中仮想サーバの一覧     |



## 03-01. Symfonyによるビルトインサーバの構築



## 04-01. Dockerによるコンテナの構築

### :pushpin: Dockerの操作

- **Dockerクライアント**

Dockerクライアントは，ssh接続によって，Dockerデーモンを操作できる．

- **Dockerデーモン**

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![Dockerの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Dockerの仕組み.png)



## 04-02. コンテナにssh接続するまでの手順

### :pushpin: 手順の流れ

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Dockerfileの作成からコンテナ構築までの手順.png)

1. DockerHubから，ベースとなるDockerイメージをインストールする．
2. DockerfileがイメージレイヤーからなるDockerイメージをビルド．
3. コマンドによって，Dockerイメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，構築されたコンテナを起動．
5. コマンドによって，起動中のコンテナにssh接続．



### :pushpin: ベースとなるDockerイメージのインストール

DockerHubには，カスタマイズする上でのベースとなるDockerイメージが提供されている．

- **ベースとなるDockerイメージの種類**

| Dockerイメージ   | 特徴                                                         | 相性の良いシステム例 |
| ---------------- | ------------------------------------------------------------ | -------------------- |
| **scratch**      | 以下の通り，何も持っていない<br>・OS：無<br>・パッケージ：無<br>・パッケージマネージャ：無 | ？                   |
| **BusyBox**      | ・OS：Linux（※ディストリビューションではない）<br>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：無 | 組み込みシステム     |
| **Alpine Linux** | ・OS：Linux（※ディストリビューションではない）<br/>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：Apk |                      |

- **ベースとなるDockerイメージに関するコマンド**


| コマンド                                                     | 処理                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```search {イメージ名}```**                                | レジストリ側に保管されているDockerイメージを検索             |
| **```pull {イメージ名}```**                                  | レジストリ側のDockerイメージをクライアント側にインストール   |
| **```commit -a {作成者名} {コンテナ名} {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | コンテナからDockerイメージを作成                             |
| **```push {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | クライアント側で作成したDockerイメージをレジストリ側にアップロード |
| **```images```**                                             | クライアント側にインストールされたDockerイメージを確認       |




### :pushpin: ベースとなるDockerイメージのカスタマイズとビルド

- **DockerイメージのカスタマイズとDockerfile**

![イメージレイヤーからなるDockerイメージのビルド](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/イメージレイヤーからなるDockerイメージのビルド.png)

ベースとなるDockerイメージをカスタマイズするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．

- **Dockerfileの記述方法**

ベースとなるDockerイメージのカスタマイズでは，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

| 命令             | 処理                                                         |
| ---------------- | ------------------------------------------------------------ |
| **```FROM```**   | ベースのDockerイメージをDockerホスト側にインストール         |
| **```RUN```**    | イメージレイヤーのDockerイメージをDockerホスト側にインストール |
| **```COPY```**   | クライアント側のファイルを，Dockerホスト側のDockerイメージの指定ディレクトリにコピー |
| **```CMD```**    | Dockerホスト側のイメージレイヤーのデーモンを起動             |
| **```EXPOSE```** | 開放するポート番号を指定                                     |

必須ではないその他の命令には，以下がある．

| 命令          | 処理                                                         |
| ------------- | ------------------------------------------------------------ |
| **```ADD```** | ・クライアント側のファイルを，Dockerホスト側のDockerイメージの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う． |

**【具体例】**

ubuntuのDockerイメージをカスタマイズし，nginxのDockerイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，Shell形式，Exec形式がある．ここでは，Shell形式で記述する．

```dockerfile
# ベースのDockerイメージ（ubuntu）をインストール
FROM ubuntu:latest

# イメージのレイヤー（nginx）をインストール
RUN apt-get update && apt-get install -y -q nginx

# index.htmlファイルを，Dockerイメージの指定ディレクトリにコピー
COPY index.html /var/www/html

# イメージレイヤー（nginx）のデーモンを起動
CMD nginx -g 'daemon off;'

# ポート番号80（HTTP）を開放
EXPOSE 80
```

- **Dockerイメージのビルドを行うコマンド**

| コマンド                                   | 処理                                                         | 注意点                         |
| ------------------------------------------ | ------------------------------------------------------------ | ------------------------------ |
| **```build -f Dockerfile --no-cache .```** | キャッシュ無しで，指定のDockerfileを基に，Dockerイメージをビルド | コマンド最後のドットを忘れない |
| **```build --no-cache```**                 | キャッシュ無しで，全てのDockerfileを基に，Dockerイメージをビルド |                                |


- **Dockerfileを使用するメリット**

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．![Dockerfileのメリット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Dockerfileのメリット.png)

### :pushpin: コンテナレイヤーの生成，コンテナの構築

Dockerイメージの上にコンテナレイヤーを生成し，コンテナを構築する．

- **コンテナレイヤーの生成，コンテナの構築，に関するコマンド**

| コマンド                      | 処理                                                     |
| ----------------------------- | -------------------------------------------------------- |
| **```create {イメージ名}```** | コンテナレイヤーを生成し，コンテナを構築．起動はしない． |

![Dockerイメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Dockerイメージ上へのコンテナレイヤーの積み重ね.png)


- **ビルドされるDockerイメージとコンテナの役割の対応例**

| ビルドされるDockerイメージ | コンテナの役割               |
| :------------------------- | :--------------------------- |
| Redis                      | **NoSQL（非RDB）**           |
| MySQL                      | **RDBMS**                    |
| Nginx                      | **Webサーバソフトウェア**    |
| PHP-FPM                    | **APサーバソフトウェア**     |
| MailDev                    | **メールサーバソフトウェア** |



### :pushpin: 構築されたコンテナの起動／停止

- **構築されたコンテナの操作に関するコマンド**

| コマンド        | 処理                       |
| :-------------- | -------------------------- |
| **```start```** | 既存コンテナを起動         |
| **```stop```**  | 起動中コンテナを停止       |
| **```ps```**    | 起動中コンテナの一覧で表示 |



### :pushpin: 起動中のコンテナにssh接続

| コマンド                             | 処理                      | 注意点                   |
| ------------------------------------ | ------------------------- | ------------------------ |
| **```exec -it {コンテナ名} bash```** | 起動中のコンテナにssh接続 | i：interactive<br>t：tty |



## 04-03. コンテナの種類

### :pushpin: Data Volumeコンテナ

- **Data Volumeとは**

永続化したいデータを保存しておくディレクトリのこと．Volume内のデータを扱うためには，コンテナ構築時に，Data Volumeをコンテナ側のディレクトリにマウントする必要がある．

- **Data Volumeコンテナによる永続化データの提供**

コンテナのデータ永続化手法では，Data Volumeコンテナの構築が推奨されている．一旦，DataVolumeのディレクトリをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．そして，他のコンテナでDataVolumeを使用したい時は，Data Volumeコンテナとディレクトリを共有することによって，データを要求する．



## 04-04. コンテナ間の仮想ネットワーク

### :pushpin: bridgeネットワーク

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークとBridge接続する．ほとんどの場合，この方法を用いる．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Dockerエンジン内の仮想ネットワーク.jpg)



### :pushpin: noneネットワーク

特定のコンテナに対して，ホストOSや他のコンテナとは，ネットワーク接続しない．



### :pushpin: hostネットワーク

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．



## 04-05. docker-compose.ymlによる全手順の自動化

### :pushpin: docker-compose.ymlの記述方法

- **記述項目**

Dockerfileを基にしたDockerイメージのビルド，コンテナレイヤーの生成，コンテナの構築，コンテナの起動，を行うための管理ツール．

|    記述項目     | 意味                                                |
| :-------------: | :-------------------------------------------------- |
|    **build**    | Dockerfileの相対パス                                |
|    **ports**    | コンテナで開放するポート番号（※ホスト側はランダム） |
|   **volumes**   | Volumeのマウント先ディレクトリ                      |
| **environment** | DBの環境変数                                        |
| **depends_on**  | コンテナが起動する順番                              |
|  **networks**   | 複数のコンテナを起動する時に必要．要勉強            |

- **全ての手順を実行するコマンド**

| コマンド                          | 処理                                                         | 注意点                                                       |
| --------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```up -d```**                   | ・Dockerfileを基にイメージのビルド<br>・全てのコンテナレイヤーを生成し，コンテナを構築<br>・コンテナを起動 | すでにコンテナがある場合，それを再起動                       |
| **```run -d -it {イメージ名}```** | ・Dockerfileを基にイメージをビルド<br>・指定のコンテナレイヤーを生成し，コンテナを構築（※依存含む）<br>・コンテナを起動 | すでにコンテナがあっても，それを残して構築／起動．以前のコンテナが削除されずに残ってしまう． |



## 05-01. ライブラリとパッケージ

### :pushpin: ライブラリとパッケージの大まかな違い

![ライブラリ，パッケージ，モジュールの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ライブラリ，パッケージ，モジュールの違い.png)



### :pushpin: ライブラリマネージャ

- **PHP Composer**

```bash
// phpのメモリ上限を無しにしてcomposer updateを行う方法
php -d memory_limit=-1 /usr/local/bin/composer update
```



### :pushpin: パッケージマネージャ

- **Rpm: Red Hat Package Manager**

Linux系のパッケージを管理する．依存関係にある他のパッケージをインストールできない．

- **Yum: Yellow dog Updater Modified**

Linux系のパッケージを管理する．依存関係にある他のパッケージをインストールできる．

- **Npm: Node Package Manager**

JavaScript系のパッケージを管理する．

- **Apk：Alpine Linux package management**