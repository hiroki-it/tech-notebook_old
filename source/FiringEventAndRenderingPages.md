# イベント発火とページレンダリング

## 01-01. イベント発火からWebページ表示までの流れ

### :pushpin: JavaScript，JSON型データ，PHP，マークアップ言語の連携

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

1. ページ上で任意のイベントが発火する．（ページング操作，フォーム入力など）
2. JQueryの```ajax()```が，クエリストリングを生成し，また，リクエストによって指定ルートにJSON型データを送信する．
3. コントローラは，JSON型データを受信し，またそれを元にDBからオブジェクトをReadする．
4. コントローラは，PHPのオブジェクトをJSON型データに変換し，レスポンスによって送信する．
5. JQueryの```ajax()```が，JSON型データを受信する．
6. JSON型データが，解析（パース）によってJavaScriptのオブジェクトに変換される．
7. オブジェクトがマークアップ言語に出力される．
8. DOMを用いて，マークアップ言語を解析し，Webページを構成する．



### :pushpin: SPA：シングルページアプリケーション

#### ・非同期通信に基づくSPAとは

1つのWebページの中で，サーバとデータを非同期的に通信し，レンダリングすることができるアプリケーションのこと．Vueでは，SPAの仕組みが用いられている．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/SPアプリにおけるデータ通信の仕組み.png)

#### ・従来WebアプリとSPアプリの処理速度の違い

サーバとデータを非同期的に通信できるため，1つのWebページの中で必要なデータだけを通信すればよく，レンダリングが速い．

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/従来WebアプリとSPアプリの処理速度の違い.png)



## 02-01. Vueフレームワークによるイベントの発火

### :pushpin: コンポーネントの登録

#### ・グローバル登録

```javascript
Vue.component('v-example-component',{
    template: require('./xxx/xxx/xxx')
});

new Vue({
    el: '#apv
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



### :pushpin: MVVMパターン

#### ・MVVMパターンとは

Viewが『Twig＋親コンポーネント（```.html```）』，ViewModelが『Vueインスタンス（```.js```）＋子コンポーネント（```.vue```）』，Modelが『クラス（```.js```）』に相当する．

![MVVMパターン](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/MVVMパターン.png)

#### ・双方向データバインディング（Props Down, Events Up）

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Vueコンポーネントツリーにおけるコンポーネント間の通信.png)

Viewの親コンポーネント（出力先のコンポーネントタグ）では，ViewModelの子コンポーネント（出力内容）がタグ名でコールされる．親側Viewと子側ViewModelのコンポーネント間の対応付けをデータバインディング（Props Down, Events Up），またデータの双方向の受け渡しを双方向データバインディングという．

#### ・1. 親からのProps Down（```.html```）

親コンポーネントのタグ内で設定された『```:example = "値"```』が，子コンポーネントの『```props: { "値" }```』に渡される．この値は読み込み専用で，変更できない．

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
#### ・2. Vueインスタンスによる親子間のバインディング（```.js```）

各コンポーネントで個別に状態を変化させたいものは，propsオプションではなく，dataオプションとして扱う．

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
        // dataオプション
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

    
        // methodオプション
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
                // JSON型データをajax()に渡し，サーバからのレスポンスによって受信したデータを返却．
                 return Staff.find(query)
                // Ajaxによって返却されたJSON型データが自動的にdone()の引数になる．
                // リクエストされたデータをdataオプションのプロパティに格納するメソッド．
                .done((data) => {
                // ReadしたJSON型データをJavaScriptのオブジェクトにシリアライズする．
                // dataオプションのプロパティに格納する．
                this.staffData = _.map(data.staffData, Staff.parse);
                })
            }

                
        // watchオプション
        // Vueインスタンス内の値の変化を監視する関数を定義する．
        watch: {
      
        }
})
```
#### ・3. 子からのEvents Up，孫へのProps Down（```.vue```）

ボタンをクリックした時，子コンポーネントの『```$emit("イベント名", "値")```』によって，親コンポーネントの『```v-on: イベント名　=　"値" ```』が発火し，値が渡される．値に応じたコンポーネント部分の変化が起こる．また同時に，子コンポーネントのタグ内で設定された『```:example = "値"```』が，孫コンポーネントの『```props: { "値" }```』に渡される．各コンポーネントで個別に状態を変化させたいものは，propsオプションではなく，dataオプションとして扱う．

