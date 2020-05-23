# ブラウザレンダリング

## 01. マークアップ言語

### マークアップ言語の特徴

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



## 02. Loading



### 遅延ローディング

#### ・Intersection Observer

交差率の閾値を「```0.5```」と設定すると，ターゲットエレメントの交差率が「```0.5```」を超えた時点で，テンプレートの要素の読み込みが行われる．

![IntersectionObserverとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/IntersectionObserverとは.png)

#### ・メリット

ページの読み込みに無駄がなくなるため，読み込みが早く感じる．

#### ・ダミー画像

最初，dummy画像へのパスが出力されているが，遅延読み込みが実行されると，このパスがsrcで上書きされる．



## 03. Scripting

### Scriptingとは

#### ・役割

レンダリングエンジンが，Htmlに組み込まれたJavaScriptを，インタプリタのJavaScriptエンジンに渡す．JavaScriptエンジンは，これを機械語に翻訳する．

#### ・JavaScriptエンジンの機械語翻訳の流れ

JavaScriptエンジンは，ソースコードを，字句解析，構造解析，意味解釈，命令の実行，をコード一行ずつに対し，繰り返し行う．詳しくは，ソフトウェアのノートを参照せよ．

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/字句解析，構文解析，意味解析，最適化.png)


### マークアップ言語の構造解析

![DTDとDOM](https://user-images.githubusercontent.com/42175286/59777367-83f19f00-92ef-11e9-82e5-6ebcd59f4cba.gif)

#### ・DOM

DOMによる構造解析の場合，プロセッサはXMLを基に，メモリ上にツリーを生成する．

#### ・SAX

SAXによる構造解析の場合，DOMのようにメモリ上にツリーを生成することなく，先頭から順にXMLを読み込み，要素の開始や要素の終わりといったイベントを生成し，その都度アプリケーションに通知する．

#### ・XML形式の構造解析

XML形式はタグを用いて記述されている．DOMは，最初に出現するルート要素を根（ルート），またすべての要素や属性を，そこから延びる枝葉として意味づける．

**【ツリー構造の例】**

![DOMによるツリー構造化](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB



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

## 04. Redering

## 05. Painting



