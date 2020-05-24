# ブラウザレンダリング

## 01. ブラウザレンダリングの仕組み

### 構成するプロセス

Loading，Scripting，Rendering，Painting，の4つのプロセスからなる．クライアントの操作のたびにイベントが発火し，Scriptingプロセスが繰り返し実行される．

![BrowserRenderingプロセス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/BrowserRenderingプロセス.png)



## 01-02. マークアップ言語

#### ・マークアップ言語とは

ハードウェアが読み込むファイルには，バイナリファイルとテキストファイルがある．このうち，テキストファイルをタグとデータによって構造的に表現し，ハードウェアが読み込める状態する言語のこと．

#### ・マークアップ言語の歴史

Webページをテキストによって構成するための言語をマークアップ言語という．1970年，IBMが，タグによって，テキスト文章に構造や意味を持たせるGML言語を発表した．

![マークアップ言語の歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マークアップ言語の歴史.png)



### XML形式：Extensible Markup Language

#### ・XML形式とは

テキストファイルのうち，何らかのデータの構造を表現することに特化している．

#### ・スキーマ言語とは

マークアップ言語の特にXML形式において，タグの付け方は自由である．しかし，利用者間で共通のルールを設けた方が良い．ルールを定義するための言語をスキーマ言語という．スキーマ言語に，DTD：Document Type Definition（文書型定義）がある．

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



### HTML形式：HyperText Markup Language

#### ・HTML形式とは

テキストファイルのうち，Webページの構造を表現することに特化している．



## 01-03. JavaScript

### マークアップ言語へのJavaScriptの組み込み

#### ・直接組み込む場合

```html
<script>
document.write("JavaScriptを直接組み込んでいます。")
</script>
```

#### ・外部ファイルを組み込む場合

```html
<script src="sample.js" charset="utf-8"></script>
```



## 



## 02. Loadingプロセス

### Loadingプロセスとは

#### ・役割



## 02-02. Downloading処理

### Pre-Loading

#### ・Pre-Loadingとは

指定したテキストファイルを，

```html
<head>
  <meta charset="utf-8">
  <title>JS and CSS preload example</title>

  <link rel="preload" href="style.css" as="style">
  <link rel="preload" href="main.js" as="script">

  <link rel="stylesheet" href="style.css">
</head>

<body>
  <h1>bouncing balls</h1>
  <canvas></canvas>

  <script src="main.js" defer></script>
</body>
```



### Lazy Loading（遅延読み込み）

#### ・Lazy Loadingとは

#### ・Intersection Observerとは

交差率の閾値を「```0.5```」と設定すると，ターゲットエレメントの交差率が「```0.5```」を超えた時点で，テンプレートの要素の読み込みが行われる．

![IntersectionObserverとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/IntersectionObserverとは.png)

#### ・メリット

ページの読み込みに無駄がなくなるため，読み込みが早く感じる．

#### ・ダミー画像

最初，dummy画像へのパスが出力されているが，遅延読み込みが実行されると，このパスがsrcで上書きされる．

### Eager Loading

#### ・Eager Loadingとは



## 02-03. Parse処理


### HTMLパーサーによるHTML形式テキストファイルの構造解析

#### ・構造解析の流れ

1. 例えば，以下のようなHtml形式のテキストファイルが，Downloading処理によってダウンロードされているとする．

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>タイトル</title>
</head>
<body>
<p>Hello World</p>
<script src=".example.js"></script>
</body>
</html>
```

2. HTMLパーサーは，Html形式テキストファイルの構造解析を行い，DOMのインターフェースに基づくDOMツリーを生成する．

![HtmlDOMツリー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/HtmlDOMツリー.png)

3. レンダリングエンジンは，DOMツリーを基に，レンダリングツリーを生成する．対応関係については，以降の記述を参照せよ．

![レンダリングツリー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/レンダリングツリー.png)

#### ・DOMツリーのインターフェースとタグの対応関係

| 上位インターフェース |      | 下位インターフェース |      | レンダリングツリーのノード |
| :------------------: | :--: | :------------------: | :--: | :------------------------: |
|       Document       |  →   |     HTMLDocument     |  →   |          document          |
|     HTMLElement      |  →   |   HTMLHtmlElement    |  →   |            html            |
|     HTMLElement      |  →   |   HTMLHeadElement    |  →   |            head            |
|     HTMLElement      |  →   |   HTMLMetaElement    |  →   |            meta            |
|     HTMLElement      |  →   |   HTMLTitleElement   |  →   |           title            |
|     HTMLElement      |  →   |   HTMLBodyElement    |  →   |            body            |
|     HTMLElement      |  →   | HTMLParagraphElement |  →   |             p              |
|     HTMLElement      |  →   |  HTMLScriptElement   |  →   |           script           |



### XML形式テキストファイルの構造解析

#### ・構造解析の流れ

レンダリングエンジンは，最初に出現するルート要素を根（ルート），またすべての要素や属性を，そこから延びる枝葉として意味づけ，レンダリングツリーを生成する．

**【ツリー構造の例】**

![DOMによるツリー構造化](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB



## 03. Scriptingプロセス

### Scriptingプロセスとは

#### ・役割

JavaScriptエンジンによって，JavaScriptコードが機械語に翻訳される．このプロセスは，初回アクセス時だけでなく，イベントが発火した時にも実行される．

### JavaScriptエンジン

#### ・JavaScriptエンジンとは

JavaScriptのインタプリタのこと．JavaScriptエンジンは，レンダリングエンジンからHtmlに組み込まれたJavaScriptコードを受け取る．JavaScriptエンジンは，これを機械語に翻訳し，ハードウェアに対して，命令を実行する．

![JavascriptEngine](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/JavascriptEngine.png)

#### ・JavaScriptエンジンによる機械語翻訳

JavaScriptエンジンは，ソースコードを，字句解析，構造解析，意味解釈，命令の実行，をコード一行ずつに対し，繰り返し行う．詳しくは，ソフトウェアのノートを参照せよ．

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)




## 04. Renderingプロセス

### Renderingプロセスとは

#### ・役割

## 04-02. CalculateStyle処理

## 04-03. Layout処理




## 05. Paintingプロセス

### Paintingプロセスとは

#### ・役割

## 05-02. Paint処理

## 05-03. Rasterize処理

## 04-04. CompositeLayers処理


