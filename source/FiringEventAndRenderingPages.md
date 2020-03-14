# イベント発火とページレンダリング

## 01-01. イベント発火からWebページ表示までの流れ

### :pushpin: JavaScript，JSON型データ，PHP，マークアップ言語の連携

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

1. ページ上で任意のイベントが発火する．（ページング操作，フォーム入力など）
2. イベント
3. JQueryの```ajax()```が，クエリストリングを生成し，また，リクエストによって指定ルートにJSON型データを送信する．
4. コントローラは，JSON型データを受信し，またそれを元にDBからオブジェクトをReadする．
5. コントローラは，PHPのオブジェクトをJSON型データに変換し，レスポンスによって送信する．
6. JQueryの```ajax()```が，JSON型データを受信する．
7. JSON型データが，解析（パース）によってJavaScriptのオブジェクトに変換される．
8. オブジェクトがマークアップ言語に出力される．
9. DOMを用いて，マークアップ言語を解析し，Webページを構成する．



### :pushpin: SPA：シングルページアプリケーション

#### ・非同期通信に基づくSPAとは

1つのWebページの中で，サーバとデータを非同期的に通信し，レンダリングすることができるアプリケーションのこと．Vueでは，SPAの仕組みが用いられている．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/SPアプリにおけるデータ通信の仕組み.png)

#### ・従来WebアプリとSPアプリの処理速度の違い

サーバとデータを非同期的に通信できるため，1つのWebページの中で必要なデータだけを通信すればよく，レンダリングが速い．

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/従来WebアプリとSPアプリの処理速度の違い.png)



## 02-01. Vueを用いたMVVMアーキテクチャ

### :pushpin: MVVMアーキテクチャ

#### ・一般的なMVVMアーキテクチャとは

View層とModel層の間にViewModel層を置き，View層とViewModel層の間でデータをやり取りすることによって，View層とModel層の間を疎結合にするための設計手法の一つ．

![一般的なMVVMアーキテクチャ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/一般的なMVVMアーキテクチャ.png)

#### ・Vueを用いたMVVMアーキテクチャとは

Vueは，アプリケーションの設計にMVVMアーキテクチャを用いることを前提として，MVVMアーキテクチャを実現できるような機能を提供する．View層には親コンポーネント（```xxx.html```，```/xxx.twig```）を，ViewModel層には子コンポーネント（```xxx-component.vue```）を，Model層にはVuex（```store.js```)やJavaScriptからなるモデル（```xxx.js```）を設置する．

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VueにおけるMVVMアーキテクチャ.png)



### :pushpin: データバインディングとは

#### ・親子コンポーネント間の双方向データバインディングとは

View層の親コンポーネント（```xxx.html```，```xxx.twig```）と，ViewModel層の子コンポーネント（```xxx-component.vue```）の間では，一方のデータが更新されると，もう一方のデータが渡されて自動的にデータが更新される．これを双方向データバインディングといい，```props```と```$emit()```を用いることで実現することができる．

![親子コンポーネント間の双方向データバインディング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/親子コンポーネント間の双方向データバインディング.png)

#### ・Props Down, Events Upとは

双方向データバインディングは，『Props Down, Events Up』の処理によって実現される．

1. View層の親コンポーネントのデータが更新されると，ViewModel層の子コンポーネントの```props```を自動的に更新する．（Props Down）
2. 反対に，ViewModel層の子コンポーネントのデータが更新されると，```$emit()```をコールし，親コンポーネントのデータを自動的に更新する．（Events Up）

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Vueコンポーネントツリーにおけるコンポーネント間の通信.png)



### :pushpin: ViewModel層におけるコンポーネントの登録方法

#### ・グローバル登録

**【実装例】**

```javascript
Vue.component('v-example-component',{
    template: require('./xxx/xxx/xxx')
});

new Vue({
    el: '#app
})
```

#### ・ローカル登録

**【実装例】**

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

**【実装例】**

```javascript
new Vue({

    el: '#app',
  
    components: {
        // 親コンポーネントと子コンポーネントの対応関係
        'v-example-component': require('./xxx/xxx/xxx'),
    }
  
})
```



### :pushpin: MVVMアーキテクチャの実装例

#### ・1. View層での親コンポーネント（```xxx.html```，```xxx.twig```）

