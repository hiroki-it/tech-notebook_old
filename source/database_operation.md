# データベースの操作

## 01. RDB（関係データベース）とは

### RDBMS（関係データベース管理システム）の仕組み

RDBは，データ同士がテーブル状に関係をもつデータ格納形式である．データはストレージに保存する．

![データベース管理システムの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/データベース管理システムの仕組み.png)



### RDBMSとRDBの種類

![DBMS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DBMS.jpg)

#### ・MariaDB

  MariaDBデータベースを管理できるRDBMS

#### ・MySQL

  MySQLデータベースを管理できるRDBMS

#### ・PostgreSQL

  PostgreSQLデータベースを管理できるRDBMS




### RDBSにおけるデータベースエンジン

RDBMSがデータベースに対してデータのCRUDの処理を行うために必要なソフトウェアのこと．

#### ・InnoDB



## 01-02. NoSQL（非関係データベース）とは

NoSQLは，データ同士が関係を持たないデータ格納形式である．データをメインメモリに保存する．

### NoSQLの種類

![NoSQLの分類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/NoSQLの種類.jpg)




## 01-03. RDBの設計

### UMLによる設計

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．



### ER図による設計：Entity Relation Diagram

16章を参照．Squidの設計図では，UMLとER図を組み合わせている．



## 01-04. テーブルの作成

### データを追加するあるいは削除する場合の注意点

データを追加するあるいは削除する場合，カラムではなく，レコードの増減を行う．カラムの増減の処理には時間がかかる．一方で，レコードの増減の処理には時間がかからない．

![カラムの増減は✖，レコードの増減は〇](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/カラムの増減は✖，レコードの増減は〇-1.png)

**【具体例】**

賞与を年1回から，2回・3回と変える場合，主キーを繰り返し，新しく賞与区分と金額区分を作る．

![カラムの増減は✖，レコードの増減は〇-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/カラムの増減は✖，レコードの増減は〇-2.png)



### 非正規形の正規化

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



## 02-02. コミットメント制御と障害回復制御

### RDBの書き込み系の操作

#### ・RDBに対するC／U／Dの処理の大まかな流れ

![コミットメント制御](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/コミットメント制御.jpg)

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



### ログファイルへの更新前ログの書き込み



### コミットによるログファイルへの更新前ログへの書き込み

#### ・コミット

トランザクション内の一連のステートメントを，ログファイルの更新前ログとして書き込む．

#### ・二相コミット

コミットを以下の二つの段階に分けて行うこと．ACIDのうち，原子性と一貫性を実装している．

1. 他のサイトに更新可能かどうかを確認．
2. 全サイトからの合意が得られた場合に更新を確定．



### チェックポイントにおけるデータファイルへの書き込み

トランザクションの終了後，DBMSは，処理速度を高めるために，ログファイルの更新後ログをいったんメモリ上で管理する．

![DBMSによるメモリとディスクの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DBMSによるメモリとディスクの使い分け.jpg)

そして，チェックポイントで，ログファイルの更新後ログをディスク上のデータファイルに反映させる．この時，チェックポイントは，自動実行または手動実行で作成する．

![トランザクション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/トランザクション.jpg)



### システム障害からの回復

データベースサーバのソフトウェア障害のこと．例えば，DBMSやOSのトラブル等によりシステム全体が停止する．

![障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/システム障害の障害回復機能.jpg)

#### ・ロールバック

障害によって，トランザクション内の一連のステートメントがすべて実行されなかった場合に，ログファイルの更新前ログを用いて，トランザクションの開始前の状態に戻す．

#### ・ロールフォワード

障害によって，トランザクションの終了後に一連のステートメントの更新結果がディスクに反映されなかった場合に，ログファイルの更新後ログを用いて，ディスク上のデータファイルに更新結果を反映させる．

**【具体例】**

『a』の値を更新するステートメントを含むトランザクションの後に，システムが異常終了した場合，ログファイルの更新後ログ『a = 5』を用いて，ディスク上のデータファイルに更新結果を反映させる．（ロールフォワード）

