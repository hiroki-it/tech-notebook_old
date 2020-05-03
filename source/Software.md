# ソフトウェア

## 01-01. ソフトウェアとは

### :pushpin: ソフトウェアの種類

#### ・ユーザの操作が，ソフトウェアを介して，ハードウェアに伝わるまで

![ソフトウェアとハードウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ソフトウェアとハードウェア.png)

#### 1. 応用ソフトウェア

#### 2. ミドルウェア

#### 3. 基本ソフトウェア（広義のOS）

![基本ソフトウェアの構成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/基本ソフトウェアの構成.png)

#### 4. Firmware

#### 5. デバイスドライバ



## 02-01. 応用ソフトウェア

### :pushpin: 応用ソフトウェア（アプリケーション）の一覧

|                        | ネイティブアプリ | Webアプリとクラウドアプリ | ハイブリッドアプリ |
| :--------------------: | :--------------: | :-----------------------: | :----------------: |
| **利用可能な通信状況** |     On／Off      |            On             |      On／Off       |



### :pushpin: ネイティブアプリケーション

![ネイティブアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ネイティブアプリ.png)

端末のシステムによって稼働するアプリのこと．一度ダウンロードしてしまえば，インターネットに繋がっていなくとも，使用できる．

**【アプリ例】**

Office，BookLiveのアプリ版



### :pushpin: Webアプリケーションとクラウドアプリケーション

![Webアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Webアプリ.png)

#### ・Webアプリケーション

Webサーバ上でWebシステムをレンダリングすることによって稼働するアプリのこと．URLをWebサーバにリクエストすることで利用でき，随時，Webサーバとデータ通信を行う．全ての人が無料で利用できるものと，お金を払った人だけが利用できるものがある．

**【全ての人が無料で利用できるWebアプリ例】**

Googleアプリ，Amazon，BookLiveのブラウザ版

**【お金を払った人だけが特定のURLから利用できるWebアプリ例】**

サイボウズ

#### ・クラウドアプリケーション

Webサーバ上のシステムによって稼働するアプリのうち，クラウドサービスを提供するもののこと．

**【クラウドアプリ例】**

Google Drive，Dropbox



### :pushpin: ハイブリッドアプリケーション

![Webviewよるアプリパッケージ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Webviewよるアプリパッケージ.png)

![ハイブリッドアプリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ハイブリッドアプリ.png)

端末でWebviewを稼働させ，WebシステムのレンダリングなどをWebview上で行うアプリのこと．

**【アプリ例】**

クックパッド



## 03-01. ミドルウェア

### :pushpin: Webサーバソフトウェア

#### ・Apache

#### ・Nginx

```nginx.conf```に以下のように記述する．

```nginx
# ここに記述例
```

#### ・Node.js



### :pushpin: APサーバソフトウェア

#### ・Apache内蔵

#### ・NGINX Unit



### :pushpin: DBMS

#### ・MySQL

#### ・MariaDB

※詳しくは，データベースのノートを参照せよ．



## 04-01. 基本ソフトウェア（広義のOS）

### :pushpin: 基本ソフトウェアの種類

#### ・Unix系OS

Unixを源流として派生したOS．現在では主に，Linux系統（緑色），BSD系統（黄色），SystemV系統（青色）の三つに分けられる．

※ちなみに，MacOSはBSD系統

![Unix系OSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Unix系OSの歴史.png)

#### ・WindowsOS

MS-DOSを源流として派生したOS．今では，全ての派生がWindows 10に集約された．

![WindowsOSの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/WindowsOSの歴史.png)



### :pushpin: Unix \ Linux系統

現在，Linux系統のOSは，さらに3つの系統に分けられる．

#### ・RedHat系統

RedHat，CentOS，Fedora

#### ・Debian系統

Debian，Ubuntu，

#### ・Slackware系統

Slackware

![Linux distribution](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/LinuxDistribution.png)



## 04-02. 基本ソフトウェア \ サービスプログラム（ユーティリティ）

### :pushpin: サービスプログラム（ユーティリティ）の種類

