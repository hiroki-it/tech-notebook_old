# 勉強の方針

1. 必ず、実例として、それが扱われているのかを覚えること。
2. 必ず、言葉ではなく、イラストを用いて覚えること。
3. 必ず、知識の『点』と『点』を繋ぎ、『線』にしろ
4. 必ず、まとめることでインプットしているだけなので、口頭で説明してアプトプットしろ。
5. キタミ式で大枠をとらえて、過去問で肉付けしていく。



# 11-01. データベースとは

### ◇ データベース管理システム（DBMS）

![DBMS](C:\Projects\Summary_Notes\まとめノート\画像\DBMS.jpg)

### ◇ Transaction

![p328](C:\Projects\Summary_Notes\まとめノート\画像\p328.gif)



### ◇ Stored Procedure

あらかじめ一連のSQL文をデータベースに格納しておき、Call文で呼び出す方式。

![p325](C:\Projects\Summary_Notes\まとめノート\画像\p325.gif)

**【実装例】**

```
# PROCEDUREを作成
CREATE PROCEDURE SelectContact AS　
  SELECT CustomerID, CompanyName, ContactName, Phone
  FROM Customers
```

```
# PROCEDUREを実行
EXEC SelectContact
```



### ◇ ACID特性

トランザクション処理では、以下の４つの性質が保証されている必要がある。

- **Atomicity**

  コミットメント制御によって実装される。

- **Consistency** 

  排他制御によって実装される。

- **Isolation** 

  排他制御によって実装される。

- **Durability** 

  障害回復制御によって実装される。



### ◇ コミットメント制御

**【実装例】**トランザクション、コミットメント制御、ロールバック機能

```
try{
    // データベースと接続。
    $db = getDb();

    // 例外処理を有効化。
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // トランザクションを開始。
    $db->beginTransaction();
    // いくつかのSQLが実行される。※もし失敗した場合、ERRMODE_EXCEPTIONを実行。
    $db->exec("INSERT INTO movie(title, price) VALUES('ハリポタ', 2000)")
    $db->exec("INSERT INTO movie(title, price) VALUES('シスター', 2000)")
   
    // トランザクションの全てのSQLに成功したら、トランザクションをコミット。
    $db->commit();
}
catch{
	// 例外が発生したらロールバックし、エラーメッセージを出力。
	$db->rollBack();
	print "エラーメッセージ：{$e->getMessage()}"
}    
```

- **Transaction**

  SQLによる一連のCRUDを一繋ぎにした処理のこと。
  
  **【例】**銀行ATMの振込処理によるCRUD
  
- **コミット機能**

  トランザクションとしてくくられた処理が全て実行された時、その処理結果を確定させ、データを更新する機能。

![コミットメント制御-1](C:\Projects\Summary_Notes\まとめノート\画像\コミットメント制御-1.gif)

- **ロールバック機能**

  トランザクションを中断する何らかの事象が発生した時などに、処理を取り消し、トランザクション開始以前の状態に戻す機能

![コミットメント制御-2](C:\Projects\Summary_Notes\まとめノート\画像\コミットメント制御-2.gif)

- **二相コミット**

  コミットを以下の二つの段階に分けて行うこと。ACIDのうち、原子性と一貫性を実装している。

  （１）他のサイトに更新可能かどうかを確認。

  （２）全サイトからの合意が得られた場合に更新を確定。



### ◇ 排他制御

- **なぜ排他制御が必要か**

  ![排他制御-1](C:\Projects\Summary_Notes\まとめノート\画像\排他制御-1.png)

- **排他制御を行った結果**

  ![排他制御-2](C:\Projects\Summary_Notes\まとめノート\画像\排他制御-2.png)

- **排他制御の種類**

  CRUDのRead以外を実行不可能にする共有ロックと、CRUDの全てを実行不可能にする占有ロックがある。「共有」の名の通り、共有ロックされているデータに対して、他の人も共有ロックを行うことができる。

**【実装例】**

```
// ファイルを共有ロック
flock($file, LOCK_SH);

// ロックの解除
flock($file, LOCK_UN);
```

![排他制御-3](C:\Projects\Summary_Notes\まとめノート\画像\排他制御-3.gif)

- ロックの粒度**

  ![ロックの粒度](C:\Projects\Summary_Notes\まとめノート\画像\ロックの粒度-1.png)

  DB ＞ テーブル ＞ レコード ＞ カラム の順に、粒度は大きい。ロックの粒度が細かければ、トランザクションの同時実行性が高くなって効率は向上する（複数の人がDBに対して作業できる）。しかし、ロックの粒度を細かくすればするほど、それだけデータベース管理システムのCPU負荷は大きくなる。

  ![ロックの粒度-2](C:\Projects\Summary_Notes\まとめノート\画像\ロックの粒度-2.jpg)