『b』の値を更新するステートメントを含むトランザクションの途中に，システムが異常終了した場合，ログファイルの更新前ログ『b = 1』を用いて，障害発生前の状態に戻す．（ロールバック）



### 媒体障害からの回復

データベースサーバのハードウェア障害のこと．例えば，ハードディスクの障害がある．ディスクを初期化／交換した後，バックアップファイルからデータベースを修復し，ログファイルの更新後ログ『a = 5』『b = 1』を用いて，修復できる限りロールフォワードを行う．

![媒体障害の障害回復機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/媒体障害の障害回復機能.jpg)

**【具体例】**

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



## 02-03. 排他制御

### なぜ排他制御が必要か

![排他制御-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-1.png)

#### ・排他制御を行った結果

  ![排他制御-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-2.png)

  

### 排他制御のためのロック操作

![排他制御-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/排他制御-3.gif)

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

![Null](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/デッドロック.gif)

#### ・ロックの粒度

![ロックの粒度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ロックの粒度-1.png)

DB ＞ テーブル ＞ レコード ＞ カラム の順に，粒度は大きい．ロックの粒度が細かければ，トランザクションの同時実行性が高くなって効率は向上する（複数の人がDBに対して作業できる）．しかし，ロックの粒度を細かくすればするほど，それだけベース管理システムのCPU負荷は大きくなる．

![ロックの粒度-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ロックの粒度-2.jpg)



## 03. レコードの読み出し操作（```READ```）


### はじめに

#### ・句の処理の順番

```
FROM => JOIN => WHERE => GROUP BY => HAVING => SELECT => ORDER BY
```

#### ・使い方で用いた略号

**C**：column（列）

**R**：record（行）

**T**：table



### ```SELECT```句

#### ・```SUM()```

```SQL
-- 指定したカラムで，『フィールド』の合計を取得
SELECT SUM(C)  
FROM T;
```

#### ・```AVG()```

```SQL
-- 指定したカラムで，『フィールド』の平均値を取得
SELECT AVG(C)  
FROM T;
```

#### ・```min()```

```SQL
-- 指定したカラムで，『フィールド』の最小値を取得
SELECT MIN(C)
FROM T;
```

#### ・```max()```

```SQL
-- 指定したカラムで，『フィールド』の最大値を取得
SELECT MAX(C)
FROM T;
```

#### ・```COUNT()```

```SQL
-- 指定したカラムで，『フィールド』の個数を取得
SELECT COUNT(*)
FROM T;
```

**※消去法の小技：集合関数を入れ子状にはできない**

**【実装例】**

```SQL
-- 集合関数を集合関数の中に入れ子状にすることはできない．
SELECT AVG(SUM(C))
FROM T;
```

```SQL
-- 指定したカラムで，値無しも含む『フィールド』を取得
SELECT COUNT(*)
FROM T;
```

```SQL
-- 指定したカラムで，値無しを除いた『フィールド』を取得
SELECT COUNT(*);
```



### ```FROM```句

#### ・```JOIN```句の種類

![内部結合のベン図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/内部結合のベン図.jpg)



#### ・```left JOIN```（左外部結合）

『users』テーブルと『items』テーブルの商品IDが一致しているデータと，元となる『users』テーブルにしか存在しないデータが，セットで取得される．

![LEFT_JOIN](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/LEFT_JOIN.png)



#### ・```INNER JOIN```（内部結合）

基本情報技術者試験では，内部結合（A∩B）しか出題されない．

#### ・内部結合に```WHERE```を用いる場合

2つの```WHERE```文が，```AND```で結びつけられている時，まず一つ目の```WHERE```を満たすレコードを取得した後，取得したレコードの中から，二つ目の```WHERE```を満たすレコードを取得する．

**【実装例】**