| システム系         | ストレージデバイス管理系 | ファイル管理系         | その他             |
| ------------------ | ------------------------ | ---------------------- | ------------------ |
| マネージャ         | デフラグメントツール     | ファイル圧縮プログラム | スクリーンセーバー |
| クリップボード     |                          |                        |                    |
| レジストリクリーナ |                          |                        |                    |



### :pushpin: マネージャについて

#### ・ライブラリとパッケージの大まかな違い

![ライブラリ，パッケージ，モジュールの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ライブラリ，パッケージ，モジュールの違い.png)

#### ・ライブラリマネージャ

| ライブラリマネージャ名            | 対象プログラミング言語 |
| --------------------------------- | ---------------------- |
| composer.phar：Composer           | PHP                    |
| npm：Node Package Manager         | Node.js                |
| pip：Package Installer for Python | Python                 |
| maven：Apache Maven               | Java                   |
| gem：Ruby Gems                    | Ruby                   |

```bash
// phpのメモリ上限を無しにしてcomposer updateを行う方法
php -d memory_limit=-1 /usr/local/bin/composer update
```

#### ・パッケージマネージャ

| パッケージマネージャ名                                  | 対象OS       | 依存関係のインストール可否 |
| ------------------------------------------------------- | ------------ | -------------------------- |
| Rpm：Red Hat Package Manager                            | RedHat系     | ✕                          |
| Yum：Yellow dog Updater Modified<br/>DNF：Dandified Yum | RedHat系     | 〇                         |
| Apt：Advanced Packaging Tool                            | Debian系     | 〇                         |
| Apk：Alpine Linux package management                    | Alpine Linux | 〇                         |

#### ・言語バージョンマネージャ

| 言語バージョンマネージャ名 | 対象プログラミング言語 |
| -------------------------- | ---------------------- |
| phpenv                     | PHP                    |
| pyenv                      | Python                 |
| rbenv                      | Ruby                   |



## 04-03. 基本ソフトウェア \ 言語プロセッサ

### :pushpin: 言語プロセッサの例

#### ・アセンブラ

以降の説明を参照．

#### ・コンパイラ

以降の説明を参照．

#### ・インタプリタ

以降の説明を参照．



### :pushpin: コンパイラ型言語，インタプリタ型言語，JavaまたはJava仮想マシン型言語

プログラム言語のソースコードは，言語プロセッサによって機械語に変換された後，CPUによって読み込まれる．そして，ソースコードに書かれた様々な処理が実行される．

#### ・コンパイラとコンパイラ型言語

  コンパイラという言語プロセッサによって，コンパイラ方式で翻訳される言語．

#### ・インタプリタとインタプリタ型言語

  インタプリタという言語プロセッサによって，インタプリタ方式で翻訳される言語をインタプリタ型言語という．

#### ・JavaやJava仮想マシン型言語

  Java仮想マシンによって，中間言語方式で翻訳される．

![コンパイル型とインタプリタ型言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コンパイル型とインタプリタ型言語.jpg)



### :pushpin: コンパイラによるコンパイラ型言語の翻訳（じ，こ，い，さい，せい，リンク，実行）

コードを，バイナリ形式のオブジェクトコードとして，まとめて機械語に翻訳した後，CPUに対して命令が実行される．

**【コンパイラ型言語の具体例】**

C#

![コンパイラ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コンパイラ言語.png)

#### ・コンパイラ方式によるコンパイラ型言語のビルド

  コンパイラ（C#）による翻訳では，ソースコードは機械語からなるオブジェクトコードに変換される．コンパイル後に，各オブジェクトコードはリンクされる．この一連のプロセスを『ビルド』という．

![ビルドとコンパイル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ビルドとコンパイル.jpg)

#### ・コンパイラ方式の翻訳の流れ

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **Code optimization（コード最適化）**

   ソースコードの冗長な部分を削除または編集．機械語をより短くするこができる．

5. **Code generation（コード生成）**

   最適化されたコードをバイナリ形式のオブジェクトコードに変換．

6. **リンク**

   オブジェクトコードをリンクする．

