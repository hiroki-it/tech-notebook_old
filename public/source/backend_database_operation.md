# データベースの操作

## 01. RDB（関係データベース）とは

### RDBMS（関係データベース管理システム）の仕組み

RDBは，データ同士がテーブル状に関係をもつデータ格納形式である．データはストレージに保存する．

![データベース管理システムの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/データベース管理システムの仕組み.png)

<br>

### RDBMSとRDBの種類

![DBMS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DBMS.jpg)

#### ・MariaDB

  MariaDBデータベースを管理できるRDBMS

#### ・MySQL

  MySQLデータベースを管理できるRDBMS

#### ・PostgreSQL

  PostgreSQLデータベースを管理できるRDBMS

<br>


### RDBSにおけるデータベースエンジン

RDBMSがデータベースに対してデータのCRUDの処理を行うために必要なソフトウェアのこと．

#### ・InnoDB

<br>

## 01-02. NoSQL（非関係データベース）とは

NoSQLは，データ同士が関係を持たないデータ格納形式である．データをメインメモリに保存する．

### NoSQLの種類

![NoSQLの分類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NoSQLの種類.jpg)

<br>


## 01-03. RDBの設計

### UMLによる設計

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．

<br>

### ER図による設計：Entity Relation Diagram

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．

<br>

## 01-04. テーブルの作成

### データを追加するあるいは削除する場合の注意点

データを追加するあるいは削除する場合，カラムではなく，レコードの増減を行う．カラムの増減の処理には時間がかかる．一方で，レコードの増減の処理には時間がかからない．

![カラムの増減は✖，レコードの増減は〇](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/カラムの増減は✖，レコードの増減は〇-1.png)

**＊具体例＊**

賞与を年1回から，2回・3回と変える場合，主キーを繰り返し，新しく賞与区分と金額区分を作る．

![カラムの増減は✖，レコードの増減は〇-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/カラムの増減は✖，レコードの増減は〇-2.png)

<br>

### 非正規形の正規化

繰り返し要素のある表を『正規形』，その逆を『非正規形』という．非正規形の表から，他と連動するカラムを独立させ，正規形の表に変更することを『正規化』という．

**＊具体例＊**

まず，主キーが受注Noと商品IDの2つであることを確認．これらの主キーは，複合主キーではないとする．

1. **エクセルで表を作成**

   エクセルで作られた以下の表があると仮定．

![非正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/非正規形.png)

2. **第一正規化（繰り返し要素の排除）**

   レコードを1つずつに分割．

   ![第一正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第一正規形.png)

3. **第二正規化（主キーの関数従属性を排除）**

   主キーと特定のカラムが連動する（関数従属性がある）場合，カラムを左表として独立させる．今回，主キーが2つあるので，まず受注Noから関数従属性を排除していく．受注Noと他3カラムが連動しており，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．また，主キーが重複するローを削除する．

   ![第二正規形-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第二正規形-1.png)

   次に，商品IDの関数従属性を排除していく．商品IDと他2カラムに関数従属性があり，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．また，主キーが重複するローを削除する．これで，主キーの関数従属性の排除は終了．

   ![第二正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第二正規形-2.png)

   ![第二正規形-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第二正規形-3.png)

4. **第三正規化（主キー以外のカラムの関数従属性を排除）**

   次に主キー以外のカラムの関係従属性を排除していく．上記で独立させた3つの表のうち，一番左の表で，顧客IDと顧客名に関数従属性があるので，顧客IDを新しい主キーに設定し，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．

![第三正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第三正規形-1.png)

![第三正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第三正規形-2.png)

5. **まとめ**

   主キーの関係従属性の排除によって，受注表，商品表，数量表に分割できた．また，主キー以外の関係従属性の排除によって，顧客IDを新しい主キーとした顧客表に分割できた．

![正規化後にどんな表ができるのか](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/正規化後にどんな表ができるのか.png)

**＊具体例＊**

1. **エクセルで表を作成**

   以下のような表の場合，行を分割し，異なる表と見なす．

![非正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/非正規形-2.png)

2. **第一正規化（繰り返し要素の排除）**

   ![第一正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/第一正規形-2.png)