- **デッドロック現象**

  もう一方のレコードのロックが解除されないと、自身のレコードのロックを解除できない時、処理が停止するデッドロック現象が起こる。

  ![デッドロック](C:\Projects\Summary_Notes\まとめノート\画像\デッドロック.gif)



### ◇ 障害回復制御

![DBの関連性](C:\Projects\Summary_Notes\まとめノート\画像\DBの関連性.gif)

- **ログファイル（ジャーナルファイル）**

  データベースの処理履歴を記録したファイル。更新前ログファイルや更新後ログファイルとして残しておく。

- **チェックポイント**

  システムで障害が発生した場合、チェックポイントを設け、ログファイルの作成やデータベースのバックアップを行う。

- **Roll forward**

  ハードディスクの不具合でデータベースが破損した場合、まず、チェックポイントまでデータベースを復元する。次に、更新後ログファイルを読み込んでディスク破損直前の状態まで復元する。 

- **Roll back**

  更新処理中に異常が発生した場合、まず、チェックポイントまでデータベースを復元する。次に、更新前ログファイルを読み込んで障害前の状態まで戻し、更新処理自体を無かったことにする。

  

# 11-02. データベースの設計方法

### ◇ **UMLによる設計**

16章を参照。Squidの設計図では、UMLとER図を組み合わせている。



### ◇ **ER図による設計：Entity Relation Diagram**

16章を参照。Squidの設計図では、UMLとER図を組み合わせている。



# 11-03. テーブルの設計と作成

### ◇ 主キー

テーブルの中で、Rowデータを一意に特定できる値を『主キー』の値と呼ぶ。

![主キー](C:\Projects\Summary_Notes\まとめノート\画像\主キー.jpg)



### ◇ データを追加するあるいは削除する場合の注意点

データを追加するあるいは削除する場合、カラムではなく、レコードの増減を行う。カラムの増減の処理には時間がかかる。一方で、レコードの増減の処理には時間がかからない。

![カラムの増減は✖、レコードの増減は〇](C:\Projects\Summary_Notes\まとめノート\画像\カラムの増減は✖、レコードの増減は〇-1.png)

**【具体例】**

賞与を年1回から、2回・3回と変える場合、主キーを繰り返し、新しく賞与区分と金額区分を作る。

![カラムの増減は✖、レコードの増減は〇-2](C:\Projects\Summary_Notes\まとめノート\画像\カラムの増減は✖、レコードの増減は〇-2.png)



### ◇ 非正規形の正規化（最適なカラム設計）

**『正規化』と『非正規形』**：繰り返し要素のある表を正規形、その逆を非正規形という。

**『正規化』**：非正規形の表から、他と連動するカラムを独立させ、正規形の表に変更すること。

**【具体例】**

1. エクセル

   エクセルで作られた以下の表があると仮定。

![非正規形](C:\Projects\Summary_Notes\まとめノート\画像\非正規形.png)

2. 第一正規化：**繰り返し要素の排除**

   レコードを1つずつに分割。

   ![第一正規形](C:\Projects\Summary_Notes\まとめノート\画像\第一正規形.png)

3. 第二正規化：**主キーの関数従属性を排除**

   特定のカラムが連動している（関数従属性）場合、カラムを左表として独立させる

   ![第二正規形-1](C:\Projects\Summary_Notes\まとめノート\画像\第二正規形-1.png)

   上で分割して生じた右表のカラムに関数従属性があるので、従属性のあるカラムを左表として独立させる。

   ![第二正規形-2](C:\Projects\Summary_Notes\まとめノート\画像\第二正規形-2.png)

   ![第二正規形-3](C:\Projects\Summary_Notes\まとめノート\画像\第二正規形-3.png)

4. 第三正規化：**主キー以外のカラムの関数従属性を排除**

   上で分割して生じた左表のカラムに関数従属性があるので、従属性のあるカラムを左表として独立させる。

![第三正規形](C:\Projects\Summary_Notes\まとめノート\画像\第三正規形-1.png)

![第三正規形-2](C:\Projects\Summary_Notes\まとめノート\画像\第三正規形-2.png)



### ◇ Migrationとinsert

1. 誰かが以下のMigrationファイルをmasterにPush
2. Migrationファイルをローカル環境にPull
3. ```db:reset```で、ローカル環境のDBスキーマとデータを更新

```
namespace Migration

class ItemQuery
{
	public static function insert()
	{
		return "INSERT INTO item_table VALUES(1, '商品A', 1000, '2019-07-24 07:07:07');"
	}
}
```



# 11-04. テーブルからのデータ取得

### ◇ 実装例で用いた略号

**C**：column（列）

**R**：record（行）

**T**：table





### ◇ SQLの処理の順番

```
from ⇒ where ⇒ group by ⇒ having ⇒ select ⇒ order by
```



### ◇ select

- **in**

【IN句を使用しなかった場合】

```
SELECT * FROM fruit WHERE name = "みかん" OR name = "りんご";
```

【IN句を使用した場合】