7. **命令の実行**

   リンクされたオブジェクトコードを基に，命令が実行される．



### :pushpin: インタプリタによるインタプリタ型言語の翻訳（じ，こ，い，実行）

コードを，一行ずつ機械語に変換し，順次，命令を実行する言語．

※Webサーバを仮想的に構築する時，PHPの言語プロセッサが同時に組み込まれるため，PHPのソースコードの変更はブラウザに反映される．しかし，JavaScriptの言語プロセッサは組み込まれない．そのため，JavaScriptのインタプリタは別に手動で起動する必要がある．

**【インタプリタ型言語の具体例】**

PHP，Ruby，JavaScript，Python

![インタプリタ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/インタプリタ言語.png)

#### ・インタプリタ方式の翻訳の流れ

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．ソースコードから構造体を構築することを構文解析といい，htmlを構文解析してDOMツリーを構築する処理とは別物なので注意．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **命令の実行**

   意味解析の結果を基に，命令が実行される．

5. **１から４をコード行ごとに繰り返す**



### :pushpin: Java仮想マシンによるJavaまたはJava仮想マシン型言語の翻訳

**【JVM型言語の具体例】**

Scala，Groovy，Kotlin

#### ・中間言語方式の翻訳の流れ

1. JavaまたはJVM型言語のソースコードを，Javaバイトコードを含むクラスファイルに変換する．
2. JVM：Java Virtual Machine内で，インタプリタによって，クラスデータを機械語に翻訳する．
3. 結果的に，OS（制御プログラム？）に依存せずに，命令を実行できる．（C言語）

![Javaによる言語処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_1.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/矢印_80x82.jpg)

![Javaによる言語処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_2.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/矢印_80x82.jpg)

![Javaによる言語処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Javaによる言語処理_3.png)

#### ・C言語とJavaのOSへの依存度比較

![CとJavaのOSへの依存度比較](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CとJavaのOSへの依存度比較.png)

- JVM言語

ソースコード

### :pushpin: プログラムの実行開始のエントリポイント

#### ・PHPの場合

動的型付け言語では，エントリポイントが指定プログラムの先頭行と決まっており，そこから枝分かれ状に処理が実行されていく．PHPでは，```index.php```がエントリポイントと決められている．その他のファイルにはエントリポイントは存在しない．

```PHP
use App\Kernel;
use Symfony\Component\ErrorHandler\Debug;
use Symfony\Component\HttpFoundation\Request;

// まず最初に，bootstrap.phpを読み込む．
require dirname(__DIR__).'/config/bootstrap.php';

if ($_SERVER['APP_DEBUG']) {
    umask(0000);

    Debug::enable();
}

if ($trustedProxies = $_SERVER['TRUSTED_PROXIES'] ?? $_ENV['TRUSTED_PROXIES'] ?? false) {
    Request::setTrustedProxies(explode(',', $trustedProxies), Request::HEADER_X_FORWARDED_ALL ^ Request::HEADER_X_FORWARDED_HOST);
}

if ($trustedHosts = $_SERVER['TRUSTED_HOSTS'] ?? $_ENV['TRUSTED_HOSTS'] ?? false) {
    Request::setTrustedHosts([$trustedHosts]);
}

$kernel = new Kernel($_SERVER['APP_ENV'], (bool) $_SERVER['APP_DEBUG']);
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
```

#### ・Javaの場合

静的型付け言語では，エントリポイントが決まっておらず，自身で定義する必要がある．Javaでは，```public static void main(String args[])```と定義した場所がエントリポイントになる．

```java
public class Age
{
		public static void main(String[] args)
		{
			// 定数を定義．
			final int age = 20;
			System.out.println("私の年齢は" + age);

			// 定数は再定義できないので，エラーになる．
			age = 31;
			System.out.println("…いや，本当の年齢は" + age);
		}
}
```



## 04-04. 基本ソフトウェア \ 制御プログラム（カーネル）

### :pushpin: 制御プログラム（カーネル）の例

  カーネル，マイクロカーネル，モノリシックカーネル



