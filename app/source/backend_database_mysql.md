# SQL

## 01. レコードの読み出し操作（```READ```）


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

```mysql
-- 指定したカラムで，『フィールド』の合計を取得
SELECT SUM(C)  
FROM T;
```

#### ・```AVG()```

```mysql
-- 指定したカラムで，『フィールド』の平均値を取得
SELECT AVG(C)  
FROM T;
```

#### ・```min()```

```mysql
-- 指定したカラムで，『フィールド』の最小値を取得
SELECT MIN(C)
FROM T;
```

#### ・```max()```

```mysql
-- 指定したカラムで，『フィールド』の最大値を取得
SELECT MAX(C)
FROM T;
```

#### ・```COUNT()```

```mysql
-- 指定したカラムで，『フィールド』の個数を取得
SELECT COUNT(*)
FROM T;
```

**※消去法の小技：集合関数を入れ子状にはできない**

**【実装例】**

```mysql
-- 集合関数を集合関数の中に入れ子状にすることはできない．
SELECT AVG(SUM(C))
FROM T;
```

```mysql
-- 指定したカラムで，値無しも含む『フィールド』を取得
SELECT COUNT(*)
FROM T;
```

```mysql
-- 指定したカラムで，値無しを除いた『フィールド』を取得
SELECT COUNT(*);
```

### ```CASE```句

 カラムAがtrueだったら，カラムBを取得する．falseであったら，カラムCを取得する．

```mysql
SELECT
  CASE
    WHEN t.CA = 1 THEN t.CB
    ELSE t.CC
  END AS name
FROM
  T AS t
;
```



### ```FROM```句

#### ・```JOIN```句の種類

![内部結合のベン図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/内部結合のベン図.jpg)



#### ・```left JOIN```（左外部結合）

『users』テーブルと『items』テーブルの商品IDが一致しているデータと，元となる『users』テーブルにしか存在しないデータが，セットで取得される．

![LEFT_JOIN](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/LEFT_JOIN.png)



#### ・```INNER JOIN```（内部結合）

基本情報技術者試験では，内部結合（A∩B）しか出題されない．

#### ・内部結合に```WHERE```を用いる場合

2つの```WHERE```文が，```AND```で結びつけられている時，まず一つ目の```WHERE```を満たすレコードを取得した後，取得したレコードの中から，二つ目の```WHERE```を満たすレコードを取得する．

**【実装例】**

```mysql
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

```mysql
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
<?php
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

```mysql
SELECT *
FROM T
-- 指定したカラムで，指定した値の『フィールド』を取得
WHERE C in (xxx, xxx, ...);
```

```mysql
SELECT *
FROM T
-- 指定したカラムで，指定した値以外の『フィールド』を取得
WHERE C not in (R1, R2, ...);
```

```mysql
SELECT * FROM T
-- フィールドを指定の値として用いる
WHERE C not in (
  -- 指定したカラムで，『フィールド』を取得
  SELECT C FROM T WHERE R >= 160);
```

**【IN句を使用しなかった場合】**

```mysql
SELECT *
FROM fruit
WHERE name = "みかん"
  OR name = "りんご";
```

**【IN句を使用した場合】**

```mysql
SELECT * 
FROM fruit
WHERE name IN("みかん","りんご");
```

#### ・```ANY```句の使い方

  書き方が異なるだけで，```in```と同じ出力

```mysql
SELECT *
FROM T
WHERE C = ANY(xxx, xxx, xxx);
```



### ```GROUP BY```句

#### ・使い方

カラムをグループ化し，集合関数を使用して，フィールドの値を計算する．

**【実装例】**

```mysql
SELECT C1, AVG(C2)
FROM T
-- 指定したカラムをグループ化し，フィールドの値を合計する．
GROUP BY C;
```



### ```HAVING```句

#### ・使い方

