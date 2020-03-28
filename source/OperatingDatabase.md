# データベースの操作

## 01-01. RDB（関係データベース）とは

### :pushpin: RDBMS（関係データベース管理システム）の仕組み

RDBは，データ同士がテーブル状に関係をもつデータ格納形式である．データはストレージに保存する．

![データベース管理システムの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/データベース管理システムの仕組み.png)



### :pushpin: RDBMSとRDBの種類

![DBMS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DBMS.jpg)

#### ・MariaDB

  MariaDBデータベースを管理できるRDBMS

#### ・MySQL

  MySQLデータベースを管理できるRDBMS

#### ・PostgreSQL

  PostgreSQLデータベースを管理できるRDBMS




### :pushpin: RDBSにおけるデータベースエンジン

RDBMSがデータベースに対してデータのCRUDの処理を行うために必要なソフトウェアのこと．

#### ・InnoDB



## 01-02. NoSQL（非関係データベース）とは

NoSQLは，データ同士が関係を持たないデータ格納形式である．データをメインメモリに保存する．

### :pushpin: NoSQLの種類

![NoSQLの分類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/NoSQLの種類.jpg)




## 01-03. RDBの設計

### :pushpin: UMLによる設計

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．



### :pushpin: ER図による設計：Entity Relation Diagram

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．



## 01-04. テーブルの作成

### :pushpin: データを追加するあるいは削除する場合の注意点

データを追加するあるいは削除する場合，カラムではなく，レコードの増減を行う．カラムの増減の処理には時間がかかる．一方で，レコードの増減の処理には時間がかからない．

![カラムの増減は✖，レコードの増減は〇](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/カラムの増減は✖，レコードの増減は〇-1.png)

**【具体例】**

賞与を年1回から，2回・3回と変える場合，主キーを繰り返し，新しく賞与区分と金額区分を作る．

![カラムの増減は✖，レコードの増減は〇-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/カラムの増減は✖，レコードの増減は〇-2.png)



### :pushpin: 非正規形の正規化

繰り返し要素のある表を『正規形』，その逆を『非正規形』という．非正規形の表から，他と連動するカラムを独立させ，正規形の表に変更することを『正規化』という．

**【具体例1】**

まず，主キーが受注Noと商品IDの2つであることを確認．これらの主キーは，複合主キーではないとする．

1. **エクセルで表を作成**

   エクセルで作られた以下の表があると仮定．

![非正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/非正規形.png)

2. **第一正規化（繰り返し要素の排除）**

   レコードを1つずつに分割．

   ![第一正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第一正規形.png)

3. **第二正規化（主キーの関数従属性を排除）**

   主キーと特定のカラムが連動する（関数従属性がある）場合，カラムを左表として独立させる．今回，主キーが2つあるので，まず受注Noから関数従属性を排除していく．受注Noと他3カラムが連動しており，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．また，主キーが重複するローを削除する．

   ![第二正規形-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第二正規形-1.png)

   次に，商品IDの関数従属性を排除していく．商品IDと他2カラムに関数従属性があり，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．また，主キーが重複するローを削除する．これで，主キーの関数従属性の排除は終了．

   ![第二正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第二正規形-2.png)

   ![第二正規形-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第二正規形-3.png)

4. **第三正規化（主キー以外のカラムの関数従属性を排除）**

   次に主キー以外のカラムの関係従属性を排除していく．上記で独立させた3つの表のうち，一番左の表で，顧客IDと顧客名に関数従属性があるので，顧客IDを新しい主キーに設定し，左表として独立させる．主キーと連動していたカラムを除いたものを右表とする．

![第三正規形](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第三正規形-1.png)

![第三正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第三正規形-2.png)

5. **まとめ**

   主キーの関係従属性の排除によって，受注表，商品表，数量表に分割できた．また，主キー以外の関係従属性の排除によって，顧客IDを新しい主キーとした顧客表に分割できた．

![正規化後にどんな表ができるのか](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/正規化後にどんな表ができるのか.png)

**【具体例2】**

1. **エクセルで表を作成**

   以下のような表の場合，行を分割し，異なる表と見なす．

![非正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/非正規形-2.png)

2. **第一正規化（繰り返し要素の排除）**

   ![第一正規形-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/第一正規形-2.png)