### :pushpin: ジョブ管理

クライアントは，マスタスケジュールに対して，ジョブを実行するための命令を与える．

![ジョブ管理とタスク管理の概要](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブ管理とタスク管理の概要.jpg)



### :pushpin: マスタスケジュラ，ジョブスケジュラ

ジョブとは，プロセスのセットのこと．マスタスケジュラは，ジョブスケジュラにジョブの実行を命令する．データをコンピュータに入力し，複数の処理が実行され，結果が出力されるまでの一連の処理のこと．『Task』と『Job』の定義は曖昧なので，『process』と『set of processes』を使うべきとのこと．

引用：https://stackoverflow.com/questions/3073948/job-task-and-process-whats-the-difference/31212568

複数のジョブ（プログラムやバッチ）の起動と終了を制御したり，ジョブの実行と終了を監視報告するソフトウェア．ややこしいことに，タスクスケジューラとも呼ぶ．

#### ・Reader

ジョブ待ち行列に登録

#### ・Initiator

ジョブステップに分解

#### ・Terminator

出力待ち行列に登録

#### ・Writer

優先度順に出力の処理フローを実行



### :pushpin: Initiatorによるジョブのジョブステップへの分解

Initiatorによって，ジョブはジョブステップに分解される．

![ジョブからジョブステップへの分解](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブからジョブステップへの分解.png)



### :pushpin: タスク管理

![ジョブステップからタスクの生成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ジョブステップからタスクの生成.png)

タスクとは，スレッドに似たような，単一のプロセスのこと．Initiatorによるジョブステップから，タスク管理によって，タスクが生成される．タスクが生成されると実行可能状態になる．ディスパッチャによって実行可能状態から実行状態になる．

#### ・優先順方式

各タスクに優先度を設定し，優先度の高いタスクから順に，ディスパッチしていく方式．

#### ・到着順方式

待ち行列に登録されたタスクから順に，ディスパッチしていく方式．

![到着順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/到着順方式_1.png)

**【具体例】**

以下の様に，タスクがCPUに割り当てられていく．

![到着順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/到着順方式_2.png)

#### ・Round robin 方式

Round robinは，『総当たり』の意味．一定時間（タイムクウォンタム）ごとに，実行状態にあるタスクが強制的に待ち行列に登録される．交代するように，他のタスクがディスパッチされる．

![ラウンドロビン方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ラウンドロビン方式.png)

**【具体例】**

生成されたタスクの到着時刻と処理時間は以下のとおりである．強制的なディスパッチは，『20秒』ごとに起こるとする．

![優先順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/優先順方式_1.png)

1. タスクAが0秒に待ち行列へ登録される．
2. 20秒間，タスクAは実行状態へ割り当てられる．
3. 20秒時点で，タスクAは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクBは，実行可能状態から実行状態にディスパッチされる．
4. 40秒時点で，タスクCは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクAは，実行可能状態から実行状態にディスパッチされる．

![優先順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/優先順方式_2.png)



### :pushpin: 入出力管理

アプリケーションから低速な周辺機器へデータを出力する時，まず，CPUはスプーラにデータを出力する．Spoolerは，全てのデータをまとめて出力するのではなく，一時的に補助記憶装置（Spool）にためておきながら，少しずつ出力する（Spooling）．

![スプーリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/スプーリング.jpg)



## 05-01. デバイスドライバ



## 06-01. Firmware

システムソフトウェア（ミドルウェア ＋ 基本ソフトウェア）とハードウェアの間の段階にあるソフトウェア．ROMに組み込まれている．

### :pushpin: BIOS：Basic Input/Output System

![BIOS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/BIOS.jpg)



### :pushpin: UEFI：United Extensible Firmware Interface

Windows 8以降で採用されている新しいFirmware

![UEFIとセキュアブート](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/UEFIとセキュアブート.jpg)



## 07-01. OSS：Open Source Software

### :pushpin: OSSとは

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

    

### :pushpin: OSSの具体例

![OSS一覧](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/OSS一覧.png)

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