親コンポーネントのタグ内で設定された『```:example = "値"```』が，子コンポーネントの『```props: { "値" }```』に渡される．この値は読み込み専用で，変更できない．

**【実装例】**

```html
<!-- 全てのコンポーネントを紐づけるidをもつdivタグで囲む -->
<div id="app">
  
    <!-- 
    親コンポーネント（出力先のコンポーネントタグ）を記述
    propsに渡すための値を設定．ディレクティブのメソッドの引数に影響する
    対応するVueインスタンスのmethodオプションをディレクティブに設定
    -->
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
#### ・2. ViewModel層でのVue初期化と親子間のバインディング（```index.js```）

VueとVue-Routerの初期化や，親子コンポーネント間のバインディングを行う．各コンポーネントで個別に状態を変化させたいものは，propsオプションではなく，dataオプションとして扱う．

**【実装例】**

```javascript
// 一つのHTMLあるいはTWIGファイルに対応するVueインスタンスを生成
new Vue({

    
    //　データの受け渡しを行うHTML（TWIG）のIDを，『#ID名』で設定する．
    el: '#app',

    
    // 『HTMLでのコンポーネントのタグ名：　JSでのコンポーネントのオブジェクト名』
    component: {
      
        /* 
        親コンポーネントと子コンポーネントの対応関係．
        子コンポーネントごとに異なるファイルを用意する．
        */
        'v-example-component-1': require('./xxx/xxx/xxx-1'),
        'v-example-component-2': require('./xxx/xxx/xxx-2'),
        'v-example-component-3': require('./xxx/xxx/xxx-3')
        },
  
        　　/* dataオプション
           状態を変化させたいデータを，関数として定義しておき，初期状態を設定する．
           異なる場所にある同じコンポーネントは異なるVueインスタンスからなる．
           異なるVueインスタンスは異なる値をもつ必要があるため，メソッドとして定義する．
           */
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

    
      /* methodオプション
      dataオプションの状態を変化させ，親コンポーネントでコールされるメソッドを定義する．
      メソッドは部品化されており，全てのメソッドが合わさって上記の条件に合致する．
      */
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
            
              /* done()
              Ajaxによって返却されたJSON型データが自動的に引数になる．
              リクエストされたデータをdataオプションのプロパティに格納するメソッド．
              */
              .done((data) => {
                 
              /*
              ReadしたJSON型データをJavaScriptのオブジェクトにシリアライズする．
              dataオプションのプロパティに格納する．
              */
              this.staffData = _.map(data.staffData, Staff.parse);
              })
          }

                
        /* watchオプション
        Vueインスタンス内の値の変化を監視する関数を定義する．
        */
        watch: {
      
        }
})
```
#### ・3. ViewModel層での子コンポーネント（```xxx-component.vue```）

ボタンをクリックした時，子コンポーネントの『```$emit("イベント名", "値")```』によって，親コンポーネントの『```v-on: イベント名　=　"値" ```』が発火し，値が渡される．値に応じたコンポーネント部分の変化が起こる．また同時に，子コンポーネントのタグ内で設定された『```:example = "値"```』が，孫コンポーネントの『```props: { "値" }```』に渡される．各コンポーネントで個別に状態を変化させたいものは，propsオプションではなく，dataオプションとして扱う．

**【実装例】**

```vue
<!-- 
v-example-component-1の子コンポーネント
子コンポーネントとして使用するためのtemplateタグ
ここに，出力したいHTMLやTWIGを記述する． 
-->
<template>
  <!-- 孫コンポーネントを記述 -->
  <v-example-component-4
   :aaa="a"
   :bbb="b"
  ></v-example-component-4>  

  <!-- 
  特定の条件の時のみ出力する孫コンポーネント
  値はpropsオプションから参照される
  -->
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
              
    /*
    親コンポーネント（v-example-component-1）と紐づく処理
    hangeイベントを発火させ，イベントに紐づくchangeQuery()の引数として値を渡す．
    */
    this.$emit('change', {'criteria': localCriteria});
            
    // Ajaxから送信されてきたデータを用いて，propsを更新 
    updateFuneral (key, value) {
            
    }    
  },

}
</script>
```

#### ・4-1. Model層でのVuexからなるオブジェクト（```store.js```）

Vuexについては，以降の説明を参照せよ．

#### ・4-2. Model層でのJavaScriptからなるオブジェクト（```xxx.js```）

クラス宣言で実装する．モデルとサーバサイド間のデータ送受信については，Ajaxの説明を参照せよ．

**【実装例】**

```javascript
class Example {
    
