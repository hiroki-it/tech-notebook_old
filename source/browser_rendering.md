# ブラウザレンダリング

## 01. マークアップ言語によるWebページの構成

### マークアップ言語の歴史

Webページをテキストによって構成するための言語をマークアップ言語という．1970年，IBMが，タグによって，テキスト文章に構造や意味を持たせるGML言語を発表した．

![マークアップ言語の歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マークアップ言語の歴史.png)



### XMLのツリー構造化と構造解析

XML形式テキストファイルはタグを用いて記述されている．最初に出現するルート要素は根（ルート），またすべての要素や属性は，そこから延びる枝葉として意味づけられる．

**【XMLのツリー構造化の例】**

![DOMの構造](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB

#### ・スキーマ言語

  XML形式テキストファイルにおいて，タグの付け方は自由である．しかし，利用者間で共通のルールを設けた方が良い．ルールを定義するための言語をスキーマ言語という．スキーマ言語に，DTD：Document Type Definition（文書型定義）がある．

**【DTDの実装例】**

```dtd
<!DOCTYPE Employee[
    <!ELEMENT Name (First, Last)>
    <!ELEMENT First (#PCDATA)>
    <!ELEMENT Last (#PCDATA)>
    <!ELEMENT Email (#PCDATA)>
    <!ELEMENT Organization (Name, Address, Country)>
    <!ELEMENT Name (#PCDATA)>
    <!ELEMENT Address (#PCDATA)>
    <!ELEMENT Country (#PCDATA)>
]>
```

#### ・ツリー構造の解析

DOMによる解析の場合，プロセッサはXMLを構文解析し，メモリ上にDOMツリーを展開する．一方で，SAXによる解析の場合，DOMのようにメモリ上にツリーを構築することなく，先頭から順にXMLを読み込み，要素の開始や要素の終わりといったイベントを生成し，その都度アプリケーションに通知する．

![DTDとDOM](https://user-images.githubusercontent.com/42175286/59777367-83f19f00-92ef-11e9-82e5-6ebcd59f4cba.gif)



### HTMLのツリー構造化と構造解析




## 02. Loading

### Loadingの仕組み

#### ・Intersection Observer

交差率の閾値を「```0.5```」と設定すると，ターゲットエレメントの交差率が「```0.5```」を超えた時点で，テンプレートの要素の読み込みが行われる．

![IntersectionObserverとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/IntersectionObserverとは.png)

#### ・メリット

ページの読み込みに無駄がなくなるため，読み込みが早く感じる．

#### ・ダミー画像

最初，dummy画像へのパスが出力されているが，遅延読み込みが実行されると，このパスがsrcで上書きされる．



## 03. Scripting

### scriptタグ

#### ・htmlに直接組み込む場合

```html
<script>
document.write("JavaScriptを直接組み込んでいます。")
</script>
```

#### ・別ファイルとして分割し，読み込む場合

```html
<script src="sample.js" charset="utf-8"></script>
```

## 04. Redering

## 05. Painting



