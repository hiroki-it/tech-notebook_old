# ブラウザレンダリングの仕組み

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

#### ・インラインスクリプト

JavaScriptファイルを直接組み込む方法．

```html
<script>
document.write("JavaScriptを直接組み込んでいます。")
</script>
```

#### ・外部スクリプト

外部JavaScriptファイルを組み込む方法．

```html
<script src="sample.js"></script>
```

#### ・scriptタグが複数ある場合

一つのページのHtml内で，scriptタグが複数に分散していても，Scriptingプロセスでは，一つにまとめて実行される．そのため，より上部のscriptタグの処理は，より下部のscriptに引き継がれる．

1．例えば，以下のソースコードがある．

```html
localNum<p>見出し１</p>

<script>
var globalNum = 10;
</script>

<p>見出し２</p>

<script>
globalNum = globalNum * 10;
</script>

<p>見出し３</p>

<script>
document.write("<p>結果は" + globalNum + "です</p>");
var hoge = true；
</script>

<script src="sample.js"></script>
```

```javascript
// sample.js
// 無名関数の即時実行．定義と呼び出しを同時に行う．
(function () {
    
    // 外側の変数（hoge）を参照できる．
    if(hoge) {
      console.log('外部ファイルを読み込みました');
    }
    
    var localNum = 20;
    function localMethod() {
        // 外側の変数（localNum）を参照できる．
        console.log('localNum');
    }
    
    // 定義したメソッドを実行
    localMethod();
}());
```

2. 実行時には以下の様に，まとめて実行される．ここでは，htmlファイルで定義した関数の外にある変数は，グローバル変数になっている．一つのページを構成するHtmlを別ファイルとして分割していても，同じである．

```html
<script>
var globalNum = 10;
    
localNum = localNum * 10;
    
document.write("<p>結果は" + num + "です</p>");
var hoge = true;

// 無名関数の即時実行．定義と呼び出しを同時に行う．
(function () {
    
    // 外側の変数（hoge）を参照できる．
    if(hoge) {
      console.log('外部ファイルを読み込みました');
    }
    
    var localNum = 20;
    function localMethod() {
        // 外側の変数（localNum）を参照できる．
        console.log('localNum');
    }
    
    // 定義したメソッドを実行
    localMethod();
}());
</script>
```



## 01-04. イベント発火とイベントハンドラ関数

### イベント発火，イベントハンドラ関数とは

画面上で何かの処理が起こると，Scriptingプロセスによって，特定の関数がコールされる．



### HTML形式ファイル上でイベントハンドラ関数をコールする記述方法

#### ・```onload```

「画面のローディング」というイベントが発火すると，イベントハンドラ関数をコールする．

#### ・```onclick```

「要素のクリック」というイベントが発火すると，イベントハンドラ関数をコールする．

```html
<input type="button" value="ボタン1" onclick="methodA()">

<script>
function methodA(){
	console.log("イベントが発火しました");
}
</script>
```



### JSファイル上でイベントハンドラ関数をコールする記述方法


#### ・```document.getElementById()```

指定したIDに対して，一つのイベントと一つのイベントハンドラ関数を紐づける．

```javascript
// 指定したIDで，クリックイベントが発火した時に，処理を行う．
document.getElementById('btn').onclick = function(){
	console.log("イベントが発火しました");
}
```


#### ・```document.addEventListener()```

一つのイベントに対して，一つ以上のイベントハンドラ関数を紐づける．```false```を設定することで，イベントバブリングを行わせない．

```javascript
// DOMContentLoadedイベントが発火した時に，処理を行う．
document.addEventListener('DOMContentLoaded', function(){
	console.log("イベントが発火しました");
});
```

```javascript
// 一つ目
document.getElementById('btn').addEventListener('click', function(){
	console.log("イベントが発火しました（１）");
}, false);

// 二つ目
document.getElementById('btn').addEventListener('click', function(){
	console.log("イベントが発火しました（２）");
}, false);
```



## 02. Loadingプロセス

### Loadingプロセスとは

サーバサイドからHtml，CSS，画像ファイルが，バイト形式でレスポンスされ，これを読み込む．Downloading処理とParse処理の二つの段階に分けられる．



## 02-02. Downloading処理

### Pre-Loading

#### ・Pre-Loadingとは

指定したテキストファイルを，