<br>

## 02. RDBに必要な機能

### ACID特性

トランザクションを実現するためには，以下の４つの機能が必要である．

#### ・Atomicity

  コミットメント制御によって実装される．

#### ・Consistency

  トランザクションの前後で排他制御によって実装される．

#### ・Isolation

  排他制御によって実装される．

#### ・Durability

  障害回復制御によって実装される．

<br>

## 02-02. コミットメント制御と障害回復制御

### RDBの書き込み系の操作

#### ・RDBに対するC／U／Dの処理の大まかな流れ

![コミットメント制御](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/コミットメント制御.jpg)

#### ・RDBの操作と実際のメソッドの対応関係

| RDBの書き込み系の操作                     | PDOでのメソッド名                                        | ラッピング          | システム障害からの回復           |
| :---------------------------------------- | :------------------------------------------------------- | ------------------- | -------------------------------- |
| 更新前ログの記録                          | ↓                                                        | ↓                   |                                  |
| ↓                                         | ↓                                                        | ↓                   |                                  |
| トランザクション開始                      | ```beginTransaction()```                                 | ```execute()```開始 |                                  |
| ↓                                         | ↓                                                        | ↓                   | ⬆︎                                |
| ・C／U／Dの処理<br>・トランザクション終了 | ・```insert()```<br>・```update()```<br>・```delete()``` | ```flush()```       | ⬆︎　*Roll back*：```rollBack()``` |
| ↓                                         | ↓                                                        | ↓                   | ⬆︎                                |
| Commitによる更新後ログの書き込み．        | ```commit()```開始                                       | ↓                   |                                  |
| ↓                                         | ↓                                                        | ↓                   | ⬇︎                                |
| ↓                                         | ↓                                                        | ↓                   | ⬇︎　*Roll forward*                |
| ↓                                         | ↓                                                        | ↓                   | ⬇︎                                |
| Check Pointによる更新後ログのDB反映       | ```commit()```終了                                       | ```execute()```終了 |                                  |

#### ・PDOによるRDBの書き込み系の操作

```PHP
<?php
try{
    // データベースと接続．
    $db = getDb();

    // 例外処理を有効化．
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  
    // トランザクションを開始．
    $db->beginTransaction();
    // いくつかのSQLが実行される．※もし失敗した場合，ERRMODE_EXCEPTIONを実行．
    $db->exec("INSERT INTO movie(title, price) VALUES('ハリポタ', 2000)")
    $db->exec("INSERT INTO movie(title, price) VALUES('シスター', 2000)")
   
    // トランザクション内の一連のステートメントが成功したら，ログファイルにコミット．
    $db->commit();

} catch{
    // 例外が発生したらロールバックし，エラーメッセージを出力．
    $db->rollBack();
    print "失敗しました．：{$e->getMessage()}"
}  
```

#### ・DoctrineによるRDBの書き込み系の操作

詳しくは，ライブラリのノートを参照せよ．

<br>

### ログファイルへの更新前ログの書き込み

<br>

### コミットによるログファイルへの更新前ログへの書き込み

#### ・コミット

トランザクション内の一連のステートメントを，ログファイルの更新前ログとして書き込む．

#### ・二相コミット

コミットを以下の二つの段階に分けて行うこと．ACIDのうち，原子性と一貫性を実装している．

1. 他のサイトに更新可能かどうかを確認．
2. 全サイトからの合意が得られた場合に更新を確定．

<br>

### チェックポイントにおけるデータファイルへの書き込み

トランザクションの終了後，DBMSは，処理速度を高めるために，ログファイルの更新後ログをいったんメモリ上で管理する．

![DBMSによるメモリとディスクの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DBMSによるメモリとディスクの使い分け.jpg)

そして，チェックポイントで，ログファイルの更新後ログをディスク上のデータファイルに反映させる．この時，チェックポイントは，自動実行または手動実行で作成する．

![トランザクション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/トランザクション.jpg)

<br>

### システム障害からの回復

データベースサーバのソフトウェア障害のこと．例えば，DBMSやOSのトラブル等によりシステム全体が停止する．

