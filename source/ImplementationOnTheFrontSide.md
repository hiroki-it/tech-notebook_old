# イベント発火 〜 Webページ表示

## 01-01. イベント発火からWebページ表示までの流れ

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

1. ページ上で任意のイベントが発火する．（ページング操作，フォーム入力など）
2. JQueryの```ajax()```が，クエリストリングを生成し，また，リクエストによって指定ルートにJSON型データを送信する．
3. コントローラは，JSON型データを受信し，またそれを元にDBからオブジェクトをReadする．
4. コントローラは，PHPのオブジェクトをJSON型データに変換し，レスポンスによって送信する．
5. JQueryの```ajax()```が，JSON型データを受信する．
6. JSON型データが，解析（パース）によってJavaScriptのオブジェクトに変換される．
7. オブジェクトがマークアップ言語に出力される．
8. DOMを用いて，マークアップ言語を解析し，Webページを構成する．



## 02-01. Vueフレームワークによるイベントの発火

### :pushpin: SPA：シングルページアプリケーション

Vueでは，SPAの仕組みが用いられている．

#### ・SPアプリにおけるデータ通信の仕組み

Webページの部分ごとに，サーバとデータ通信できる．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/SPアプリにおけるデータ通信の仕組み.png)

#### ・従来WebアプリとSPアプリの処理速度の違い

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/従来WebアプリとSPアプリの処理速度の違い.png)



### :pushpin: コンポーネントの登録

#### ・グローバル登録

```javascript
Vue.component('v-example-component',{
    template: require('./xxx/xxx/xxx')
});

new Vue({
    el: '#app'
})
```

#### ・ローカル登録

```javascript
var vExampleComponent = {
    // 親コンポーネントと子コンポーネントの対応関係
    template: require('./xxx/xxx/xxx'),
};

new Vue({

    el: '#app',
  
    components: {
        // 親コンポーネントにオブジェクト名をつける．
        'v-example-component': vExampleComponent
    }
  
})
```

ただし，コンポーネントのオブジェクト名の定義は，以下のように省略することができる．

```javascript
new Vue({

    el: '#app',
  
    components: {
        // 親コンポーネントと子コンポーネントの対応関係
        'v-example-component': require('./xxx/xxx/xxx'),
    }
  
})
```



### :pushpin: 双方向データバインディング

#### ・MVVMパターン

Viewが『Twig＋親コンポーネント』，ViewModelが『Vueインスタンス＋子コンポーネントのVueファイル』，Modelが『クラスが定義されたJSファイル』に相当する．

![MVVMパターン](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/MVVMパターン.png)

#### ・双方向データバインディングの仕組み

Viewの親コンポーネント（出力先のコンポーネントタグ）では，ViewModelの子コンポーネント（出力内容）がタグ名でコールされる．ViewとViewModelのコンポーネント間での，データの双方向の受け渡しを双方向データバインディングという．

1. 親コンポーネントのタグ内で設定された『```:example = "値"```』が，子コンポーネントの『```props: { "値" }```』に渡される．この値は読み込み専用で，変更できない．
2. 各コンポーネントで個別に状態を変化させたいものは，propsオプションではなく，dataオプションとして扱う．
3. ボタンをクリックした時，子コンポーネントの『```$emit("イベント名", "値")```』によって，親コンポーネントの『```v-on: イベント名　=　"値" ```』が発火し，値が渡される．値に応じたコンポーネント部分の変化が起こる．

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Vueコンポーネントツリーにおけるコンポーネント間の通信.png)

**【実装例】**

#### ・親コンポーネント

```html
<!-- 全てのコンポーネントを紐づけるidをもつdivタグで囲む -->
<div id="app">
  
    <!-- 親コンポーネント（出力先のコンポーネントタグ）を記述 -->
  <!-- propsに渡すための値を設定．ディレクティブのメソッドの引数に影響する-->
    <!-- 対応するVueインスタンスのmethodオプションをディレクティブに設定-->
    <v-example-component-1
        :criteria="criteria"
        v-on change="changeQuery"
  ></v-example-component-1>

    <!-- 親コンポーネント（出力先のコンポーネントタグ）を記述 -->
    <v-example-component-2
                         
    ></v-example-component-2>

    <!-- 親コンポーネント（出力先のコンポーネントタグ）を記述 -->
    <v-example-component-3
                         
    ></v-example-component-3>
  
</div>
```
#### ・Vueインスタンス