    /*
    コンポーネントからデータを受信．
    プロパティの宣言と，同時に格納．
    */
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



## 02-02. Vueにおける個人的な頻出ディレクティブ

### :pushpin: イベントハンドリング

#### ・```v-on:```とは

![Vueにおけるemitとv-onの連携](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Vueにおけるemitとv-onの連携.png)

親コンポーネントにおけるイベントハンドラ関数（```methods:```内メソッド）や，インラインJSステートメントを，子コンポーネントのイベントにバインディングする方法．

```vue
v-on:{イベント名}="{イベントハンドラ関数（methods: 内メソッド）}"
```

または，省略して，

```vue
@:{イベント名}="{イベントハンドラ関数}"
```

で記述する．

**【実装例】**

親コンポーネントでは，コールする子コンポーネントの```search```イベントに対して，```result```というイベントハンドラ関数をバインディングさせておく．

**【実装例】**

```html
<div>
  <v-example-component
    v-on:search="result"
  ></v-example-component>                                        
</div>
```

一方で，子コンポーネントでは，```submit```イベントに```search()```というイベントハンドラ関数をバインディングさせる．このイベントハンドラ関数は，フォーム入力で```submit```イベントが発火した時に，```search()```をコールする．そして，その中の```emit()```が，親コンポーネントの```search```イベントを発火させる．イベント発火によって，```result``` がコールされる．

```vue
<template>
  <form
    id="form"
    method="GET"
    action="/list/"
    v-on:submit.prevent="search()"
  >
  <!-- 何らかのテンプレート -->
  </form>  
</template>
<script>
  
    module.exports = {
        method: {
            search() { 
              // searchイベントを発火させる．
              this.$emit('search')
            },
        },
    };      
</script>      
```

#### ・```v-on:click="{イベントハンドラ関数}"```

クリックイベントとイベントハンドラ関数をバインディングする．

#### ・ ```v-on:change="{イベントハンドラ関数}"```

```input```タグや，```select```タグ内の値の変更イベントとイベントハンドラ関数をバインディングする．



### :pushpin: 条件付きレンダリング

#### ・```v-show```／```v-if```とは

```v-show```または```v-if```で，```v-xxx="{propsのプロパティ名}"```で記述する．親テンプレートから渡された```props```内のプロパティ名がもつ値が```TRUE```の時に表示し，```FALSE```の時に非表示にする．もし頻繁に表示と非表示の切り替えを行うようなら，```v-if```の方が，描画コストが重たくなるリスクが高くなる為，```v-show```推奨である．



### :pushpin: 属性データバインディング

#### ・```v-bind```とは

※要勉強



### :pushpin: フォーム入力データバインディング

#### ・```v-model```とは

※要勉強



### :pushpin:  その他のディレクティブ

#### ・```v-cloak```とは

※要勉強




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
  routes:[
    {path: "/", component: Home},
    {path: "/example", component: Example}
    ]
})

// 外部ファイルが，VueRouterインスタンスを読み込めるようにしておく．
module.exports = router;
```



## 02-04. Vuexライブラリによるデータの状態変化の管理

### :pushpin: Vuexとは

Vuejsでライブラリの一つで，MVVMのモデルに相当する機能を提供する．異なるコンポーネントで共通したデータを扱いたくとも，双方向データバインディングでは，親子コンポーネント間でしか，データを受け渡しできない．しかし，Vuexストア内で，データの状態の変化を管理することによって，親子関係なく，全てのコンポーネント間でデータを受け渡しできるようになる．

※Vuexからなるモデルはどうあるべきか，について要勉強

![VueコンポーネントツリーとVuexの関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VueコンポーネントツリーとVuexの関係.png)



### :pushpin: ```Vuex.Store()```によるVuexストアの実装

外部のコンポーネントは，各オプションにアクセスできる．

#### ・```state:{}```

データの状態の変化をいくつか管理する．クラスベースオブジェクト指向でいうところの，データ（プロパティ）に相当する．

#### ・```mutations:{}```

データに状態（```state```）を設定するメソッドをいくつか持つ．保守性の観点から，```mutations:{}```におくメソッド間は同期的に実行されるようにしておかなければならない．クラスベースオブジェクト指向でいうところの，Setterメソッドに相当する．

#### ・```getters:{}```

データから状態を取得するメソッドをいくつか持つ．クラスベースオブジェクト指向でいうところの，Getterメソッドに相当する．

※MVVMにおいて，モデルにゲッターを持たせてはいけないというルールについては，要勉強．

#### ・```actions:{}```

```mutations{}```のメソッドを間接的にコールするためのメソッドをいくつか持つ．また，JQueryの```ajax()``` をコールし，サーバー側からレスポンスされたデータを```mutations:{}```へ渡す．クラスベースオブジェクト指向でいうところの，Setterメソッドに相当する．

#### クラスベースオブジェクト指向のSetterメソッドに相当する．

**【実装例】**

```javascript
// Vuexライブラリを読み込む．
const vuex = require('vuex')