## 02-01. RDBに必要な機能

### :pushpin: ACID特性

トランザクションを実現するためには，以下の４つの機能が必要である．

#### ・Atomicity

  コミットメント制御によって実装される．

#### ・Consistency

  トランザクションの前後でデータ排他制御によって実装される．

#### ・Isolation

  排他制御によって実装される．

#### ・Durability

  障害回復制御によって実装される．



## 02-02. コミットメント制御と障害回復制御

### :pushpin: RDBの操作

#### ・RDBに対するC／U／D操作の大まかな流れ

![コミットメント制御](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コミットメント制御.jpg)

#### ・操作名と実際のメソッドの対応関係

|            処理内容             |         操作名         |    PDOでのメソッド名     |     ラッピング      | システム障害からの回復           |
| :-----------------------------: | :--------------------: | :----------------------: | :-----------------: | -------------------------------- |
|      更新前ログの書き込み       |       ログの記録       |            ↓             |          ↓          |                                  |
|                ↓                |           ↓            |            ↓             |          ↓          |                                  |
|      トランザクション開始       |    Transaction 開始    | ```beginTransaction()``` | ```execute()```開始 |                                  |
|                ↓                |           ↓            |            ↓             |          ↓          | ⬆︎                                |
| SQLの実行，トランザクション終了 | INSERT，UPDATE，DELETE |            ↓             |    ```flush()```    | ⬆︎　*Roll back*：```rollBack()``` |
|                ↓                |           ↓            |            ↓             |          ↓          | ⬆︎                                |
|      更新後ログの書き込み       |      Commit 開始       |    ```commit()```開始    |          ↓          |                                  |
|                ↓                |           ↓            |            ↓             |          ↓          | ⬇︎                                |
|                ↓                |           ↓            |            ↓             |          ↓          | ⬇︎　*Roll forward*                |
|                ↓                |           ↓            |            ↓             |          ↓          | ⬇︎                                |
|     更新後ログのDBへの反映      |      Check Point       |    ```commit()```終了    | ```execute()```終了 |                                  |

**【実装例】**

```PHP
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



### :pushpin: ログファイルへの更新前ログの書き込み



### :pushpin: コミットによるログファイルへの更新前ログへの書き込み

#### ・コミット

トランザクション内の一連のステートメントを，ログファイルの更新前ログとして書き込む．

#### ・二相コミット

コミットを以下の二つの段階に分けて行うこと．ACIDのうち，原子性と一貫性を実装している．

1. 他のサイトに更新可能かどうかを確認．
2. 全サイトからの合意が得られた場合に更新を確定．



### :pushpin: チェックポイントにおけるデータファイルへの書き込み

トランザクションの終了後，DBMSは，処理速度を高めるために，ログファイルの更新後ログをいったんメモリ上で管理する．

![DBMSによるメモリとディスクの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DBMSによるメモリとディスクの使い分け.jpg)

そして，チェックポイントで，ログファイルの更新後ログをディスク上のデータファイルに反映させる．この時，チェックポイントは，自動実行または手動実行で作成する．

![トランザクション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/トランザクション.jpg)



### :pushpin: システム障害からの回復

データベースサーバのソフトウェア障害のこと．例えば，DBMSやOSのトラブル等によりシステム全体が停止する．

![障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/システム障害の障害回復機能.jpg)

#### ・ロールバック

障害によって，トランザクション内の一連のステートメントがすべて実行されなかった場合に，ログファイルの更新前ログを用いて，トランザクションの開始前の状態に戻す．

#### ・ロールフォワード

障害によって，トランザクションの終了後に一連のステートメントの更新結果がディスクに反映されなかった場合に，ログファイルの更新後ログを用いて，ディスク上のデータファイルに更新結果を反映させる．

**【具体例】**

『a』の値を更新するステートメントを含むトランザクションの後に，システムが異常終了した場合，ログファイルの更新後ログ『a = 5』を用いて，ディスク上のデータファイルに更新結果を反映させる．（ロールフォワード）

『b』の値を更新するステートメントを含むトランザクションの途中に，システムが異常終了した場合，ログファイルの更新前ログ『b = 1』を用いて，障害発生前の状態に戻す．（ロールバック）



### :pushpin: 媒体障害からの回復

データベースサーバのハードウェア障害のこと．例えば，ハードディスクの障害がある．ディスクを初期化／交換した後，バックアップファイルからデータベースを修復し，ログファイルの更新後ログ『a = 5』『b = 1』を用いて，修復できる限りロールフォワードを行う．

![媒体障害の障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/媒体障害の障害回復機能.jpg)

**【具体例】**

バックアップファイルの実際のコード

```PHP
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