```javascript
// 一つのHTMLあるいはTWIGファイルに対応するVueインスタンスを生成
new Vue({

    //　データの受け渡しを行うHTML（TWIG）のIDを，『#ID名』で設定する．
    el: '#app',

    // 『HTMLでのコンポーネントのタグ名：　JSでのコンポーネントのオブジェクト名』
    component: {

        // 親コンポーネントと子コンポーネントの対応関係．
        // 子コンポーネントごとに異なるファイルを用意する．
        'v-example-component-1': require('./xxx/xxx/xxx-1'),
        'v-example-component-2': require('./xxx/xxx/xxx-2'),
        'v-example-component-3': require('./xxx/xxx/xxx-3')
        },

        // 状態を変化させたいデータを，関数として定義しておき，初期状態を設定する．
        // 異なる場所にある同じコンポーネントは異なるVueインスタンスからなり，異なる値をもつ必要があるため，dataオプションはメソッドとして定義する．
        data: function() {
            return {
                // プロパティ名: 値
                isLoaded: false,
                staffData: [],
                criteria: {
                    id: null,
                    name: null
                    },
                };
        },

        // dataオプションの状態を変化させ，親コンポーネントでコールされるメソッドを定義する．
        // メソッドは部品化されており，全てのメソッドが合わさって上記の条件に合致する．
        method: {
            changeQuery(criteriaObj) {
        
                // 値無しプロパティを持つkeysオブジェクトを定義する．
                const keys = [
                    'criteria',
                    'limit',
                ];
        
                // プロパティ名を取り出す．
                for (const key of keys) {
          
                    // criteriaObjのプロパティの値を，上記のkeysオブジェクトに格納する．
                    if (key in criteriaObj) {
            
                        // ここでのthisはメソッド内のkeysオブジェクトを指す．
                        this[key] = criteriaObj[key];
                }
            }
        
        
            
            load(query) {
          
                // ここでのthisはdataオプションを指す．
                this.isLoaded = true;
                this.staffData = [];
        
                // JSON型データをajax()に渡し，サーバからのレスポンスによって受信したデータを返却する．
                return Staff.find(query)
        
                    // Ajaxによって返却されたJSON型データが自動的にdone()の引数になる．
                    // リクエストされたデータをdataオプションのプロパティに格納するメソッド．
                    .done((data) => {
          
                    // ReadしたJSON型データをJavaScriptのオブジェクトにシリアライズする．
                    // dataオプションのプロパティに格納する．
                    this.staffData = _.map(data.staffData, Staff.parse);
          
                    })
        }

        // Vueインスタンス内の値の変化を監視する関数を定義する．
        watch: {
      
        }
})
```
#### ・子コンポーネント

```javascript
<!-- v-example-component-1の子コンポーネント -->
<!-- 子コンポーネントとして使用するためのtemplateタグ -->
<!-- ここに，出力したいHTMLやTWIGを記述する． -->
<template>

<!-- 孫コンポーネント（出力先のコンポーネントタグ）を記述 -->
<v-example-component-4
                       
></v-example-component-4>  

</template>


<!-- 子コンポーネントのオプションを設定 -->
<script>
module.exports = {
      
      
    // 『HTMLでのコンポーネントのタグ名：　JSでのコンポーネントのオブジェクト名』
    component: {

        // 子コンポーネントと孫コンポーネントの対応関係
        'v-example-component-4': require('./xxx/xxx/xxx-4'),
    },
      

    // 親コンポーネントからpropsオブジェクトのプロパティに，criteriaの値が格納される．
    props: {
        'criteria': {
            type: Object,
            required: true
        },
    },
      

    // 状態を変化させたいデータを関数として定義しておき，初期状態を格納する．
    data: function() {
        return {
        
        };
    },
      
      
    // 任意の関数を定義する．
    method: {
        updateCriteria (key, value) {
              
        // 親コンポーネント（v-example-component-1）と紐づく処理
        // changeイベントを発火させ，イベントに紐づくchangeQuery()の引数として値を渡す．
        this.$emit('change', {'criteria': localCriteria});
    },

}
</script>
```



### :pushpin: ディレクティブ

#### ・```v-on: イベント名="Vueインスタンスのメソッド"```（```@:```でも可）

```$emit()```でイベント名を指定されることによって，Vueインスタンス内の特定のメソッドを発火させる．

#### ・```v-show="プロパティ名"```

```props```内のプロパティ名がもつ値が```TRUE```の時に表示し，```FALSE```の時に非表示にする．



## 02-02. Vue-Routerライブラリ

### :pushpin: コンポーネントのルーティング

Vueのライブラリの一つで，コンポーネントとルートをマッピングさせる．指定したルートからレスポンスが行われた時に，特定のコンポーネントが動作するように設定することができる．

**【実装例】**