// 外部ファイルが，このStoreインスタンスを読み込めるようにする．
module.exports = new Vuex.Store({
  
    /* getters
    データから状態を取得するメソッドをいくつか持つ
    クラスベースオブジェクト指向のGetterメソッドに相当.
    */
    getters: {
        staffData(state) {
            return state.staffData;
        },
    },

    /* state
    状態の変化を管理したいデータをいくつかもつ．
    クラスベースオブジェクト指向のプロパティに相当．
    */
    state: {
        // stateには多くを設定せず，Vueインスタンスのdataオプションに設定しておく．
        staffData: [],
    },
    
    /* mutations
    データの状態（state）を変化させるメソッドをいくつかもつ．
    クラスベースオブジェクト指向のSetterメソッドに相当．
    */
    mutations: {
        mutate(state, staffData) {
            exArray.forEach(
                
                /*
                矢印はアロー関数を表し，無名関数の即コールを省略することができる．
                引数で渡されたexArrayの要素を，stateのexArrayに格納する．
                */
                (element) => { state.exArray.push(element); }
                
                /* ※アロー関数を用いなければ，以下のように記述できる．
                function(element) { state.exArray.push(element); }
                */
            );  
        },
        
    },
    
    /* actions
    mutations{}のメソッドを間接的にコールするためのメソッドをいくつか持つ．
    クラスベースオブジェクト指向のSetterメソッドに相当．
    */
    actions: {
        
    },
});  
```



### :pushpin: コンポーネントからVuexへのアクセス

例えば，子コンポーネントのファイル（```template```タグをもつファイル）の下部に，以下を記述することで，```Vuex.Store()```とデータを受け渡しできるようになる．

#### ・```computed: {}```

```mapGetters```ヘルパーと```mapState```ヘルパーを設定する．

#### ・```methods: {}```

```mapMutations```ヘルパーと```mapActions```ヘルパーを設定する．

#### ・```mapGetters```ヘルパー

コンポーネントの```computed:{}```に，```Vuex.Store()```の```getters: {}```をマッピングし，コールできるようにする．

#### ・```mapState```ヘルパー

コンポーネントの```computed:{}```に，```Vuex.Store()```の```state: {}```をマッピングし，コールできるようにする．

#### ・```mapMutations```ヘルパー

コンポーネントの```methods: {}```に，Vuex.Store()```の```mutations: {}```をマッピングし，コールできるようにする．

#### ・```mapActions```ヘルパー

コンポーネントの```methods: {}```に，```Vuex.Store()```の```actions:{}```をマッピングし，コールできるようにする．

**【実装例】**

```vue

<!-- 子コンポーネント -->
<template>
...
</template>
<script>

// Vuex.Store()を読み込む．
const store = require('./_store')

// Vuex.Store()のgetters，mutations，actionsをマッピングできるように読み込む．
const mapGetters = require('vuex').mapGetters;
const mapActions = require('vuex').mapActions;
const mapMutaions = require('vuex').mapMutaions;


module.exports = {
    
    // Readされたデータをキャッシュしたいようなメソッドを定義．
    computed: {

        /* mapGettersヘルパー．
        StoreのGetterをローカルのcomputed:{}にマッピングし，コールできるようにする．
        */
        ...mapGetters([
        'x-Function'
        ])

    },

    // Readされたデータをキャッシュしたくないようなメソッドを定義．
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
}
</script>
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