# データを作成
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



## 02-03. 排他制御

### :pushpin: なぜ排他制御が必要か

![排他制御-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-1.png)

#### ・排他制御を行った結果

  ![排他制御-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-2.png)

  

### :pushpin: 排他制御におけるロックの種類

![排他制御-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-3.gif)

-  **共有ロック**

CRUDのRead以外の操作を実行不可能にする．データのRead時に，他者によってUpdateされたくない場合に用いる．「共有」の名の通り，共有ロックされているデータに対して，他の人も共有ロックを行うことができる．

#### ・専有ロック

CRUDの全ての操作を実行不可能にする．データのUpdate時に，他者によってUpdateもReadもされたくない場合に用いる．



### :pushpin: ロックの粒度

![ロックの粒度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ロックの粒度-1.png)

DB ＞ テーブル ＞ レコード ＞ カラム の順に，粒度は大きい．ロックの粒度が細かければ，トランザクションの同時実行性が高くなって効率は向上する（複数の人がDBに対して作業できる）．しかし，ロックの粒度を細かくすればするほど，それだけデータベース管理システムのCPU負荷は大きくなる．

![ロックの粒度-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ロックの粒度-2.jpg)



### :pushpin: デッドロック現象

複数のトランザクションが，互いに他者が使いたいデータをロックしてしまい，お互いのロック解除を待ち続ける状態のこと．もう一方のレコードのロックが解除されないと，自身のレコードのロックを解除できない時，トランザクションが停止する．

#### ・共有ロックしたデータを共有ロック

#### ・共有ロックしたデータを専有ロック

#### ・専有ロックしたデータを共有ロック

#### ・専有ロックしたデータを専有ロック

![Null](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/デッドロック.gif)



## 03-01. ```create```によるテーブルの作成

```PHP
// 注文テーブル作成
CREATE TABLE order_data (

    // Primary Key制約
    order_id INT(10) PRIMARY KEY COMMENT '注文ID',

    // Not Null制約
    order_kbn INT(3) NOT NULL COMMENT '注文区分',
    system_create_date_time DATETIME NOT NULL COMMENT 'システム登録日時',
    system_update_date_time DATETIME NOT NULL COMMENT 'システム更新日時',
    delete_flg INT(1) DEFAULT 0 NOT NULL COMMENT '0：通常，1：削除済',
  
    // 複合Primary Key制約（これを指定する場合，上記のPrimary Key制約の記述は不要）
    PRIMARY KEY(order_id, order_kbn)
  
    // 参照制約キー
    FOREIGN KEY order_kbn REFERENCES order_kbn_data
)
```



### :pushpin: Primary key（主キー）制約と複合主キー制約

テーブルの中で，Rowデータを一意に特定できる値を『主キー』の値と呼ぶ．

![主キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/主キー.jpg)

主キーは複数設定することができ，複合主キーの場合，片方のフィールドの値が異なれば，異なる主キーとして見なされる．以下のように，ユーザIDと期間開始日付を複合主キーとすると，一人のユーザが複数の期間をもつ場合に対応できる．

| *user_id* | *period_start_date* | period_end_date | fee_yen |
| --------- | ------------------- | --------------- | ------- |
| *1*       | *2019-04-03*        | 2019-05-03      | 200     |
| *1*       | *2019-10-07*        | 2019-11-07      | 400     |
| *2*       | *2019-10-11*        | 2019-11-11      | 200     |



### :pushpin: Not Null制約

レコードに挿入される値のデータ型を指定しておくことによって，データ型不一致やNullのための例外処理を実装しなくてもよくなる．



### :pushpin: Foreign key（外部キー）と参照制約

複数のテーブルを関連付けるために用いられるカラムのことをForeign key（外部キー）という．外部キーの参照先のテーブルには，外部キーの値と同じ値のカラムが存在していなければならない（参照制約）．参照制約を行うと，以下の2つが起こる．

