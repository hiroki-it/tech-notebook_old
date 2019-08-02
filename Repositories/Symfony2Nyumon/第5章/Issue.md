## 【第３章復習】Setter vs. Getter
![Getter vs Setter](https://user-images.githubusercontent.com/42175286/56820181-2d835980-6886-11e9-9178-37661d9bbdf8.jpg)
引用リンク：KAB-studio，http://www.kab-studio.biz/Programing/OOPinJava/03/05.html

## 【第３章復習】Symfonyのディレクトリ構成

```
Symfony
├── app #設定や画面テンプレートを格納し、基本的にPHPのコードは格納しない
│   ├── Resources
│   │   └── views (1)　# 画面テンプレートを格納
│   └── config　# 設定ファイルを格納（カーネルのためのルート定義ファイル等）
│
├── bin　# コマンドラインツールを格納
│
├── src　# 自分が作成するソースコードを格納
│   ├── AppBundle　(a) # アプリケーションのソースコードを格納
│   │  ├── Controller　# コントローラ（ページの種類に合わせたルーティング、テンプレートのレンダリング）を格納
│   │  ├── Entity #エンティティを格納
│   │  ├── Repository #レポジトリを格納
│   │  ├── Form #フォーム
│   │  └── Resources
│   │       └── views  (2) #画面テンプレートを格納 
│   │           
│   └── その他のBundle  (b) #汎用的なライブラリのソースコードを格納
│   
├── test #自動テスト（Unit tests等）
│  
├── var #自動生成されるファイル（cache、logs等）
│
├── vendor (c)  #composerでインストールしたパッケージを格納（Doctrine等）　
│
└── web #ドキュメントルート（css, javascript, image等）
```

## 【第３章復習】Webシステムの仕組みの全体像
![図2-9](https://user-images.githubusercontent.com/42175286/55077357-e2392800-50da-11e9-8ef4-18556d0263ff.png)

## phpMyAdminの事前準備
以下のファイルに、ユーザ名とパスワード入力すること
- ```comfig.inc.php```
- ```parameters.yml```
- ```parameters.yml.dist```

## ORM：Object-Relational Mapping（オブジェクト関係マッピング）
### **◇ ORMとは**
オブジェクトとデータベースのレコードを関連付けるプログラミング技法のこと。

### **◇ PHPで使われているORMの種類**
- Doctrine
- Propel
- PHPDAO
- php activerecord
- idiorm

### **◇ Doctrineのマッピングの形式**
![表5-1](https://user-images.githubusercontent.com/42175286/56472012-51185f80-6494-11e9-97af-7f6f52352b17.png)

### **◇ レコード、フィールド、カラムとは**
![レコードとは](https://user-images.githubusercontent.com/42175286/56479245-55259b00-64ef-11e9-82a6-6c5f932898f0.JPG)
引用リンク：プロメモ，https://26gram.com/database-terms

### **◇ PHP、Doctrine、データベースの関係の概要**
（１）PHPがDoctrineを呼び出す
（２）DoctrineはSQLクエリをデータベースに送信
（３）データベースがレコードをORMに返信
（４）DoctrineはPHPにオブジェクトを返信
![Symfony4_図4-2](https://user-images.githubusercontent.com/42175286/56432685-47aebc00-6309-11e9-9606-d8d2d8286940.png)

### **◇ Doctrineに含まれているデータベースの操作に必要なクラス**
![Doctrineに含まれるファイル](https://user-images.githubusercontent.com/42175286/56889760-43756200-6ab2-11e9-9cbb-bfe808e76bb6.png)

### **◇ エンティティの仕組み**
ORMは、データベースから取り出されたレコードをエンティティのインスタンスに変換する。
![Symfony4_図4-9](https://user-images.githubusercontent.com/42175286/56432412-3618e480-6308-11e9-9d7d-734747f8184e.png)

## データベースへの情報登録の方法
### **（１）Entityクラスの作成**
```php bin/console doctrine:generate:entity```
![表5-2](https://user-images.githubusercontent.com/42175286/56472639-deab7d80-649b-11e9-8f2b-606a082630b1.png)

### **（２）Entityクラスを基に、MySQLにデータベースを作成**
```php bin/console doctrine:schema:create```
![表5-3](https://user-images.githubusercontent.com/42175286/56472563-f20a1900-649a-11e9-9efa-ce99ee7aa8b1.png)

### **（３）レコードを作成**
```persisit()```：レコードの作成と保存
```flush()```：変更された情報をデータベースに反映
![図5-4](https://user-images.githubusercontent.com/42175286/56473243-31d4fe80-64a3-11e9-9517-efc0222abb68.png)

### **（３）マイグレーション**

### **（４）コントローラとテンプレートの作成**

## データベースからのレコード取得
![図5-7](https://user-images.githubusercontent.com/42175286/56513694-39ada500-656e-11e9-8f97-3d56a92fe42d.png)