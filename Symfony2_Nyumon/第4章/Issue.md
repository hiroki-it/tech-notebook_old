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

## ```include()``` vs ```render()``` 
### **◇ ```include()```**：
サイドバーは各ページのコントローラに含まれ、各ページと一緒にレンダリングされる
![図4-1](https://user-images.githubusercontent.com/42175286/55272313-29533300-52fe-11e9-82e5-b4da27e2fcc0.png)

### **◇ ```render()```**：
サイドバーのみで独立したコントローラが存在し、各ページで部分的にレンダリングされる。
![図4-2](https://user-images.githubusercontent.com/42175286/55272315-2f491400-52fe-11e9-8835-f9245af46889.png)

## テンプレート継承とブロック
レイアウトテンプレート（親テンプレート）に共通部分と非共通部分（ブロック区画）を配置し、ページテンプレート（子テンプレート）に共通部分のみを継承
![図4-3](https://user-images.githubusercontent.com/42175286/55272332-67505700-52fe-11e9-9342-17dc572b8265.png)

## フォームの作成
Symfonyにおいて、フォームはオブジェクトであり、コントローラ／アクションで定義されてテンプレートに渡される。
![図4-7](https://user-images.githubusercontent.com/42175286/55290858-855bab80-5413-11e9-8641-9d0eb6d67b30.png)

フォームの一例
![公式ウェブ 図1-3](https://user-images.githubusercontent.com/42175286/55345721-9677eb80-54eb-11e9-9fe4-fab9745be93d.png)

### **◇ ```in-place```で構築する方法**
（１）```createFormBuilder()```オブジェクトを取得
（２）```indexAction()```に、フォーム構築用のコートを記述
（３）```form()```関数によるフォームの簡易表示／フォームフィールドを個別に表示

### **◇ フォームタイプで構築する方法**
（１）テーブルと連動するメンバー、セッター、ゲッターを含むエンティティを作成
（２）エンティティと紐づくフォームタイプを作成
（３）コントローラを作成
（４）```form()```関数によるフォームの簡易表示／フォームフィールドを個別に表示

### **◇ add()で設定できるフォームの項目の種類**
![フォーム項目の種類-1](https://user-images.githubusercontent.com/42175286/56892670-4de82980-6abb-11e9-8671-53a26af3359b.png)
![フォーム項目の種類-2](https://user-images.githubusercontent.com/42175286/56892673-517bb080-6abb-11e9-99f4-28db0e4829e6.png)

## Symfonyからの通知メールの設定

### **◇ SMTP vs POP3**
SMTP（Simple Mail Transfer Protocol）：メールを他のサーバーへ送信する仕組みのこと
POP3（Post Office Protocol）：サーバーからメールを受信する仕組みのこと
![メールサーバーの仕組み](https://user-images.githubusercontent.com/42175286/55679369-8de94000-5945-11e9-9e88-9c5c468f3249.gif)
引用リンク：NANISAMA.COM，http://www.nanisama.com/about_Mail/mail-server/index.html

### **◇ 送信方式の設定**
```%mailer_transport%```とすることによって、パラメータファイルにおける```mailer_transport:```を参照し、通知メールの送信方式を設定することが可能。
![表4-2](https://user-images.githubusercontent.com/42175286/55679535-22ed3880-5948-11e9-9a6b-81ca76ee33aa.png)

### **◇ メール送信処理の実装**
（１）Swift Mailerクラスを用いて、メールに関する情報（送信するメッセージの本文、送信先アドレス、件名など）のオブジェクトを作成
（２）メソッドチェーンで件名や送信元を順に指定
（３）テンプレートファイル名とフォーム入力値が格納された```$data```変数を引数に指定して、コントローラの```renderView()```メソッドを呼び出す
（４）サービスコンテナからmailerサービスを取得し、```send()```にメールメッセージを渡す