#### ・親テーブルに存在しない値は，子テーブルに登録できない．

#### ・親テーブルで参照される値は，子テーブルからは削除できない．

![外部キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/外部キー.png)



### :pushpin: stored procedure

あらかじめ一連のSQL文をデータベースに格納しておき，Call文で呼び出す方式．

![p325](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p325.gif)

**【実装例】**

```PHP
// PROCEDUREを作成し，データベースへ格納しておく．
CREATE PROCEDURE SelectContact AS　
  SELECT CustomerID, CompanyName, ContactName, Phone
  FROM Customers
```

```PHP
// PROCEDUREを実行
EXEC SelectContact
```



## 03-02. ```INSERT```によるデータ行の入力

**【スクラッチ開発による実装例】**

```PHP
// $_POSTを用いて，送信されたpostメソッドのリクエストを受け取り，属性から各値を取得
$staff_name = $_POST['name'];
$staff_pass = $_POST['pass'];


// HTMLとして変数の内容を出力する際，「<」「>」などの特殊文字をエスケープ（無害化）
$staff_name = htmlspecialchars($staff_name, ENT_QUOTES, 'UTF-8');
$staff_pass = htmlspecialchars($staff_pass, ENT_QUOTES, 'UTF-8');


// データベースと接続（イコールの間にスペースを入れるとエラーになる）
$dsn = 'mysql:dbname=kizukeba_pronami_php;
host=kizukebapronamiphp
charaset=UTF-8';
$user = 'root';
$password = '';
$dbh = new PDO($dsn, $user, $password);
$dbh->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);


// 列名と値を指定してINSERT
$sql='INSERT INTO mst_staff (name,password) VALUES (?,?)';
$stmt = $dbh->prepare($sql);


// 配列に値を格納（格納する値の順番と，SQLでの引数の順番は，合わせる必要がある）
$data[] = $staff_name;
$data[] = $staff_pass;


// SQLを実行
$stmt->execute($data);


// データベースとの接続を切断
$dbh = null;
```



## 03-03. ```migration```によるデータベースの更新

マイグレーションファイルと呼ばれるスクリプトファイルを作成し，テーブルの新規作成やカラムの追加はこのスクリプトファイルに記述していく．

1. 誰かが以下のMigrationファイルをmaster別名にPush
2. Migrationファイルをローカル環境にPull
3. データベース更新バッチを実行し，ローカル環境のDBスキーマとデータを更新

```PHP
namespace Migration

class ItemQuery
{
    // 列名と値を指定してINSERT
    public static function insert()
    {
        return "INSERT INTO item_table VALUES(1, '商品A', 1000, '2019-07-24 07:07:07');"
    }
}
```



## 04-01. ```select```によるデータセットの取得

### :pushpin: 実装例で用いた略号

**C**：column（列）

**R**：record（行）

**T**：table



### :pushpin: SQLの処理の順番

```php
from => join => where => group by => having => select => order by
```



### :pushpin: ```join```（結合）

![内部結合のベン図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/内部結合のベン図.jpg)



### :pushpin: ```left join```（左外部結合）

『users』テーブルと『items』テーブルの商品IDが一致しているデータと，元となる『users』テーブルにしか存在しないデータが，セットで取得される．

![LEFT_JOIN](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/LEFT_JOIN.png)



### :pushpin: ```inner join```（内部結合）

基本情報技術者試験では，内部結合（A∩B）しか出題されない．

#### ・内部結合に```where```を用いる場合

2つの```where```文が，```AND```で結びつけられている時，まず一つ目の```where```を満たすレコードを取得した後，取得したレコードの中から，二つ目の```where```を満たすレコードを取得する．

```PHP
// 『カラム』だけでなく，どの『表』なの物なのかも指定
select T1.C1,
    // 複数の表を指定
    from T1, T2,
    // まず，1つ目のフィールドと2つ目のフィールドが同じレコードを取得．
    where R1 = R2 and  
    // 次に，上記で取得したレコードのうち，次の条件も満たすレコードのみを取得．
    R2 = R3  
```

#### ・内部結合に```inner join on```を用いる場合（本試験では出題されない）