```html
<head>
  <meta charset="utf-8">
  <title>Title</title>
  <link rel="preload" href="style.css" as="style">
  <link rel="preload" href="main.js" as="script">
  <link rel="stylesheet" href="style.css">
</head>

<body>
  <h1>Hello World</h1>
  <script src="main.js" defer></script>
</body>
```



### Lazy Loading（遅延読み込み）

#### ・Lazy Loadingとは

#### ・Intersection Observer

交差率の閾値を「```0.5```」と設定すると，ターゲットエレメントの交差率が「```0.5```」を超えた時点で，テンプレートの要素の読み込みが行われる．

![IntersectionObserverとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/IntersectionObserverとは.png)

#### ・メリット

ページの読み込みに無駄がなくなるため，読み込みが早く感じる．

#### ・ダミー画像

最初，dummy画像へのパスが出力されているが，遅延読み込みが実行されると，このパスがsrcで上書きされる．

### Eager Loading

#### ・Eager Loadingとは



## 02-03. Parse処理


### HTML形式テキストファイルの構造解析

#### ・構造解析の流れ

1. Downloading処理で読みこまれたバイト形式ファイルは，文字コードに基づいて，一連の文字列に変換される．ここでは，以下のHTML形式ファイルとCSS形式ファイル（```style.css```）に変換されたとする．

```html
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
    <div style="width: 50%">
      <div style="width: 50%">Hello world!</div>
    </div>
  </body>
</html>
```

```css
/* style.css */
body { font-size: 16px }
p { font-weight: bold }
span { color: red }
p span { display: none }
img { float: right }
```


2. 一連の文字列からHTMLタグが認識され，トークンに変換される．
3. 各トークンは，一つのオブジェクトに変換される．

![DOMツリーが生成されるまで](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DOMツリーが生成されるまで.png)

4. HTMLパーサーは，オブジェクトをノードとして，DOMツリーを生成する．DOMのインターフェースについては，こちら．

   https://developer.mozilla.org/ja/docs/Web/API/Document_Object_Model

![DOMツリー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DOMツリー.png)

5. CSSパーサーは，オブジェクトをノードとして，CSSOMツリーを生成する．

![CSSOMツリー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CSSOMツリー.png)




### XML形式テキストファイルの構造解析

#### ・構造解析の流れ

レンダリングエンジンは，最初に出現するルート要素を根（ルート），またすべての要素や属性を，そこから延びる枝葉として意味づけ，レンダリングツリーを生成する．

**【ツリー構造の例】**

![DOMによるツリー構造化](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB



## 03. Scriptingプロセス

### Scriptingプロセスとは

JavaScriptエンジンによって，JavaScriptコードが機械語に翻訳されるプロセス．このプロセスは，初回アクセス時だけでなく，イベントが発火した時にも実行される．

### JavaScriptエンジン

#### ・JavaScriptエンジンとは

JavaScriptのインタプリタのこと．JavaScriptエンジンは，レンダリングエンジンからHtmlに組み込まれたJavaScriptコードを受け取る．JavaScriptエンジンは，これを機械語に翻訳し，ハードウェアに対して，命令を実行する．

![JavascriptEngine](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/JavascriptEngine.png)

#### ・JavaScriptエンジンによる機械語翻訳

JavaScriptエンジンは，ソースコードを，字句解析，構造解析，意味解釈，命令の実行，をコード一行ずつに対し，繰り返し行う．詳しくは，ソフトウェアのノートを参照せよ．

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)




## 04. Renderingプロセス

### Renderingプロセスとは

レンダリングツリーが生成され，ブラウザ上のどこに何を描画するのかを計算するプロセス．CalculateStyle処理とLayout処理に分けられる．



## 04-02. CalculateStyle処理

レンダリングエンジンは，DOMツリーのルートのノードから順にCSSOSツリーを適用し，Renderツリーを生成する．

![Renderツリー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Renderツリー.png)



## 04-03. Layout処理

上記で読み込まれたHTML形式テキストファイルには，ネストされた 2 つの div がある．1 つ目（親）の```div```より，ノードの表示サイズをビューポートの幅の 50% に設定し、この親に含まれている 2 つ目（子）の```div```より，その幅を親の50%、つまりビューポートの幅の25%になるようにレイアウトされる．

![Layout処理](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Layout処理.png)



## 05. Paintingプロセス

### Paintingプロセスとは

DOMツリーの各ノードを，ブラウザ上に描画する．



## 05-02. Paint処理

## 05-03. Rasterize処理

## 04-04. CompositeLayers処理