```
SELECT * FROM fruit WHERE name IN("みかん","りんご");
```





### ◇ 内部結合と外部結合

基本情報技術者試験では、内部結合（A∩B）しか出題されない。

- **内部結合に```where```を用いる場合**

```
select C,  #『カラム』を指定
	from T1, T2, T3  #複数の表を指定
	where R1 = R2 and  #指定したカラムのうち、レコードと別の表のレコードを照合し、フィールドを取得
	R2 = R3  #3つ目の表のレコードとも照合
```

- **内部結合に```inner join on```を用いる場合（本試験では出題されない）**

```
select C,  #『カラム』を指定
	from T1  #複数の表を指定
	inner join T2
		on T1.C1 = T2.C2  #2つ目の表の『レコード』と照合
	inner join T3
    	on T1.C1 = T3.C3  #3つ目の表の『レコード』と照合
```

- **ベン図で内部結合と外部結合を理解しよう**

![内部結合のベン図](C:\Projects\Summary_Notes\まとめノート\画像\内部結合のベン図.jpg)



### ◇ 集合関数まとめ

- **sum()**

```
select sum(C)  #指定したカラムで、『フィールド』の合計を取得
	from T
```

- **avg()**

```
select avg(C)  #指定したカラムで、『フィールド』の平均値を取得
	from T
```

- **min()**

```
select min(C)  #指定したカラムで、『フィールド』の最小値を取得
	from T
```

- **max()**

```
select max(C)  #指定したカラムで、『フィールド』の最大値を取得
	from T
```

- **count()**

```
select count(C)  #指定したカラムで、『フィールド』の個数を取得
	from T
```

**※消去法の小技：集合関数を入れ子状にはできない**

```
select avg(sum(C))  #集合関数を集合関数の中に入れ子状にすることはできない。
	from T
```

```
select count(*)  #指定したカラムで、値無しも含む『フィールド』を取得
	from T
```

```
select count(C)  #指定したカラムで、値無しを除いた『フィールド』を取得

select count(all C)  #上に同じ
```

```
select count(distinct C)  #指定したカラムで、重複した『フィールド』を除く全ての『フィールド』を取得
```



### ◇ group by

**※消去法の小技：```group by``` のカラム引数は、```select```のカラムと同じでなければならない**

```
select C
	from T
	group by C  #指定したカラムで、各グループのフィールドを集計
```



### ◇ having

```group by```で集計した結果から、```having```で『フィールド』を取得。

```
select C
	from T
	group by C  
	having count(*) >=2  #集計値が２以上の『フィールド』を取得
```

※以下の場合、```group by + having```を使っても、```where```を使っても、同じ出力結果になる。

```
select C
	from T
	group by C
	having R 
```

```
select C
	from T
	where R
	group by C
```



### ◇ sub-query

掛け算と同様に、括弧内から先に処理を行う。

```
select * from T  #Main-query
	where C != (select max(C) from T)  #Sub-query
```



### ◇ in と any

- **in**

  指定した値と同じ『フィールド』を取得

```
select * from T
	where C in (xxx, xxx, ...)  #指定したカラムで、指定した値の『フィールド』を取得
```

```
select * from T
	where C not in (R1, R2, ...)  #指定したカラムで、指定した値以外の『フィールド』を取得
```

```
select * from T
	where C not in ( #フィールドを指定の値として用いるｚ
		select C from T where R >= 160)  #指定したカラムで、『フィールド』を取得
```

- **any**

  書き方が異なるだけで、```in```と同じ出力

```
select * from T
	where C = any(xxx, xxx, xxx)
```



### ◇ view

ビューとはある表の特定のカラムや指定した条件に合致するレコードなどを取り出した仮想の表。また、複数の表を結合したビューを作成できる。ビューを作成することによりユーザに必要最小限のカラムやレコードのみにアクセスさせる事ができ、また結合条件を指定しなくても既に結合された表にアクセスできる。
⇒よくわからん…

```
create view T as
	select * from ...
```



### ◇ wildcard

```
select * from T
	where C like '%営業'  #任意の文字（文字無しも含まれる）
```

```
select * from T
	where C like '_営業'  #任意の一文字
```



### ◇ between

```
select * from T
	between 1 and 10  #指定したカラムで、1以上10以下の『フィールド』を取得
```



# 11-05. 取得したデータ

### ◇ fetch

DBで取得したデータをプログラムに一度に全て送信してしまうと、プログラム側のメモリを圧迫してしまう。そこで、fetchで少しずつ取得する。

**【実装例】**

```getConnection()```を起点として、返り値から繰り返しメソッドを取得し、```fetchAll()```で、テーブルのクエリ名をキーとした連想配列が返される。

```
getConnection()->executeQuery($query, $params, $types, $qcp)->fetchAll()

/// 結果
Array　= (
　　[kbn_name] => レッド 
　　[kbn_value] => 2
　　[quantity] => 50
)
```