各句の処理の順番から考慮して，```GROUP BY```でグループ化した結果から，```HAVING```で『フィールド』を取得．```SELECT```における集計関数が，```HAVING```における集計関数の結果を指定していることに注意せよ．

**【実装例】**

```mysql
-- HAVINGによる集計結果を指定して出力．
SELECT C1, COUNT(C2) 
FROM T
GROUP BY C2
-- グループ化した結果を集計し，２個以上の『フィールド』を取得
HAVING COUNT(*) >= 2; 
```

※以下の場合，```GROUP BY + HAVING```を使っても，```WHERE```を使っても，同じ出力結果になる．

```mysql
SELECT C
FROM T
GROUP BY C
HAVING R;
```

```mysql
SELECT C
FROM T
WHERE R
GROUP BY C;
```



### ```WILDCARD```句

#### ・使い方

**【実装例】**

```mysql
SELECT * FROM T
-- 任意の文字（文字無しも含まれる）
WHERE C LIKE '%営業';
```

```mysql
SELECT * FROM T
-- 任意の一文字
WHERE C LIKE '_営業';
```



### ```BETWEEN```句

#### ・使い方

**【実装例】**

```mysql
SELECT * FROM T
-- 指定したカラムで，1以上10以下の『フィールド』を取得
BETWEEN 1 AND 10;
```



### ```SET```句

#### ・使い方

**【実装例】**

```mysql
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

```mysql
-- Main-query
SELECT * FROM T

WHERE C != (
  -- Sub-query
  SELECT max(C) FROM T);
```



## 01-02. 読み出されたレコードの取得処理（```fetch```）

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
<?php
// SELECT文を定義して実行．
$sql = "SELECT * FROM doraemon_characters";
$stmt = $dbh->prepare($sql);
$stmt->execute();


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
<?php
// SELECT文を定義して実行．
$sql = "SELECT COUNT(*) FROM doraemon_characters";
$stmt = $dbh->prepare($sql);
$stmt->execute();

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



## 01-03. レコードの突き合わせ

### 突き合わせ処理

#### ・突き合わせ処理とは

ビジネスの基盤となるマスタデータ（商品データ，取引先データなど）と，日々更新されるトランザクションデータ（販売履歴，入金履歴など）を突き合わせ，新しいデータを作成する処理のこと．

![マッチング処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マッチング処理_1.PNG)

#### ・アルゴリズム

![マッチング処理_4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マッチング処理_4.png)

#### ・具体例

とある生命保険会社では，顧客の保険契約データを契約マスタテーブルで，またそれとは別に，保険契約データの変更点（異動事由）を異動トランザクションテーブルで，管理している．毎日，契約マスタテーブルと異動トランザクションテーブルにおける前日レコードを突き合わせ，各契約の異動事由に応じて，変更後契約データとして，新契約マスタテーブルに挿入する．

![マッチング処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マッチング処理_2.PNG)

前処理として，契約マスタデータと異動トランザクションデータに共通する識別子が同じ順番で並んでいる必要がある．

1. 契約マスタデータの1行目と，異動トランザクションデータの1行目の識別子を突き合わせる．『契約マスタデータ = 異動トランザクションデータ』の時，異動トランザクションデータを基に契約マスタデータを更新し，それを新しいデータとして変更後契約マスタデータに挿入する．
2. 契約マスタデータの2行目と，異動トランザクションデータの2行目の識別子を突き合わせる．『マスタデータ < トランザクションデータ』の場合，マスタデータをそのまま変更後マスタテーブルに挿入する．
3. マスタデータの3行目と，固定したままのトランザクションデータの2行目の識別子を突き合わせる．『マスタデータ = トランザクションデータ』の時，トランザクションデータを基にマスタデータを更新し，それを変更後データとして変更後マスタテーブルに挿入する．
4. 『契約マスタデータ < 異動トランザクションデータ』になるまで，データを突き合わせる．
5. 最終的に，変更後マスタテーブルは以下の通りになる．

![マッチング処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マッチング処理_3.png)



## 02. レコードの書き込み操作 （```CREATE```，```UPDATE```，```DELETE```）

### ```insert```

#### ・PDOを用いた```insert```処理

```PHP
<?php
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

