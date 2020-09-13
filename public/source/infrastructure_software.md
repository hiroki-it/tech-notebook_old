# ソフトウェアの種類

## 01. ソフトウェアとは

### ユーザの操作による命令の流れ

ユーザの操作による命令が，ソフトウェアを介して，ハードウェアに伝わるまで，を以下に示す．

![ソフトウェアとハードウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ソフトウェアとハードウェア.png)

### ソフトウェアの種類

#### 1. 応用ソフトウェア

#### 2. ミドルウェア

#### 3. 基本ソフトウェア（広義のOS）

#### 4. Firmware

#### 5. デバイスドライバ



## 02. 応用ソフトウェア

### 応用ソフトウェア（アプリケーション）の一覧

|                        | ネイティブアプリ | Webアプリとクラウドアプリ | ハイブリッドアプリ |
| :--------------------: | :--------------: | :-----------------------: | :----------------: |
| **利用可能な通信状況** |     On／Off      |            On             |      On／Off       |



### ネイティブアプリケーション

![ネイティブアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ネイティブアプリ.png)

端末のシステムによって稼働するアプリのこと．一度ダウンロードしてしまえば，インターネットに繋がっていなくとも，使用できる．

**＊具体例＊**

Office，BookLiveのアプリ版



### Webアプリケーションとクラウドアプリケーション

![Webアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Webアプリ.png)

#### ・Webアプリケーション

Webサーバ上でWebシステムをレンダリングすることによって稼働するアプリのこと．URLをWebサーバにリクエストすることで利用でき，随時，Webサーバとデータ通信を行う．全ての人が無料で利用できるものと，お金を払った人だけが利用できるものがある．

**＊具体例＊**

Googleアプリ，Amazon，BookLiveのブラウザ版，サイボウズ

#### ・クラウドアプリケーション

Webサーバ上のシステムによって稼働するアプリのうち，クラウドサービスを提供するもののこと．

**＊具体例＊**

Google Drive，Dropbox



### ハイブリッドアプリケーション

![Webviewよるアプリパッケージ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Webviewよるアプリパッケージ.png)

![ハイブリッドアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ハイブリッドアプリ.png)

端末でWebviewを稼働させ，WebシステムのレンダリングなどをWebview上で行うアプリのこと．

**＊具体例＊**

クックパッド



## 03. ミドルウェア

### Webサーバのミドルウェア

#### ・Apache

Apacheのノートを参照．

#### ・Nginx

Nginxのノートを参照．

#### ・Node.js

![Webサーバ，APサーバ，DBサーバ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Webサーバ，APサーバ，DBサーバ.png)



### Appサーバのミドルウェア

#### ・Apacheの拡張モジュール

mod_phpという拡張モジュールを読み込むことによって，Apacheを，WebサーバだけでなくAppサーバのミドルウェアとしても機能させることができる．

#### ・PHP-FPM：PHP FastCGI Process Manager

WebサーバのNginxと組み合わせて使用できるミドルウェア．

![NginxとPHP-FPMの組み合わせ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NginxとPHP-FPMの組み合わせ.png)

#### ・NGINX Unit

WebサーバのNginxと組み合わせて使用できるミドルウェア．

#### ・CGIプログラム：Common Gateway Interface

![CGIの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CGIの仕組み.png)



### DBサーバのミドルウェア

#### ・MySQL

#### ・MariaDB

※詳しくは，データベースのノートを参照せよ．



## 04. 基本ソフトウェア（広義のOS）

### 基本ソフトウェアの種類

#### ・Unix系OS

Unixを源流として派生したOS．現在では主に，Linux系統（緑色），BSD系統（黄色），SystemV系統（青色）の三つに分けられる．

※ちなみに，MacOSはBSD系統

![Unix系OSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Unix系OSの歴史.png)

#### ・WindowsOS

MS-DOSを源流として派生したOS．今では，全ての派生がWindows 10に集約された．

![WindowsOSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/WindowsOSの歴史.png)



### Unix ｜ Linux系統

#### ・OSとバージョンの確認コマンド

```/etc/issue```ファイルに，OSとバージョンが記載されている．

```bash
$ cat /etc/issue
Debian GNU/Linux 10 \n \l
```

現在，Linux系統のOSは，さらに3つの系統に分けられる．

#### ・RedHat系統

RedHat，CentOS，Fedora

#### ・Debian系統

Debian，Ubuntu，

#### ・Slackware系統

Slackware

![Linux distribution](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/LinuxDistribution.png)



### 基本ソフトウェア

#### ・基本ソフトウェアの構成

![基本ソフトウェアの構成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/基本ソフトウェアの構成.png)

#### ・ユーティリティ

基本ソフトウェアのノートを参照．

#### ・言語プロセッサ

基本ソフトウェアのノートを参照．

#### ・制御プログラム（カーネル）

基本ソフトウェアのノートを参照．



## 05. デバイスドライバ

### デバイスドライバとは

要勉強



## 06. Firmware

### Firmwareとは

システムソフトウェア（ミドルウェア ＋ 基本ソフトウェア）とハードウェアの間の段階にあるソフトウェア．ROMに組み込まれている．

### BIOS：Basic Input/Output System

![BIOS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/BIOS.jpg)



### UEFI：United Extensible Firmware Interface

Windows 8以降で採用されている新しいFirmware

![UEFIとセキュアブート](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/UEFIとセキュアブート.jpg)



## 07. OSS：Open Source Software

### OSSとは

以下の条件を満たすソフトウェアをOSSと呼ぶ．応用ソフトウェアから基本ソフトウェアまで，様々なものがある．

1. 利用者は，無償あるいは有償で自由に再配布できる．

2. 利用者は，ソースコードを入手できる．

3. 利用者は，コードを自由に変更できる．また，変更後に提供する場合，異なるライセンスを追加できる．

4. 差分情報の配布を認める場合には，同一性の保持を要求してもかまわない． ⇒ よくわからない

5. 提供者は，特定の個人やグループを差別できない．

6. 提供者は，特定の分野を差別できない．

7. 提供者は，全く同じOSSの再配布において，ライセンスを追加できない．

8. 提供者は，特定の製品でのみ有効なライセンスを追加できない．

9. 提供者は，他のソフトウェアを制限するライセンスを追加できない．

10. 提供者は，技術的に偏りのあるライセンスを追加できない．

    

### OSSの種類

![OSS一覧](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/OSS一覧.png)

引用：https://openstandia.jp/oss_info/

#### ・OS

  CentOS，Linux，Unix，Ubuntu

#### ・データベース

  MySQL，MariaDB

#### ・プログラミング言語

  言うまでもない．

#### ・フレームワーク

  言うまでもない．

#### ・OR Mapper

  言うまでもない．

#### ・バージョン管理

  Git，Subversion

#### ・Webサーバ

  Apache

#### ・業務システム

  Redmine

#### ・インフラ構築

  Chef，Puppet

#### ・クラウド構築

  Docker