```SQL
-- 『カラム』だけでなく，どの『表』なの物なのかも指定
SELECT T1.C1,
-- 複数の表を指定
FROM T1, T2,
-- まず，1つ目のフィールドと2つ目のフィールドが同じレコードを取得．
WHERE R1 = R2
  -- 次に，上記で取得したレコードのうち，次の条件も満たすレコードのみを取得．
  AND R2 = R3  
```

#### ・内部結合に```INNER JOIN ON```を用いる場合

**【実装例】**

```SQL
-- 『カラム』だけでなく，どの『表』なの物なのかも指定
SELECT T1.C1,
-- 複数の表を指定
FROM T1
  INNER JOIN T2
  -- 2つ目の表の『レコード』と照合
  ON T1.C1 = T2.C2  
  INNER JOIN T3
  -- 3つ目の表の『レコード』と照合
  ON T1.C1 = T3.C3  
```



### ```ORDER BY```句

#### ・使い方

**【実装例】**


```PHP
$joinedIdList = implode(',', $idList);

// 並び替え条件を設定
$expression = call_user_func(function () use ($orders, $joinedIdList) {
    if ($orders) {
        foreach ($orders as $key => $order) {
            switch ($key) {
                case 'id':
                    return sprintf('ss.id %s', $order);
            }
        }
    }
    
    // IN句順の場合
    return sprintf('FIELD(ss.id, %s)', $idList);
});

$sql = <<<SQL
            SELECT 
                name
            FROM
                table
            ORDER BY {$expression}
        SQL;
```



### ```IN```句，```ANY```句の違い

#### ・```IN```句の使い方

  指定した値と同じ『フィールド』を取得

**【実装例】**

```SQL
SELECT *
FROM T
-- 指定したカラムで，指定した値の『フィールド』を取得
WHERE C in (xxx, xxx, ...);
```

```SQL
SELECT *
FROM T
-- 指定したカラムで，指定した値以外の『フィールド』を取得
WHERE C not in (R1, R2, ...);
```

```SQL
SELECT * FROM T
-- フィールドを指定の値として用いる
WHERE C not in (
  -- 指定したカラムで，『フィールド』を取得
  SELECT C FROM T WHERE R >= 160);
```

**【IN句を使用しなかった場合】**

```SQL
SELECT *
FROM fruit
WHERE name = "みかん"
  OR name = "りんご";
```

**【IN句を使用した場合】**

```SQL
SELECT * 
FROM fruit
WHERE name IN("みかん","りんご");
```

#### ・```ANY```句の使い方

  書き方が異なるだけで，```in```と同じ出力

```SQL
SELECT *
FROM T
WHERE C = ANY(xxx, xxx, xxx);
```



### ```GROUP BY```句

#### ・使い方

カラムをグループ化し，集合関数を使用して，フィールドの値を計算する．

**【実装例】**

```SQL
SELECT C1, AVG(C2)
FROM T
-- 指定したカラムをグループ化し，フィールドの値を合計する．
GROUP BY C;
```



### ```HAVING```句

#### ・使い方

各句の処理の順番から考慮して，```GROUP BY```でグループ化した結果から，```HAVING```で『フィールド』を取得．```SELECT```における集計関数が，```HAVING```における集計関数の結果を指定していることに注意せよ．

**【実装例】**

```SQL
-- HAVINGによる集計結果を指定して出力．
SELECT C1, COUNT(C2) 
FROM T
GROUP BY C2
-- グループ化した結果を集計し，２個以上の『フィールド』を取得
HAVING COUNT(*) >= 2; 
```

※以下の場合，```GROUP BY + HAVING```を使っても，```WHERE```を使っても，同じ出力結果になる．

```SQL
SELECT C
FROM T
GROUP BY C
HAVING R;
```

```SQL
SELECT C
FROM T
WHERE R
GROUP BY C;
```



### ```WILDCARD```句

#### ・使い方

**【実装例】**

```SQL
SELECT * FROM T
-- 任意の文字（文字無しも含まれる）
WHERE C LIKE '%営業';
```

