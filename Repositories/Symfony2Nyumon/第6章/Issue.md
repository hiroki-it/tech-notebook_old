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

## 問い合わせフォームのバリデーション
### **◇ バリデーションの種類**
![サポートされている制約](https://user-images.githubusercontent.com/42175286/56891700-4d9a5f00-6ab8-11e9-9c1f-b3385bf65943.png)
![サポートされている制約-2](https://user-images.githubusercontent.com/42175286/56891729-6dca1e00-6ab8-11e9-8751-e529b0a4d534.png)

### **◇ バリデーショングループ**
ユーザの種類によってバリデーションを使い分けるために、バリデーションをグループ化。
![表6-3](https://user-images.githubusercontent.com/42175286/56899749-3450dd00-6acf-11e9-9037-309ac3a37d0b.png)

## システム上での文字の扱い方
### **◇ 符号化文字集合**
英語のアルファベットや日本語のひらがな、カタカナ等、どのような文字が使えるかを示した文字リストのこと。
（例）Unicode
![文字集合](https://user-images.githubusercontent.com/42175286/56846533-5f8acf00-690b-11e9-8bda-f1e463c6916b.png)
引用リンク：ウナのIT資格一問一答，http://una.soragoto.net/topics/9.html

### **◇ 文字符号化方式**
任意の文字集合をどのようなビット列に変換（=**エンコード**）するかを定義した体系のこと。
（例）UTF-8 vs. UTF-16
![文字コード](https://user-images.githubusercontent.com/42175286/56846274-6fed7a80-6908-11e9-9a42-e149b4485608.png)
引用リンク：$shibayu36->blog;，https://blog.shibayu36.org/entry/2015/09/14/102100

### **◇ 『符号化文字集合』と『文字符号化方式』の対応関係（文字コード体系）一覧**
（余談）Winのメモ帳での文字コードの選択ダイアログでは、 符号化文字集合と文字符号化方式の違いに混乱する言葉遣いをしている。
![文字集合と符号化方式の対応関係](https://user-images.githubusercontent.com/42175286/56847046-57359280-6911-11e9-97f3-8c270326d49f.png)
引用リンク：se-ikeda，http://se-ikeda.jp/techmemo/215

## べーシック認証
### **◇ ベーシック認証とは？**
サイトへのアクセス時に、ユーザ名とパスワードを求める認証方法のこと。
![べーシック認証](https://user-images.githubusercontent.com/42175286/56851608-08f1b500-694c-11e9-91bb-db260400248b.jpg)
他の認証方法として、例えばOAuth（Open Authorization）認証がある。
![OAuth認証とAPIトークン](https://user-images.githubusercontent.com/42175286/56865017-166a7600-6a04-11e9-8f45-121a5c03760c.jpg)
引用リンク：@IT，https://www.atmarkit.co.jp/fsmart/articles/oauth2/02.html

### **◇ 文字符号化方式を設定**

### **◇ プロバイダを設定**

### **◇ ファイアウォールを設定（ vs ウェブアプリケーションファイアウォール）**
![ファイアウォール vs ウェブアプリケーションファイアウォール](https://user-images.githubusercontent.com/42175286/56851401-be6f3900-6949-11e9-8023-b7f46aa13009.png)