3. データベース更新バッチを実行し，ローカル環境のデータベーススキーマとレコードを更新

**【実装例】**

```PHP
<?php
namespace Migration;

class ItemQuery
{
    // 列名と値を指定してINSERT
    public static function insert()
    {
        return "INSERT INTO item_table VALUES(1, '商品A', 1000, '2019-07-24 07:07:07');";
    }
}
```



## 02-02. テーブルの生成処理（```create```）

### ```create table```句

#### ・使い方

**【実装例】**

```mysql
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

```mysql
CREATE VIEW T AS
    SELECT * FROM T1;
```



### 制約

#### ・Primary key（主キー）制約と複合主キー制約

テーブルの中で，レコードを一意に特定できる値を『主キー』の値と呼ぶ．

![主キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/主キー.jpg)

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

![外部キー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/外部キー.png)



### stored procedure

#### ・stored procedureとは

あらかじめ一連のSQL文をデータベースに格納しておき，Call文で呼び出す方式．

![p325](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p325.gif)

#### ・使い方

**【実装例】**

```mysql
-- PROCEDUREを作成し，データベースへ格納しておく．
CREATE PROCEDURE SelectContact AS
  SELECT CustomerID, CompanyName, ContactName, Phone
  FROM Customers
```

```mysql
-- PROCEDUREを実行
EXEC SelectContact
```



## 03. ユーザの読み出し，書き込み

### CREATE

#### ・ユーザ作成

```mysql
CREATE USER '{ユーザ名}' IDENTIFIED BY '{パスワード}'
```



### GRANT

#### ・ユーザに権限を付与

| SQLでの表記          | 意味             |
| -------------------- | ---------------- |
| ```ALL PRIVILEGES``` | 全権限           |
| ```SELECT```         | 読み出し権限のみ |


データベース名は，シングルクオーテーションで囲う必要が無い．全権限を付与する場合，```PRIVILEGES```は省略できるが，厳密には省略しないようほうがよい．


```mysql
# 全てのデータベースに関する権限を付与
GRANT ALL PRIVILEGES ON *.* TO '{ユーザ名}';

# Amazon AuroraまたはRDSの場合はこちら
GRANT USAGE ON `%`.* TO '{ユーザー名}';
```

```mysql
# 特定のデータベースに関する全権限を付与
GRANT ALL PRIVILEGES ON {DB名}.* TO '{ユーザ名}';
```


#### ・ユーザの権限を確認

ユーザに付与されている権限を表示する．

```mysql
SHOW GRANTS FOR '{ユーザ名}';
```

作成しただけで権限を何も付与してないユーザの場合，「データベースサーバ内の全データベースに関して，全権限なし」を表す```USAGE```として表示される．

```mysql
GRANT USAGE ON *.* TO '{ユーザー名}';
```

特定のデータベースの操作権限を与えると，加えて，以下も表示されるようになる．

```mysql
GRANT ALL PRIVILEGES ON {DB名}.* TO '{ユーザ名}';
```



### REVOKE

#### ・全ての権限を削除

```mysql
REVOKE ALL PRIVILEGES ON {DB名}.* FROM '{ユーザ名}';
```


#### ・ユーザ名を変更

```mysql
RENAME USER '{古いユーザ名}' TO '{新しいユーザ名}';
```



## 04. mysqlコマンド

### mysqlテーブルの操作

#### ・ユーザの一覧を確認

ここで表示される特権と．ALL特権は異なる．

```mysql
SELECT * FROM mysql.user;
```



### テーブルの生成

#### ・テーブルをインポート

```bash
# forceオプションで，エラーが出ても強制的にインポート
mysql --force -u '{アカウント}' -p -h '{DBのホスト}' '{DB名}' < table_backup.sql
```