```PHP
// 『カラム』だけでなく，どの『表』なの物なのかも指定
select T1.C1,
    // 複数の表を指定
    from T1  
    inner join T2
        // 2つ目の表の『レコード』と照合
        on T1.C1 = T2.C2  
    inner join T3
        // 3つ目の表の『レコード』と照合
        on T1.C1 = T3.C3  
```



### :pushpin: 集合関数まとめ

#### ・```sum()```

```PHP
// 指定したカラムで，『フィールド』の合計を取得
select sum(C)  
    from T;
```

#### ・```avg()```

```PHP
// 指定したカラムで，『フィールド』の平均値を取得
select avg(C)  
    from T;
```

#### ・```min()```

```PHP
// 指定したカラムで，『フィールド』の最小値を取得
select min(C)
    from T;
```

#### ・```max()```

```PHP
// 指定したカラムで，『フィールド』の最大値を取得
select max(C)
    from T;
```

#### ・```count()```

```PHP
// 指定したカラムで，『フィールド』の個数を取得
select count(C)
    from T;
```

**※消去法の小技：集合関数を入れ子状にはできない**

```PHP
// 集合関数を集合関数の中に入れ子状にすることはできない．
select avg(sum(C))
    from T;
```

```PHP
// 指定したカラムで，値無しも含む『フィールド』を取得
select count(*)
    from T;
```

```PHP
// 指定したカラムで，値無しを除いた『フィールド』を取得
select count(C);

// 上に同じ
select count(all C);
```

```PHP
// 指定したカラムで，重複した『フィールド』を除く全ての『フィールド』を取得 
select count(distinct C);
```



### :pushpin: ```in```

**【IN句を使用しなかった場合】**

```PHP
SELECT * FROM fruit WHERE name = "みかん" OR name = "りんご";
```

**【IN句を使用した場合】**

```PHP
SELECT * FROM fruit WHERE name IN("みかん","りんご");
```



### :pushpin: ```group by```

#### ・集合関数との組み合わせ

カラムをグループ化し，フィールドの値を計算する．

```PHP
select C1, avg(C2)
    from T
    // 指定したカラムをグループ化し，フィールドの値を合計する．
    group by C;
```



### :pushpin: ```having```

各句の処理の順番から考慮して，```group by```でグループ化した結果から，```having```で『フィールド』を取得．```select```における集計関数が，```having```における集計関数の結果を指定していることに注意せよ．

```PHP
// havingによる集計結果を指定して出力．
select C1, count(C2) 
    from T
    group by C2
    // グループ化した結果を集計し，２個以上の『フィールド』を取得
    having count(C2) >= 2; 
```

※以下の場合，```group by + having```を使っても，```where```を使っても，同じ出力結果になる．

```PHP
select C
    from T
    group by C
    having R;
```

```PHP
select C
    from T
    where R
    group by C;
```



### :pushpin: sub-query

掛け算と同様に，括弧内から先に処理を行う．

```PHP
// Main-query
select * from T
    // Sub-query
    where C != (select max(C) from T);
```



### :pushpin: ```in```と```any```

#### ・```in```

  指定した値と同じ『フィールド』を取得

```PHP
select * from T
    // 指定したカラムで，指定した値の『フィールド』を取得
    where C in (xxx, xxx, ...);
```

```PHP
select * from T
    // 指定したカラムで，指定した値以外の『フィールド』を取得
    where C not in (R1, R2, ...);
```

```PHP
select * from T
    // フィールドを指定の値として用いる
    where C not in (
        // 指定したカラムで，『フィールド』を取得
        select C from T where R >= 160);
```

#### ・```any```

  書き方が異なるだけで，```in```と同じ出力

```PHP
select * from T
    where C = any(xxx, xxx, xxx);
```



### :pushpin: ```view```

ビューとはある表の特定のカラムや指定した条件に合致するレコードなどを取り出した仮想の表．また，複数の表を結合したビューを作成できる．ビューを作成することによりユーザに必要最小限のカラムやレコードのみにアクセスさせる事ができ，また結合条件を指定しなくても既に結合された表にアクセスできる．
⇒よくわからん…

```PHP
create view T as
    select * from ...;
```



### :pushpin: ```wildcard```

