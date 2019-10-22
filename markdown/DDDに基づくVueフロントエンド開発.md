# 01. 処理の流れの全体像

一例として、処理フローは、『(Vuex) ⇄ (AJAX )⇄ (DDD) ⇄  (DB) 』で実装される。

![Vuex と DDD-1](https://user-images.githubusercontent.com/42175286/58743936-d7519980-8475-11e9-83b2-0d10505206b9.png)

![Vuex と DDD-2](https://user-images.githubusercontent.com/42175286/58744171-a1aeaf80-8479-11e9-9844-f9beb6f13327.png)



# 02. Vue

### ◆ Vuexにおけるページ更新サイクル

![Vuex](https://user-images.githubusercontent.com/42175286/58393072-ef8d7700-8077-11e9-9633-d137b8e36077.png)

- **Dispach**

1. ユーザーのアクションによって、Vue Componentから、Vuexで定義したActionを呼び出す。
2. まずDispatchされたActionは、APIにリクエストを投げる。そしてサーバーサイド側で定義したロジックによって何らかの処理が実行される。ここで注意するポイントは、「Actionは、必ず非同期処理 」

- **Commit**
   サーバー側で返却されたデータ（基本的にはJSONでリターンする）をMutationへ渡す。

- **Mutate**
  MutationがStateを変更。ここで注意するポイントは、「Mutationは、必ず同期処理 」。

- **Render**

   MutateされたStateを、Vue Component側に描画。

   

引用：【Vuex】ざっくり理解、Vuexって何？VuexとAPIの関係を図解してみた，https://qiita.com/MatakiTanaka09/items/8cdccf54164f782ad2e8

```javascript
const Vuex = require('vuex')

module.exports = new Vuex.Store({

	// 初期stateに値を設定しておく。
	state: {    
		exArray: [],
	},

	// 引数で渡したexArrayの要素を、初期stateのexArrayの要素として格納する。
	// 矢印はアロー関数を表し、無名関数の即時実行を省略することができる。
	mutation: {
		mutate(state, exArray) {
			exArray.forEach(
				(element) => { state.exArray.push(element); }
				// アロー関数を用いなければ、以下のように記述できる。
				// function(element) { state.exArray.push(element); }
			);  
		},
	},
	
	// 
	getters: {
			exArray(state) {
				return state.exArray;
			},
			
	},
```



### ◆ Vue.js

**【実装例】**

```javascript
new Vue({

    //htmlファイルと連携
    el: '#app',

    //どんなデータがあるか
    data: {
        xxxData:
    },

    //取得データをキャッシュしたいようなメソッドを定義（大量のデータを取得するメソッドなど）
    computed: {

    },

    //取得データをキャッシュしたくないようなメソッドを定義
    methods: {
        xxxFunction: function(){
        }
    }
});
```



# 03-01. Web API

### ◆ Web APIの概念

![API](https://user-images.githubusercontent.com/42175286/58460636-04960300-8169-11e9-8fa0-18a307f3425b.png)

> In computer programming, an application programming interface (API) is a set of subroutine definitions, communication protocols, and tools for building software. In general terms, it is a set of clearly defined methods of communication among various components.

> コンピュータプログラミングでは、アプリケーションプログラミングインターフェイス（API）は、サブルーティン定義、通信プロトコル、ソフトウェアを構築するための一連の方法。 一般的に、様々なコンポーネント間で明確に定義された一連の通信方法のことを言う。

**【具体例】**

- **Ajaxに含まれるXMLHttpRequestとDOM**

```javascript

```

- **JSON API**

```javascript
    /**
     * @var \DateTime
     * 
     * #マッピングするテーブルを指定
     * @ORM\Column(name="date", type="datetime")
     *
     * #Expose()でJSON形式に変換することを宣言
     * @JSON\Expose()
     *
     * #JSONに出力するときのフォーマット
     * @JSON\Type("DateTime<'Y-m-d'>")
     */
    private $date;
```



### ◆ AJAXを用いたAPI

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

AJAX（Asynchronous JavaScript + XML）は、以下の４つから構成される。

- **JavaScript**： 

- **XML HttpRequest**
  オブジェクト形式で書かれ、ブラウザとサーバー間を繋ぐAPI。
  
- **DOM**
  xmlやhtmlをツリー構造で表現することによって、ブラウザとサーバー間を繋ぐAPI。
  
- **XML**

  

1. ページ上で任意のイベントが発生（ボタンクリックなど）
1. JavaScriptとXMLHttpRequestでサーバーに対して、ルーティングを基にコントローラにリクエストを送信
1. サーバーで受け取った情報を処理。サーバーの処理中もクライアントは操作を継続可能（これぞ非同期通信）。
1. コントローラは処理結果をJSONやXMLなどの形式でレスポンスを送信。
1. レスポンスを受けて、DOMでページを更新。

**【実装例】**

```javascript
  static find(criteria, b, c) {
    
    //jQueryのAJAXメソッド発動
    return $.ajax({
      type:        'GET', #HTTPリクエストとしてGETメソッドを指定
      url:         '/xxx/xxx', #コントローラを指定
      contentType: 'application/json',
      dataType:    'json', #リクエストにJSON形式を指定
      data: (() => {
        const query = {
          criteria: criteria,
          b: b,
          c: c,
        };

        // 検索条件を設定
        if (criteria.id) {
          query.id = criteria.id;
        }

        return query;
      })(),
    })
      .then((data) => {
        return {
　　　　　　dataの配列
        };
      });
  }
```



### ◆ Object ⇄ JSON の変換

![serialization vs deserialization](https://user-images.githubusercontent.com/42175286/58675481-79e31d00-838f-11e9-972d-d4a5d5ed6a55.png)

**【実装例】**

```javascript
#【Object】
{foo: [1, 4, 7, 10], bar: "baz"}
```

⇓ ⇑

```javascript
#【JSON】
'{"foo":[1,4,7,10],"bar":"baz"}'
```



# 03-02. スキーマ言語と構造解析

### ◆ XML Schema と DTD（Document Type Definition）によるツリー構造定義

XML文書は、ツリー構造で書かれている。最初に出現するルート要素は根（ルート）であると考えられ、すべての要素や属性は、そこから延びる枝葉として考えられる。ツリー構造を定義するための言語はスキーマ言語と呼ばれる。

（例）DTDによってツリー構造を定義されたXML

![DOMの構造](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB



### ◆ DOM（Document Object Model）と SAXによる構造解析

XMLデータを操作するためのAPI。DOMの場合、プロセッサはXMLを構文解析し、メモリ上にDOMツリーを展開する。一方のSAXの場合、DOMのようにメモリ上にツリーを構築することなく、先頭から順にXMLを読み込み、要素の開始や要素の終わりといったイベントを生成し、その都度アプリケーションに通知する。

![DTDとDOM](https://user-images.githubusercontent.com/42175286/59777367-83f19f00-92ef-11e9-82e5-6ebcd59f4cba.gif)

引用：＠IT，https://www.atmarkit.co.jp/ait/articles/0208/20/news002.html