```SQL
SELECT * FROM T
-- 任意の一文字
WHERE C LIKE '_営業';
```



### ```BETWEEN```句

#### ・使い方

**【実装例】**

```SQL
SELECT * FROM T
-- 指定したカラムで，1以上10以下の『フィールド』を取得
BETWEEN 1 AND 10;
```



### ```SET```句

#### ・使い方

**【実装例】**

```SQL
-- 括弧内に値を設定してください
SET @STAFF_NAME = {パラメータ値};
SET @STAFF_ID = {パラメータ値};

UPDATE `mst_staff`
SET `staff_name` = @STAFF_NAME,
WHERE `staff_id` = @STAFF_ID;
```



### サブクエリ

#### ・使い方

掛け算と同様に，括弧内から先に処理を行う．

**【実装例】**

```SQL
-- Main-query
SELECT * FROM T

WHERE C != (
  -- Sub-query
  SELECT max(C) FROM T);
```



## 03-02. 読み出されたレコードの取得処理（```fetch```）

###  ```fetch```

#### ・```fetch```とは

読み出したレコードをに一度に全て取得してしまうと，サーバ側のメモリを圧迫してしまう．そこで，少しずつ取得する．

#### ・```fetch```のメソッド名に関する注意点

```fetch()```系のメソッドは，ベンダーによって名前が異なっていることがあるため，同じ名前でも同じ分だけレコードを取得するとは限らない．



### PDOにおける```fetch```

#### ・```fetch():array```

読み出された全てのレコードのうち，最初のレコードの全てのカラムを取得し，一次元の連想配列で返却する．

#### ・```fetchAll():array```

読み出された全てのレコードの，全てのカラムを取得し，二次元の連想配列で返却する．

**【実装例】**

```PHP
// SELECT文を定義して実行．
$sql = "SELECT * FROM doraemon_characters";
$stmt = $dbh->prepare($sql);
$stmt->execute()


// 全てのレコードを取得
$data = $stmt->fetchAll();

// 出力
print_r($data);

// カラム名と値の連想配列として取得できる．
// Array
// (
//     [0] => Array
//     (
//         [id] => 1
//         [name] => のび太
//         [gender] => man
//         [type] => human
//     )
//     [1] => Array
//     (
//         [id] => 2
//         [name] => ドラえもん
//         [gender] => man
//         [type] => robot
//     )
// )
```

#### ・```fetchColumn():mixed```

読み出された全てのレコードのうち，最初のレコードの一番左のカラムのみを取得し，混合型で返却する．主に，```COUNT()```の場合に用いる

```PHP
// SELECT文を定義して実行．
$sql = "SELECT COUNT(*) FROM doraemon_characters";
$stmt = $dbh->prepare($sql);
$stmt->execute()

// レコードを取得
$data = $stmt->fetchColumn();

// 出力
print_r($data); 

// 10 (件)
```



### Javaの場合

PHPとは異なり，変数定義に『$』は用いないことに注意．

**【実装例】**

```java
// SELECT文を定義して実行．
String sql = "SELECT * FROM doraemon_characters";
ResultSet result statement.executeQuery();


// 全てのレコードを取得
while(result.next()){
    System.out.println(result.getInt("id"));
    System.out.println(result.getString("name"));
    System.out.println(result.getString("gender"));
    System.out.println(result.getString("typeL"));
}

// カラム名と値の連想配列として取得できる．
// ここに出力結果コードを書く．

```



## 03-03. レコードの突き合わせ

### 突き合わせ処理とは

ビジネスの基盤となるマスタデータ（商品データ，取引先データなど）と，日々更新されるトランザクションデータ（販売履歴，入金履歴など）を突き合わせ，新しいデータを作成する処理のこと．

![マッチング処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マッチング処理_1.PNG)



### 突き合わせ処理のアルゴリズム

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





## 04. レコードの書き込み操作 （```CREATE```，```UPDATE```，```DELETE```）