```PHP
select * from T
    // 任意の文字（文字無しも含まれる）
    where C like '%営業';
```

```PHP
select * from T
    // 任意の一文字
    where C like '_営業';
```



### :pushpin: ```between```

```PHP
select * from T
    // 指定したカラムで，1以上10以下の『フィールド』を取得
    between 1 and 10;
```



### :pushpin: 変数

```SQL
/* 括弧内に値を設定してください */
SET @STAFF_NAME = {パラメータ値};
SET @STAFF_ID = {パラメータ値};

UPDATE `mst_staff`
  SET `staff_name` = @STAFF_NAME,
  WHERE `staff_id` = @STAFF_ID;
```



### :pushpin: プレースホルダー

プリペアードステートメントともいう．





## 04-02. ```fetch```によるデータ行の取得

### :pushpin: PHPの場合

DBで取得したデータをプログラムに一度に全て送信してしまうと，プログラム側のメモリを圧迫してしまう．そこで，fetchで少しずつ取得する．

**【実装例】**

```PHP
// select文を定義して実行．
$sql = "SELECT * FROM doraemon_characters";
$stmt = $dbh->prepare($sql);
$stmt->execute()


// 全てのデータ行を取得
$data = $stmt->fetchAll();

// 出力
print_r($data);


// カラム名と値の連想配列として取得できる．
Array
(
    [0] => Array
    (
        [id] => 1
        [name] => のび太
        [gender] => man
        [type] => human
    )
    [1] => Array
    (
        [id] => 2
        [name] => ドラえもん
        [gender] => man
        [type] => robot
    )
)
```



### :pushpin: Javaの場合

PHPとは異なり，変数定義に『$』は用いないことに注意．

**【実装例】**

```java
// select文を定義して実行．
String sql = "SELECT * FROM doraemon_characters";
ResultSet result statement.executeQuery();


// 全てのデータ行を取得
while(result.next()){
    System.out.println(result.getInt("id"));
    System.out.println(result.getString("name"));
    System.out.println(result.getString("gender"));
    System.out.println(result.getString("typeL"));
}


// カラム名と値の連想配列として取得できる．
ここに出力結果コードを書く．

```



## 05-01. レコードの突き合わせ

### :pushpin: 突き合わせ処理とは

ビジネスの基盤となるマスタデータ（商品データ，取引先データなど）と，日々更新されるトランザクションデータ（販売履歴，入金履歴など）を突き合わせ，新しいデータを作成する処理のこと．

![マッチング処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マッチング処理_1.PNG)



### :pushpin: 突き合わせ処理のアルゴリズム

![マッチング処理_4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マッチング処理_4.png)

**【突き合わせ処理の具体例】**

とある生命保険会社では，顧客の保険契約データを契約マスタテーブルで，またそれとは別に，保険契約データの変更点（異動事由）を異動トランザクションテーブルで，管理している．毎日，契約マスタテーブルと異動トランザクションテーブルにおける前日レコードを突き合わせ，各契約の異動事由に応じて，変更後契約データとして，新契約マスタテーブルに挿入する．

![マッチング処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マッチング処理_2.PNG)

前処理として，契約マスタデータと異動トランザクションデータに共通する識別子が同じ順番で並んでいる必要がある．

1. 契約マスタデータの1行目と，異動トランザクションデータの1行目の識別子を突き合わせる．『契約マスタデータ = 異動トランザクションデータ』の時，異動トランザクションデータを基に契約マスタデータを更新し，それを新しいデータとして変更後契約マスタデータに挿入する．
2. 契約マスタデータの2行目と，異動トランザクションデータの2行目の識別子を突き合わせる．『マスタデータ < トランザクションデータ』の場合，マスタデータをそのまま変更後マスタテーブルに挿入する．
3. マスタデータの3行目と，固定したままのトランザクションデータの2行目の識別子を突き合わせる．『マスタデータ = トランザクションデータ』の時，トランザクションデータを基にマスタデータを更新し，それを変更後データとして変更後マスタテーブルに挿入する．
4. 『契約マスタデータ < 異動トランザクションデータ』になるまで，データを突き合わせる．
5. 最終的に，変更後マスタテーブルは以下の通りになる．

![マッチング処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マッチング処理_3.png)