![障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/システム障害の障害回復機能.jpg)

#### ・ロールバック

障害によって，トランザクション内の一連のステートメントがすべて実行されなかった場合に，ログファイルの更新前ログを用いて，トランザクションの開始前の状態に戻す．

#### ・ロールフォワード

障害によって，トランザクションの終了後に一連のステートメントの更新結果がディスクに反映されなかった場合に，ログファイルの更新後ログを用いて，ディスク上のデータファイルに更新結果を反映させる．

**＊具体例＊**

『a』の値を更新するステートメントを含むトランザクションの後に，システムが異常終了した場合，ログファイルの更新後ログ『a = 5』を用いて，ディスク上のデータファイルに更新結果を反映させる．（ロールフォワード）

『b』の値を更新するステートメントを含むトランザクションの途中に，システムが異常終了した場合，ログファイルの更新前ログ『b = 1』を用いて，障害発生前の状態に戻す．（ロールバック）

<br>

### 媒体障害からの回復

データベースサーバのハードウェア障害のこと．例えば，ハードディスクの障害がある．ディスクを初期化／交換した後，バックアップファイルからデータベースを修復し，ログファイルの更新後ログ『a = 5』『b = 1』を用いて，修復できる限りロールフォワードを行う．

![媒体障害の障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/媒体障害の障害回復機能.jpg)

**＊具体例＊**

バックアップファイルの実際のコード

```SQL
-- --------------------------------------------------------
-- Host:                         xxxxx
-- Server version:               10.1.38-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.2.0.5611
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

# データベース作成
-- Dumping database structure for kizukeba_pronami_php
CREATE DATABASE IF NOT EXISTS `kizukeba_pronami_php` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `kizukeba_pronami_php`;

# テーブルのデータ型を指定
-- Dumping structure for table kizukeba_pronami_php.mst_staff
CREATE TABLE IF NOT EXISTS `mst_staff` (
  `code` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# レコードを作成
-- Dumping data for table kizukeba_pronami_php.mst_staff: ~8 rows (approximately)
/*!40000 ALTER TABLE `mst_staff` DISABLE KEYS */;
INSERT INTO `mst_staff` (`code`, `name`, `password`) VALUES
    (1, '秦基博', 'xxxxxxx'),
    (2, '藤原基央', 'xxxxxxx');
/*!40000 ALTER TABLE `mst_staff` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

```

<br>

## 02-03. 排他制御

### なぜ排他制御が必要か

![排他制御-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/排他制御-1.png)

#### ・排他制御を行った結果

  ![排他制御-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/排他制御-2.png)

  <br>

### 排他制御のためのロック操作

![排他制御-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/排他制御-3.gif)

#### ・共有ロック

CRUDのRead以外の処理を実行不可能にする．レコードをReadする時に，他者によってUpdateされたくない場合に用いる．「共有」の名の通り，共有ロックされているレコードに対して，他の人も共有ロックを行うことができる．

#### ・占有ロック

CRUDの全ての処理を実行不可能にする．レコードをUpdateする時に，他者によってUpdateもReadもされたくない場合に用いる．

#### ・デッドロック現象

複数のトランザクションが，互いに他者が使いたいレコードをロックしてしまい，お互いのロック解除を待ち続ける状態のこと．もう一方のレコードのロックが解除されないと，自身のレコードのロックを解除できない時，トランザクションが停止する．

|                            | 共有ロックの実行 | 占有ロックの実行 |
| :------------------------: | :--------------: | :--------------: |
| **共有ロックされたレコード** |        〇        |        ✕         |
| **占有ロックされたレコード** |        ✕         |        ✕         |

![Null](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/デッドロック.gif)

#### ・ロックの粒度

![ロックの粒度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ロックの粒度-1.png)

DB ＞ テーブル ＞ レコード ＞ カラム の順に，粒度は大きい．ロックの粒度が細かければ，トランザクションの同時実行性が高くなって効率は向上する（複数の人がDBに対して作業できる）．しかし，ロックの粒度を細かくすればするほど，それだけベース管理システムのCPU負荷は大きくなる．

![ロックの粒度-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ロックの粒度-2.jpg)