```vue
<!-- v-example-component-1の子コンポーネント -->
<!-- 子コンポーネントとして使用するためのtemplateタグ -->
<!-- ここに，出力したいHTMLやTWIGを記述する． -->
<template>

    <!-- 孫コンポーネントを記述 -->
    <v-example-component-4
     :aaa="a"
     :bbb="b"
    ></v-example-component-4>  

    <!-- 特定の条件の時のみ出力する孫コンポーネント -->
    <!-- 値はpropsオプションから参照される -->
    <template v-if="example.isOk()">
        <v-example-component-5
         :ccc="c"
         :ddd="d"                          
        ></v-example-component-5>  
    </template>

</template>


<!-- 子コンポーネントのオプションを設定 -->
<script>
module.exports = {
      
      
    // 『HTMLでのコンポーネントのタグ名：　JSでのコンポーネントのオブジェクト名』
    component: {

        // 子コンポーネントと孫コンポーネントの対応関係
        'v-example-component-4': require('./xxx/xxx/xxx-4'),
        'v-example-component-5': require('./xxx/xxx/xxx-5'),
    },
      

    // 親コンポーネントまたはAjaxからpropsオブジェクトのプロパティに値が格納される．
    props: {
        'criteria': {
            type: Object,
            required: true,
        },
        
        'example':{
            type Object,
            required:true,
        }
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
            
        // Ajaxから送信されてきたデータを用いて，propsを更新 
        updateFuneral (key, value) {
            
        }    
    },

}
</script>
```

#### ・4. モデルへのデータ送信（```.js```）

サーバサイドからのデータ受信については，Ajaxの```.done()```の説明を参照せよ．

```javascript
class Example {
    
    // コンポーネントからデータを受信．
    // プロパティの宣言と，同時に格納．
    constructor(properties) {
        this.isOk = properties.isOk;
        ...
    }
    
    // コンストラクタによって宣言されているので，アクセスできる．
    isOk() {
        // bool値を返却するとする．
        return this.isOk;
    }
}
```



## 02-02. Vueにおけるディレクティブ

### :pushpin: リアクティブディレクティブ

#### ・属性データバインディング

#### ・入力データバインディング

#### ・スタイルバインディング

#### ・クラスバインディング

#### ・イベントハンドリング

v-on: {イベント名}="{Vueインスタンスのメソッド}"（```@:```でも可）で記述する．```$emit()```でイベント名を指定されることによって，Vueインスタンス内の特定のメソッドを発火させる．

#### ・条件付きレンダリング

```v-if```あるいは```v-show```で，```v-xxx="{propsのプロパティ名}"```で記述する．親テンプレートから渡された```props```内のプロパティ名がもつ値が```TRUE```の時に表示し，```FALSE```の時に非表示にする．もし頻繁に表示と非表示の切り替えを行うようなら，```v-if```の方が，描画コストが重たくなるリスクが高くなる為，```v-show```推奨である．




### :pushpin: リテラルディレクティブ



### :pushpin: エンプティディレクティブ



## 02-03. Vue-Routerライブラリによるルーティング

### :pushpin: Vue-Routerとは

![ルーティングコンポーネント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ルーティングコンポーネント.png)

ルーティングモジュールの一つ．JQueryRouter，React-Routerに相当する．コンポーネントに対してルーティングを行い，```/{ルート}/パラメータ}```に応じて，コールするコンポーネントを動的に切り替えることができる．

```
http://www.example.co.jp:80/{ルート}/{パスパラメータ}?text1=a&text2=b
```

**【実装例】**

```javascript
// Vue-Routerライブラリを読み込む．
const vueRouter = require('vue-router').default;

// VueRouterインスタンスを作成する．
const router = new VueRouter({
    // ここに，コンポーネントを記述する． 
})

// 外部ファイルが，VueRouterインスタンスを読み込めるようにしておく．
module.exports = router;
```



## 02-04. Vuexライブラリによるデータの状態管理

### :pushpin: Vuexとは

![VueコンポーネントツリーとVuexの関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VueコンポーネントツリーとVuexの関係.png)

Vuejsでライブラリの一つ．双方向データバインディングでは，親子コンポーネント間でしか，データを受け渡しできない．しかし，Vuexストア内で，データの状態を保持することによって，親子関係なく，データを一元的に受け渡しできるようになる．



### :pushpin: Vuexストア内のデータの状態管理の仕組み