```javascript
// Vue-Routerライブラリを読み込む．
const vueRouter = require('vue-router').default;

// VueRouterインスタンスを作成する．
const router = new VueRouter({
    // ここに，パスとコンポーネント名の対応を記述する．
    // 書き方は要勉強．     
})

// 外部ファイルが，VueRouterインスタンスを読み込めるようにしておく．
module.exports = router;
```



## 02-03. Vuexライブラリ

### :pushpin: ページの状態管理の仕組み

Vuejsでライブラリの一つで，ページの状態管理を行うことができる．

![Vuex](https://user-images.githubusercontent.com/42175286/58393072-ef8d7700-8077-11e9-9633-d137b8e36077.png)

#### ・Dispach

1. ユーザーのアクションによって，Vue Componentから，Vuexで定義したActionを呼び出す．
2. まずDispatchされたActionは，APIにリクエストを投げる．そしてサーバーサイド側で定義したロジックによって何らかの処理が実行される．ここで注意するポイントは，「Actionは，必ず非同期処理 」

#### ・Commit

  サーバー側からレスポンスされたデータ（基本的にはJSONでリターンする）をMutationへ渡す．

#### ・Mutate

  MutationがStateを変更．ここで注意するポイントは，「Mutationは，必ず同期処理 」．

#### ・Render

   MutateされたStateを，Vue Component側に描画．



### :pushpin: ```Store```における状態管理の実装

Vuexライブラリを経由してリクエストとレスポンスを行うことで，より効率的にページの状態管理が行える．

![VueコンポーネントツリーとVuexの関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VueコンポーネントツリーとVuexの関係.png)

Vuexによる状態管理は，```Store```で実装していく．

**【実装例】**

```javascript
// Vuex store
// 基本的に，一つのコンポーネントに対応するStoreは一つのみとする．
// Vuexライブラリを読み込む．
const vuex = require('vuex')


// 外部ファイルが，このStoreインスタンスを読み込めるようにする．
module.exports = new Vuex.Store({

  // Stateには多くを設定せず，Vueインスタンスのdataオプションに設定しておく．
    // 初期stateに値を設定しておく．
    state: {    
        staffData: [],
    },

    
    // 引数で渡したexArrayの要素を，初期stateのexArrayの要素として格納する．
    // 矢印はアロー関数を表し，無名関数の即コールを省略することができる．
    mutation: {
        
        mutate(state, staffData) {
            exArray.forEach(
                
                // アロー関数を用いなければ，以下のように記述できる．
                // function(element) { state.exArray.push(element); }
                // 引数で渡されたexArrayの要素を，stateのexArrayに格納する．
                (element) => { state.exArray.push(element); }
            );  
        },
        
    },
    
    // ここに，複数のコンポーネントで共通してコールしたいcomputedをまとめて定義しておく．
    getters: {
        
            staffData(state) {
                return state.staffData;
            },
            
    },
    
    actions: {
        
    },
});  
```

```javascript
// Vueコンポーネントツリー
// Storeを読み込む．
const store = require('./_store')

// Storeに定義されているgetters，mutation，actionsをローカルにマッピングできるように読み込む．
const mapGetters = require('vuex').mapGetters;
const mapActions = require('vuex').mapActions;
const mapMutaions = require('vuex').mapMutaions;

new Vue({
  
    el: '#app',
  
    store,

  // Readされたデータをキャッシュしたいようなメソッドを定義する．
    computed: {

        // mapGettersヘルパー．
        // StoreのGetterをローカルのcomputedにマッピングし，コール可能にする．
        ...mapGetters([
        'x-Function'
        ])

    },

  // Readされたデータをキャッシュしたくないようなメソッドを定義する．
    methods: {

        // mapMutationsヘルパー
        ...mapMutations([
        'y-Function'
        ]),

        // mapActionsヘルパー
        ...mapActions([
        'z-Function'
        ]),
    }
});
```



## 03-01. Ajaxによる非同期通信

### :pushpin: JQueryの```ajax()```を用いたAjaxの実装

**【実装例】**

```javascript
// HTMLあるいはTWIGから，このようなオブジェクトが送信されてきたとする．
const query = {
    criteria: {
    id: 777,
    name: "hiroki"
    }
}
```
```javascript
// クラス宣言によって定義されたオブジェクトは，個別ファイルで管理しておくのがベター．
class Staff {
  
  
  // コンストラクタ
  constructor(property) {
    this.id = property.id;
    this.name = property.name;
  }  

  
    // 自分自身をJSON型データでサーバサイドからReadするメソッド
    static find(query) {

        return $.ajax({
      
      // HTTPリクエストのメソッドとしてPOSTを指定
            type: 'POST',
      
      // リクエスト先のファイルのパスを指定
            url: '/xxx/xxx',
      
      // リクエストによって送信するデータはJSON形式を指定
            contentType: 'application/json',
      
      // レスポンスによって受信するデータはJSON形式を指定
            dataType: 'json',
      
      // リクエストによって送信するデータを指定
            data: query,
        })
    
        // ajax()の処理が成功した場合に起こる処理．
        .done((data) => {
      
        })
    
        // ajax()の処理が失敗した場合に起こる処理．
        .fail(() => {
            toastr.error('', 'エラーが発生しました．');
        })
    
        // ajax()の成功失敗に関わらず，必ず起こる処理．
        .always(() => {
            this.isLoaded = false;
        });
  }    

  
    // ReadされたJSON型データをJavaScriptのオブジェクトにシリアライズする．
    static parse(data) {
        return new Shain({
        
        // コンストラクタに渡される．
        id: data.id,
        name: data.name
        });
    }                       
}

// 外部ファイルから読み込めるように設定しておく．  
module.exports = Staff;  
```



### :pushpin: GET送信におけるHTTPリクエスト

#### ・クエリストリングによるデータの送信**

GET送信ではデータからクエリストリングが生成され，HTTPリクエストが『```ルート + ? + クエリストリング```』の形で送られる．URLに情報が記述されるため，履歴でデータの内容を確認できてしまう危険がある．

```
http://127.0.0.1/example.php + ? + クエリストリング
```

#### ・クエリストリングの生成**

**【実装例】**

```javascript
// JavaScriptによるオブジェクトの表現．
// クラス宣言．
class Example {
  fruit: ["ばなな", "りんご"];
  account: 200;
}
```

⬇︎

```
// 『ルート + ? + クエリストリング』のクエリストリングに相当する部分．
// ...の部分には，データ型を表す記号などが含まれる．
http://127.0.0.1/example.php + ? + fruit...=ばなな&fruit...=りんご&account...=200
```



## 04-01. JSON型データの解析（パース）

### :pushpin: シリアライズとデシリアライズ

クライアントサイドとサーバサイドの間で，JSON型オブジェクトデータを送受信できるように解析（パース）することを，シリアライズまたはデシリアライズという．

![シリアライズとデシリアライズ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/シリアライズとデシリアライズ.png)

**【実装例】**

```javascript
// JavaScriptでのオブジェクトの表現．
// クラス宣言．
class Example {
    fruit: ["ばなな", "りんご"];
    account: 200;
}
```

⬇︎⬆︎

```json
// JSON型データの表現．
// 一番外側を波括弧で囲う．
{
  "Example": {
    "fruit": ["ばなな", "りんご"],
    "account": 200
  }
}
```

⬇︎⬆︎

```PHP
// PHPでのオブジェクトの表現．
class Example
{
    private $fruit;
    
    private $account;
}    
```



### :pushpin: Jsonのクエリ言語

#### ・JMESPath

```

```



### :pushpin: データ記述言語の種類

#### ・JSON：JavaScript Object Notation

一番外側を波括弧で囲う．

```json
{
  "Example": {
    "fruit": ["ばなな", "りんご"],
    "account": 200
  }
}
```

#### ・YAML：YAML Ain't a Markup Language

```yaml
{
  Example:
    fruit:
      - "ばなな"
      - "りんご"
    account: 200
}  
```

#### ・マークアップ言語

マークアップ言語の章を参照せよ．

#### ・CSV：Comma Separated Vector

データ解析の入力ファイルとしてよく使うやつ．



## 05-01. Webページの構成

### :pushpin: マークアップ言語の歴史

Webページをテキストによって構成するための言語をマークアップ言語という．1970年，IBMが，タグによって，テキスト文章に構造や意味を持たせるGML言語を発表した．

![マークアップ言語の歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マークアップ言語の歴史.png)



### :pushpin: XMLのツリー構造化と構造解析

XML形式テキストファイルはタグを用いて記述されている．最初に出現するルート要素は根（ルート），またすべての要素や属性は，そこから延びる枝葉として意味づけられる．

**【XMLのツリー構造化の例】**

![DOMの構造](https://user-images.githubusercontent.com/42175286/59778015-a59f5600-92f0-11e9-9158-36cc937876fb.png)

引用：Real-time Generalization of Geodata in the WEB，https://www.researchgate.net/publication/228930844_Real-time_Generalization_of_Geodata_in_the_WEB

#### ・スキーマ言語

  XML形式テキストファイルにおいて，タグの付け方は自由である．しかし，利用者間で共通のルールを設けた方が良い．ルールを定義するための言語をスキーマ言語という．スキーマ言語に，DTD：Document Type Definition（文書型定義）がある．

**【DTDの実装例】**

```dtd
<!DOCTYPE Enployee[
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



### :pushpin: HTMLのツリー構造化と構造解析