### ```insert```

#### ・PDOを用いた```insert```処理

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

#### ・マイグレーションにおける```insert```

マイグレーションファイルと呼ばれるスクリプトファイルを作成し，テーブルの新規作成やカラムの追加はこのスクリプトファイルに記述していく．

1. 誰かが以下のMigrationファイルをmaster別名にPush

2. Migrationファイルをローカル環境にPull

3. データベース更新バッチを実行し，ローカル環境のDBスキーマとレコードを更新

**【実装例】**

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





## 04-02. テーブルの生成処理（```create```）

### ```create table```句

#### ・使い方

**【実装例】**

```SQL
-- 注文テーブル作成
CREATE TABLE order_data (

    -- Primary Key制約
    order_id INT(10) PRIMARY KEY COMMENT '注文ID',

    -- Not Null制約
    order_kbn INT(3) NOT NULL COMMENT '注文区分',
    system_create_date_time DATETIME NOT NULL COMMENT 'システム登録日時',
    system_update_date_time DATETIME NOT NULL COMMENT 'システム更新日時',
    delete_flg INT(1) DEFAULT 0 NOT NULL COMMENT '0：通常，1：削除済',
  
    -- 複合Primary Key制約（これを指定する場合，上記のPrimary Key制約の記述は不要）
    PRIMARY KEY(order_id, order_kbn)
  
    -- 参照制約キー
    FOREIGN KEY order_kbn REFERENCES order_kbn_data
)
```



### ```CREATE VIEW```句

#### ・使い方

ビューとはある表の特定のカラムや指定した条件に合致するレコードなどを取り出した仮想の表．また，複数の表を結合したビューを作成できる．ビューを作成することによりユーザに必要最小限のカラムやレコードのみにアクセスさせる事ができ，また結合条件を指定しなくても既に結合された表にアクセスできる．
⇒よくわからん…

**【実装例】**

```SQL
CREATE VIEW T AS
    SELECT * FROM T1;
```



### 制約

#### ・Primary key（主キー）制約と複合主キー制約

テーブルの中で，レコードを一意に特定できる値を『主キー』の値と呼ぶ．

![主キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/主キー.jpg)

主キーは複数設定することができ，複合主キーの場合，片方のフィールドの値が異なれば，異なる主キーとして見なされる．以下のように，ユーザIDと期間開始日付を複合主キーとすると，一人のユーザが複数の期間をもつ場合に対応できる．

| *user_id* | *period_start_date* | period_end_date | fee_yen |
| --------- | ------------------- | --------------- | ------- |
| *1*       | *2019-04-03*        | 2019-05-03      | 200     |
| *1*       | *2019-10-07*        | 2019-11-07      | 400     |
| *2*       | *2019-10-11*        | 2019-11-11      | 200     |

#### ・Not Null制約

レコードに挿入される値のデータ型を指定しておくことによって，データ型不一致やNullのための例外処理を実装しなくてもよくなる．

#### ・Foreign key（外部キー）と参照制約

複数のテーブルを関連付けるために用いられるカラムのことをForeign key（外部キー）という．外部キーの参照先のテーブルには，外部キーの値と同じ値のカラムが存在していなければならない（参照制約）．参照制約を行うと，以下の2つが起こる．

親テーブルに存在しない値は，子テーブルに登録できない．

親テーブルで参照される値は，子テーブルからは削除できない．

![外部キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/外部キー.png)



### stored procedure

#### ・stored procedureとは

あらかじめ一連のSQL文をデータベースに格納しておき，Call文で呼び出す方式．

![p325](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/p325.gif)

#### ・使い方

**【実装例】**

```SQL
-- PROCEDUREを作成し，データベースへ格納しておく．
CREATE PROCEDURE SelectContact AS　
  SELECT CustomerID, CompanyName, ContactName, Phone
  FROM Customers
```

```SQL
-- PROCEDUREを実行
EXEC SelectContact
```