![Vuex](https://user-images.githubusercontent.com/42175286/58393072-ef8d7700-8077-11e9-9633-d137b8e36077.png)

#### ・Dispach

1. ユーザーのアクションによって，Vue Componentから，Vuexで定義したActionを呼び出す．
2. まずDispatchされたActionは，APIにリクエストを投げる．そしてサーバーサイド側で定義したロジックによって何らかの処理が実行される．ここで注意するポイントは，「Actionは，必ず非同期処理 」

#### ・Commit

  サーバー側からレスポンスされたデータ（基本的にはJSON形式データでリターンする）をMutationへ渡す．

#### ・Mutate

  MutationがStateを変更．ここで注意するポイントは，「Mutationは，必ず同期処理 」．

#### ・Render

   MutateされたStateを，Vue Component側に描画．



### :pushpin: ```Vuex.Store()```によるVuexストアの実装

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



## 03-01. Ajaxによる非同期的なデータ送受信

### :pushpin: JQueryの```ajax()```を用いたAjaxの実装

コンポーネントごとにリクエストメッセージを送る必要があるので，```ajax()```には，メソッド，URL，ヘッダー，ボディを設定する項目がある．リクエストメッセージの構造については，ネットワークのノートを参照せよ．

#### ・GET送信の場合

![GET送信時のHTTPリクエスト](https://user-images.githubusercontent.com/42175286/58061886-0ed95f80-7bb3-11e9-8998-f105a5e0ed40.png)

**【実装例】**

```ajax()```で，GET送信でリクエストするデータから，クエリパラメータを生成する．

```javascript
// ここに実装例
```

```{キー名}={値}```が，```&```で結合され，クエリパラメータとなる．

```
# ...の部分には，データ型を表す記号などが含まれる．
http://127.0.0.1/.../?fruit...=ばなな&fruit...=りんご&account...=200
```

#### ・POST送信の場合

![POST送信時のHTTPリクエスト](https://user-images.githubusercontent.com/42175286/58061918-29abd400-7bb3-11e9-94d0-fd528901ba7c.png)

**【実装例】**

このようなJavaScriptのオブジェクトが送信されてきたとする．

```javascript
const query = {
    criteria: {
    id: 777,
    name: "hiroki"
    }
}
```

リクエストメッセージをサーバサイド に送信し，またレスポンスを受信する．

**【実装例】**

```javascript
static find(query) {

    return $.ajax({
        //--- リクエストメッセージ ---//
        // メソッドとURL
        type: 'POST', // メソッドを指定
        url: '/xxx/xxx', // ルートとパスパラメータを指定
        // ヘッダー
        contentType: 'application/json',　// 送信するデータの形式を指定
        // ボディ
        data: query, // クエリパラメータとして送信するデータを指定
            
        //--- レスポンスメッセージ ---//
        dataType: 'json', // 受信するデータの形式を指定
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
```



## 04-01. JSON型データの解析（パース）

### :pushpin: シリアライズ，デシリアライズ

#### ・シリアライズ，デシリアライズとは

クライアントサイドとサーバサイドの間で，JSON型オブジェクトデータを送受信できるように解析（パース）することを，シリアライズまたはデシリアライズという．

![シリアライズとデシリアライズ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/シリアライズとデシリアライズ.png)

**【実装例】**

サーバサイドでReadされたJSON型データを，JavaScriptのオブジェクトにデシリアライズ．

```javascript
class Shain {
  
    //-- シリアライズ（JavaScriptからJSONへ） --//
    static createQuery(criteria) {
        
        // JavaScript上でのJSON型変数の定義方法
        const query = {}
      
        // ID
        if (criteria.id) {
          query.id = _.trim(criteria.id);
        }
        // 氏名
        if (criteria.name) {
          query.name = _.trim(criteria.name);
        }
    }
  
    //-- デシリアライズ（JSONからJavaScriptへ） --//
    static parse(data) {
       return new Shain({
            id: data.id,
            name: data.name
       });
    }
  
}     
```

#### 1. JavaScriptによるオブジェクト

**【実装例】**

```javascript
// クラス宣言．
class Example {
    fruit: ["ばなな", "りんご"];
    account: 200;
}

// 外部ファイルから読み込めるようにする．  
module.exports = Example;  
```

#### 2. JSON型のオブジェクト

**【実装例】**

```json
// 一番外側を波括弧で囲う．
{
  "Example": {
    "fruit": ["ばなな", "りんご"],
    "account": 200
  }
}
```

#### 3. PHPによるオブジェクト

**【実装例】**

```PHP
class Example
{
    private $fruit;
    
    private $account;
}    
```



### :pushpin: Jsonのクエリ言語

#### ・JMESPath

**【実装例】**

```javascript
// ここに実装例
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



## 05-01. マークアップ言語によるWebページの構成

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

