#  Single Page Application設計

## 01. SPA設計：Single Page Application

### SPA設計とは

1つのWebページの中で，サーバとデータを非同期的に通信し，レンダリングすることができるようにする設計のこと．SPA設計では，ページ全体をローディングするのは最初のみで，２回目以降は，サーバ側からJsonデータを受け取り，部分的にローディングを行う．Vueでは，意識せずともSPA設計の元で実装できるようになっている．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SPアプリにおけるデータ通信の仕組み.png)

<br>

### 従来WebアプリとSPAの処理速度の違い

サーバとデータを非同期的に通信できるため，1つのWebページの中で必要なデータだけを通信すればよく，レンダリングが速い．

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/従来WebアプリとSPアプリの処理速度の違い.png)

<br>

### SPAにおける，JavaScript + JSON型データ + PHP  + マークアップ言語

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

1. urlにアクセスすることにより，サーバからデータがレスポンスされる．
2. DOMのマークアップ言語の解析により，Webページが構成される．
3. ページ上で任意のイベントが発火する．（ページング操作，フォーム入力など）
4. イベント
5. JQueryの```ajax```メソッドが，クエリストリングを生成し，また，リクエストによって指定ルートにJSON型データを送信する．
6. コントローラは，JSON型データを受信し，またそれを元にDBからオブジェクトをReadする．
7. コントローラは，PHPのオブジェクトをJSON型データに変換し，レスポンスによって送信する．
8. JQueryの```ajax```メソッドが，JSON型データを受信する．
9. JSON型データが，解析（パース）によってJavaScriptのオブジェクトに変換される．
10. オブジェクトがマークアップ言語に出力される．
11. DOMを用いて，Webページを再び構成する．

<br>

## 02. Vueを用いたMVVMアーキテクチャ

### MVVMアーキテクチャ，双方向データバインディング

#### ・一般的なMVVMアーキテクチャとは

View層とModel層の間にViewModel層を置き，View層とViewModel層の間で双方向にデータをやり取り（双方向データバインディング）することによって，View層とModel層の間を疎結合にするための設計手法の一つ．

![一般的なMVVMアーキテクチャ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/一般的なMVVMアーキテクチャ.png)

#### ・ MVVMアーキテクチャにおける各層の責務

1. View層（```xxx.html```，```/xxx.twig```，```xxx-component.vue```の```template```タグ部分）

ViewModel層から渡されたデータを出力するだけ．

2. ViewModel層（```index.js```，```xxx-component.vue```の```script```タグ部分）

プレゼンテーションロジック（フォーマット整形，バリデーション，ページのローディング，エラーハンドリング，イベント発火など）や，ビジネスロジック（※控えめに）を記述する．scriptタグによって，JavaScriptが組み込まれている．

3. Model層（```store.js```または```xxx.js```)

ビジネスロジックや，Ajaxによるデータ送受信，を記述する．

#### ・Vueを用いたMVVMアーキテクチャ，双方向データバインディング

Vueは，アプリケーションの設計にMVVMアーキテクチャを用いることを前提として，双方向データバインディングを実現できるような機能を提供する．

1. View層では，```xxx.html```，```/xxx.twig```，```xxx-component.vue```の```template```タグ部分）
2. ViewModel層では，```index.js```，```xxx-component.vue```の```script```タグ部分

3. Model層では，Vuex（```store.js```)やJavaScriptからなるモデル（```xxx.js```）を設置する．
4. これの元，双方向データバインディングが実現される仕組みとして，View層でイベントが起こると，ViewModel層でこれにバインディングされたイベントハンドラ関数がコールされる．

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VueにおけるMVVMアーキテクチャ.png)


### 親子コンポーネント間のデータ渡し

#### ・親子コンポーネント間のデータ渡しの仕組み（Props Down, Events Up）

まず，双方向データバインディングとは異なる概念なので，混乱しないように注意する．コンポーネント（```xxx-component.vue```）の```script```タグ部分（ViewModel層）の親子間では，```props```と```$emit()```を用いて，データを渡す．この仕組みを，Props Down, Events Upという．

![親子コンポーネント間の双方向データバインディング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/親子コンポーネント間の双方向データバインディング.png)

![Vueコンポーネントツリーにおけるコンポーネント間の通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Vueコンポーネントツリーにおけるコンポーネント間の通信.png)

<br>

### ViewModel層におけるルートVueインスタンスの実装方法

#### ・グローバル登録

**＊実装例＊**

```javascript
Vue.component('v-example-component',{
    template: require('./xxx/xxx/xxx')
});

// 変数への格納を省略してもよい
var vm = new Vue({
    el: '#app
})
```

#### ・ローカル登録

**＊実装例＊**

```javascript
var vExampleComponent = {
    // テンプレートと親コンポーネントの対応関係
    template: require('./xxx/xxx/xxx'),
};

// 変数への格納を省略してもよい
var vm = new Vue({

    el: '#app',
  
    components: {
        // 親コンポーネントにオブジェクト名をつける．
        'v-example-component': vExampleComponent
    }
  
})
```

ただし，コンポーネントのオブジェクト名の定義は，以下のように省略することができる．

**＊実装例＊**

```javascript
// 変数への格納を省略してもよい
var vm = new Vue({

    el: '#app',
  
    components: {
        // テンプレートと親コンポーネントの対応関係
        'v-example-component': require('./xxx/xxx/xxx'),
    }
  
})
```

<br>

### MVVMアーキテクチャの実装例

#### (1) 【View層】テンプレート（```xxx.html```，```xxx.twig```）

データが，テンプレートからJavaScriptファイルに渡される仕組みは，フレークワークを使わない場合と同じである．データがJavaScriptファイルに渡される状況としては，イベント発火時である．

**＊実装例＊**

例えば，テンプレートの親コンポーネントタグでクリックイベントが発火した時，親コンポーネントから，イベントに紐づいたイベントハンドラ関数がコールされる．

```html
<!-- divタグのidは『app』とする -->
<div id="app">
  
    <!-- 
    ・親コンポーネントタグを記述．
    ・index.jsdataオプションの値をpropsに渡すように設定．
    ・イベントとイベントハンドラ関数を対応づける．
    -->
    <v-example-component-1
        :criteria="criteria"
        v-on change="changeQuery"
    ></v-example-component-1>

    <!-- 親コンポーネントタグを記述 -->
    <v-example-component-2
                         
    ></v-example-component-2>

    <!-- 親コンポーネントタグを記述 -->
    <v-example-component-3
                         
    ></v-example-component-3>
  
</div>

<!-- ルートVueインスタンスの生成は外部スクリプトで行う． -->
<script 
    src="{{ asset('.../index.js') }}">
</script>
```
#### (1-2) 【ViewModel層】データの初期化を行うVueコンストラクタ（```index.js```）

Vueコンストラクタをインスタンス化することによって，ルートVueインスタンスが生成される．インスタンスの変数名```vm```はVIewModelの意味である．インスタンス化時，全てのコンポーネントのデータが初期化される．各コンポーネントで個別に状態を変化させたいものは，```props```オプションではなく，```data```オプションとして扱う．

**＊実装例＊**

```javascript
// ルートVueインスタンス
// 変数への格納を省略してもよい
var vm = new Vue({
    
    //　Vueインスタンスを使用するdivタグを設定.
    el: '#app',

  
    /* dataオプション
    ・異なる場所にある同じコンポーネントは異なるVueインスタンスからなる．
    ・異なるVueインスタンスは異なる値をもつ必要があるため，メソッドとして定義．
    */
    data: function() {
          return {
              isLoading: false,
              staffData: [],
              criteria: {
                  id: null,
                  name: null
                  },
          };
     },

    
     /* methodオプション
     ・イベントハンドラ関数，dataオプションのセッターを定義
     ・dataオプションの状態を変化させる．
     */
     method: {
       
         // イベントハンドラ関数
         changeQuery(criteriaObj) {
             const keys = [
                 'criteria',
                 'limit',
             ];
             for (const key of keys) {
                 if (key in criteriaObj) {
                     this[key] = criteriaObj[key];
             }
        },
            
        // dataオプションのセッター
        load(query) {
            // ここでのthisはdataオプションを指す．
            this.isLoading = true;
            this.staffData = [];
            // JSON型データをajax()でサーバサイドに送信し，JSON型オブジェクトを受信
            return Staff.find(query)
            
                /* done()
                Ajaxによって返却されたJSON型オブジェクトが引数になる．
                */
                .done((data) => {
               
                    /*
                    サーバサイドからのJSON型データをデシリアライズ．             
                    dataオプションに設定．
                    */
                    this.staffData = _.map(
                                        data.staffData,
                                        Staff.deserializeStaff
                                     );
                })
        },
    },

       
    /* watchオプション
    Vueインスタンス内の値の変化を監視する関数を定義．
    Vue-Routerを参照せよ．
    */
    watch: {
      
    },
    
       
    // テンプレートと親コンポーネントの対応になるようにする．
    component: {
      
        //『HTMLでのコンポーネントのタグ名：子コンポーネント』
        'v-example-component-1': require('.../component/xxx-1.vue'),
        'v-example-component-2': require('.../component/xxx-2.vue'),
        'v-example-component-3': require('.../component/xxx-3.vue')
    },
})
```
#### (2) 【View + ViewModel層】単一ファイルコンポーネントとしてのコンポーネント（```xxx-component.vue```）

コンポーネントは，View層としての```template```タグ，ViewModel層としての```script```タグと```style```タグを用いて，単一ファイルコンポーネントとする．

**＊実装例＊**

例えば，親コンポーネントの子コンポーネントタグでクリックイベントが発火した時，子コンポーネントから，イベントに紐づいたイベントハンドラ関数がコールされる．

```vue
<template>
<!----------------------------------------
// View層
// ・親コンポーネント
// ・ここに，出力したいHTMLやTWIGを記述する． 
------------------------------------------>

  <!-- 
  ・子コンポーネントタグを記述 
  ・下方のdataオプションの値をpropsに渡すように設定．
  -->
  <v-example-component-4
   :aaa="a"
   :bbb="b"
  ></v-example-component-4>  

  <!-- 条件付きレンダリングを行うディレクション -->
  <template v-if="example.isOk()">
    <!-- 孫コンポーネントタグを記述 -->
    <v-example-component-5
      :ccc="c"
      :ddd="d"                          
    ></v-example-component-5>  
  </template>

</template>

<script>
//=============
// ViewModel層
//=============
    
// 親コンポーネント以降では，Vueインスタンスを生成しないようにする．
module.exports = {

  /* propsオプション
  ・親コンポーネントまたはAjaxからpropsオブジェクトのプロパティに値が格納される．
  */
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
      
  /* dataオプション
  ・異なる場所にある同じコンポーネントは異なるVueインスタンスからなる．
  ・異なるVueインスタンスは異なる値をもつ必要があるため，メソッドとして定義する．
  */
  data: function() {
      return {
          a: "a"
          b: "b"
          c: "c"
          d: "d"
      };
  },
      
      
  // イベントハンドラ関数，dataオプションのセッター
  method: {
      updateCriteria (key, value) {
              
          /*
          ・コンポーネント（v-example-component-1）と紐づく処理
          ・changeイベントの発火と，これのイベントハンドラ関数に引数を渡す．
          */
          this.$emit(
              'change',
              {'criteria': localCriteria}
              );
            
      // Ajaxから送信されてきたデータを用いて，propsを更新 
      updateProps (key, value) {
            
      }
  },
    
        
  // 『HTMLでのコンポーネントのタグ名：　JSでのコンポーネントのオブジェクト名』
  component: {

      // 子コンポーネントと孫コンポーネントの対応関係
      'v-example-component-4': require('./xxx/xxx/xxx-4'),
      'v-example-component-5': require('./xxx/xxx/xxx-5'),
  },
}
</script>
```

#### (3) 【Model層】オブジェクトとしてのVuex（```store.js```）

Vuexについては，以降の説明を参照せよ．

#### (3-2) 【Model層】オブジェクトとしてのJavaScript（```xxx.js```）

クラス宣言で実装する．

**＊実装例＊**

```javascript
class Example {
    
    /*
    ・コンポーネントからデータを受信．
    ・プロパティの宣言と，同時に格納．
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

<br>

## 02-02. View層とViewModel層の間での双方向データバインディングの方法

### イベントハンドリング

#### ・```v-on:```とは

![Vueにおけるemitとv-onの連携](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Vueにおけるemitとv-onの連携.png)

View層（```template```タグ部分）のイベントを，ViewModel層（```script```タグ部分）のイベントハンドラ関数（```methods:```内にあるメソッド）やインラインJSステートメントにバインディングし，イベントが発火した時点でイベントハンドラ関数をコールする．コンポーネントの```script```タグ部分（ViewModel層）の親子間データ渡しである「Props Down, Events Up」とは異なる概念なので注意する．

```vue
v-on:{イベント名}="{イベントハンドラ関数（methods: 内にあるメソッド）}"
```

または，省略して，

```vue
@:{イベント名}="<イベントハンドラ関数>"
```

で記述する．

#### ・```v-on:submit="<イベントハンドラ関数>"```，```button```タグ

View層のフォーム送信イベントが起きた時点で，ViewModel層にバインディングされたイベントハンドラ関数をコールする．例えば，親コンポーネントでは，子コンポーネントによって発火させられる```search```イベントに対して，```result()```というイベントハンドラ関数を紐づけておく．

**＊実装例＊**

```html
<div id='app'>
  <v-example-component
    v-on:search="result()"
  ></v-example-component>                                        
</div>

<!-- Vueインスタンスの生成は外部スクリプトで行う． -->
<script
    src="{{ asset('.../index.js') }}">
</script>
```

index.jsの```methods:```内には，イベントハンドラ関数として```result()```を定義する．

**＊実装例＊**

```javascript
// 変数への格納を省略してもよい
var vm = new Vue({
    
    //　Vueインスタンスを使用するdivタグを設定.
    el: '#app',
    
    // イベントハンドラ関数
    method: {
        result() {
            // 何らかの処理
        }
    }    
})
```

1. 『検索ボタンを押す』という```submit```イベントの発火によって，```form```タグでイベントに紐づけられているイベントハンドラ関数（```search()```）がコールされる．
2. イベントハンドラ関数内の```emit()```が，親コンポーネントの```search```イベントを発火させる．これに紐づくイベントハンドラ関数（```result()```） がコールされる．

**＊実装例＊**

```vue
<template>
  <!-- submitイベントが発火すると，紐づくイベントハンドラ関数がコールされる -->
  <form v-on:submit.prevent="search()">
    <!-- submitイベントを発火させるbuttonタグ．submitの場合は省略可能 -->
    <button type="submit">検索する</button>
  </form>
</template>

<script>
// 変数への格納を省略してもよい
var vm = new Vue({
  
  // イベントハンドラ関数を定義
  methods: {
    search() { 
      // 親コンポーネントのsearchイベントを発火させる．
      this.$emit('search')
    },
  }
})
</script>      
```

#### ・```v-on:click="<イベントハンドラ関数>"```

View層でクリックイベントが起きた時点で発火し，ViewModel層でバインディングされたイベントハンドラ関数をコールする．

```

```

#### ・ ```v-on:change="<イベントハンドラ関数>"```

View層で```input```タグや```select```タグで，値の入力後にマウスフォーカスがタグから外れた時点で発火し，ViewModel層でバインディングされたイベントハンドラ関数をコールする

```

```

#### ・```v-on:input="<イベントハンドラ関数>"```

View層で```input```タグで，一文字でも値が入力された時点で発火し，ViewModel層バインディングされたイベントハンドラ関数をコールする．```v-on:change```とは，イベントが発火するタイミングが異なるため，共存することが可能である．

```

```

<br>

### 条件付きレンダリング

#### ・```v-show```／```v-if```とは

条件分岐を行うタグであり，```v-show```または```v-if```を使用して，プロパティ名を指定する．（```v-xxx="<propsのプロパティ名>"```）で記述する．親テンプレートから渡された```props```内のプロパティ名がもつ値が```TRUE```の時に表示し，```FALSE```の時に非表示にする．もし頻繁に表示と非表示の切り替えを行うようなら，```v-if```の方が，描画コストが重たくなるリスクが高くなる為，```v-show```推奨である．

| タグ   | 使い分け                        |
| ------ | :------------------------------ |
| v-if   | 単発の切り替えがメインの場合    |
| v-show | 表示/非表示の切替回数が多い場合 |

<br>

### 属性データバインディング

#### ・```v-bind```とは

※要勉強

<br>

### フォーム入力データバインディング

#### ・```v-model```とは

実装方法は，```v-on:input="<イベントハンドラ関数>"```と同じである．例えば，以下の二つは同じである．

```vue
<input
    type="text"
    v-model="example">
</input>
```

```vue
<input 
    type="text"
    :value="example"
    @input="eventHandler">
</input>
```

<br>

###  その他のディレクティブ

#### ・```v-cloak```とは

※要勉強

<br>


## 02-03. Vue-Routerライブラリによるルーティング

### Vue-Router

#### ・Vue-Routerとは

![ルーティングコンポーネント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ルーティングコンポーネント.png)

ルーティングライブラリの一つ．コンポーネントに対してルーティングを行い，```/{ルート}/パラメータ}```に応じて，コールするコンポーネントを動的に切り替えることができる．

```
http://www.example.co.jp:80/{ルート}/{パスパラメータ}?text1=a&text2=b
```

**＊実装例＊**

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

そして，Vue-Routerの機能を利用するために，```router```オプションとして．ルートコンポーネントに注入する必要がある．

```javascript
// 変数への格納を省略してもよい
var vm = new Vue({

    router,
  
  　// watchオプション
    watch: {
        // スタック内で履歴の移動が起こった時に，対応付けた無名関数を実行．
        '$route': function (to, from) {
            if(to.fullPath !== from.fullPath) {
                // 何らかの処理．
        }
    },
)}
```

#### ・```$router```（Routerインスタンス）

Webアプリケーション全体に1つ存在し，全体的なRouter機能を管理しているインスタンス．スタック型で履歴を保持し，履歴を行き来することで，ページ遷移を行う．

| メソッド     | 説明                                                         |
| ------------ | ------------------------------------------------------------ |
| ```push()``` | ```query```オブジェクトを引数とする．履歴スタック内に新しい履歴を追加し，現在をその履歴とする．また，ブラウザの戻る操作で，履歴スタック内の一つ前の履歴に移動する． |

#### ・```$route```（Routeオブジェクト）

現在のアクティブなルートをもつオブジェクト

| プロパティ     | データ型     | 説明                                                         | 注意                                     |
| :------------- | ------------ | :----------------------------------------------------------- | ---------------------------------------- |
| ```path```     | ```string``` | 現在のルートの文字列．                                       |                                          |
| ```query```    | ```Object``` | クエリパラメータのキー名と値を保持するオブジェクト．```/foo?user=1```というクエリパラメータの場合，```$route.query.user==1```となる． | もしクエリーがない場合は，空オブジェクト |
| ```fullPath``` | ```string``` | URL全体の文字列．                                            |                                          |

<br>

### その他のRouterライブラリ

JQueryにはJQueryRouter，ReactにはReact-Routerがある．

<br>

## 02-04. Vuexライブラリによるデータの状態変化の管理

### Vuexとは

Vuejsでライブラリの一つで，MVVMアーキテクチャのモデルに相当する機能を提供し，グローバルで参照できる．異なるコンポーネントで共通したデータを扱いたくとも，双方向データバインディングでは，親子コンポーネント間でしか，データを受け渡しできない．しかし，Vuexストア内で，データの状態の変化を管理することによって，親子関係なく，全てのコンポーネント間でデータを受け渡しできるようになる．

※Vuexからなるモデルはどうあるべきか，について要勉強

![VueコンポーネントツリーとVuexの関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VueコンポーネントツリーとVuexの関係.png)

<br>

### ```Vuex.Store()```によるVuexストアの実装

外部のコンポーネントは，各オプションにアクセスできる．

#### ・```getters:{}```

データから状態を取得するメソッドをいくつか持つ．クラスベースオブジェクト指向でいうところの，Getterメソッドに相当する．

※MVVMにおいて，モデルにゲッターを持たせてはいけないというルールについては，要勉強．

#### ・```state:{}```

データの状態の変化をいくつか管理する．クラスベースオブジェクト指向でいうところの，データ（プロパティ）に相当する．

#### ・```mutations:{}```

データに状態（```state```）を設定するメソッドをいくつか持つ．保守性の観点から，```mutations:{}```におくメソッド間は同期的に実行されるようにしておかなければならない．クラスベースオブジェクト指向でいうところの，Setterメソッドに相当する．

#### ・```actions:{}```

定義された```mutations{}```のメソッドを間接的にコールするためのメソッドをいくつか持つ．また，JQueryの```ajax```メソッド をコールし，サーバー側からレスポンスされたデータを```mutations:{}```へ渡す．クラスベースオブジェクト指向でいうところの，Setterメソッドに相当する．

**＊実装例＊**

```javascript
// Vuexライブラリを読み込む．
const vuex = require('vuex')

// 外部ファイルが，このStoreインスタンスを読み込めるようにする．
module.exports = new Vuex.Store({
  
    /* getters
    ・データから状態を取得するメソッドをいくつか持つ
    ・クラスベースオブジェクト指向のGetterメソッドに相当.
    */
    getters: {
        staffData(state) {
            return state.staffData;
        },
    },

    /* state
    ・状態の変化を管理したいデータをいくつかもつ．
    ・クラスベースオブジェクト指向のプロパティに相当．
    */
    state: {
        // stateには多くを設定せず，Vueインスタンスのdataオプションに設定しておく．
        staffData: [],
    },
    
    /* mutations
    ・データの状態（state）を変化させるメソッドをいくつかもつ．
    ・クラスベースオブジェクト指向のSetterメソッドに相当．
    */
    mutations: {
        // Vuexのstateを第一引数，外部からセットしたい値を第二引数
        mutate(state, staffData) {
            exArray.forEach(
                
                /*
                ・矢印はアロー関数を表し，無名関数の即コールを省略することができる．
                ・引数で渡されたexArrayの要素を，stateのexArrayに格納する．
                */
                (element) => { state.exArray.push(element); }
                
                /* 
                ※アロー関数を用いなければ，以下のように記述できる．
                function(element) { state.exArray.push(element); }
                */
            );  
        },
        
    },
    
    /* actions
    ・mutations{}のメソッドを間接的にコールするためのメソッドをいくつか持つ．
    ・contextオブジェクトからcommit機能を取り出す必要がある．（※省略記法あり）
    ・クラスベースオブジェクト指向のSetterメソッドに相当．
    */
    actions: {
        // 省略記法（Argument destructuring)
        mutate ({commit})
           commit('mutate')
        }  
    }
})
```

<br>

### コンポーネントからVuexへのアクセス

例えば，子コンポーネントのファイル（```template```タグをもつファイル）の下部に，以下を記述することで，```Vuex.Store()```とデータを受け渡しできるようになる．

#### ・```computed: {}```

イベントハンドラ関数として，```mapGetters```ヘルパーと```mapState```ヘルパーを設定する．

#### ・```methods: {}```

イベントハンドラ関数として，```mapMutations```ヘルパーと```mapActions```ヘルパーを設定する．

#### ・```mapGetters```ヘルパー

コンポーネントの```computed:{}```に，```Vuex.Store()```の```getters: {}```をマッピングし，コールできるようにする．

#### ・```mapState```ヘルパー

コンポーネントの```computed:{}```に，```Vuex.Store()```の```state: {}```をマッピングし，コールできるようにする．

#### ・```mapMutations```ヘルパー

コンポーネントの```methods: {}```に，Vuex.Store()```の```mutations: {}```をマッピングし，コールできるようにする．

#### ・```mapActions```ヘルパー

コンポーネントの```methods: {}```に，```Vuex.Store()```の```actions:{}```をマッピングし，コールできるようにする．

**＊実装例＊**

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
    
    // イベントハンドラ関数を定義（※データを状態の変更を保持したくないもの）
    computed: {

        /* mapGettersヘルパー．
        StoreのGetterをローカルのcomputed:{}にマッピングし，コールできるように．
        */
        ...mapGetters([
        'x-Function'
        ])

    },

    // イベントハンドラ関数を定義（※データを状態の変更を保持したいもの）
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

<br>

## 03. JavaScriptとJSONの相互パース

サーバとのデータ送受信の前後に，データ型のパースを行う必要がある，これについては，JSONのノートを参照．

<br>

## 04. Ajaxによる非同期的なデータ送受信

### JQueryの```ajax```メソッドを用いたAjaxの実装

#### ・```ajax```メソッドとは

コンポーネントごとにリクエストメッセージを送信する必要があるので，JQueryの```ajax```メソッドには，メソッド，URL，ヘッダー，ボディを設定する項目がある．データ送信後は，その結果に応じてJQuery.Defferredモジュールで後処理を行う．

#### ・GET送信の場合

リクエストメッセージの構造については，ネットワークのノートを参照せよ．

**＊実装例＊**

JQueryの```ajax```メソッドで，GET送信でリクエストするデータから，クエリパラメータを生成する．

```javascript
// ここに実装例
```

```{キー名}={値}```が，```&```で結合され，クエリパラメータとなる．

```
# ...の部分には，データ型を表す記号などが含まれる．
http://127.0.0.1/.../?fruit...=ばなな&fruit...=りんご&account...=200
```

#### ・POST送信の場合

リクエストメッセージの構造については，ネットワークのノートを参照せよ．

**＊実装例＊**

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

**＊実装例＊**

```javascript
static find(query) {

    return $.ajax({
        /* リクエストメッセージ */
        // メソッドとURL
        type: 'POST', // メソッドを指定
        url: '/xxx/xxx', // ルートとパスパラメータを指定
        // ヘッダー
        contentType: 'application/json',　// 送信するデータの形式を指定
        // ボディ
        data: query, // 送信するメッセージボディのデータを指定
      
      
        /* レスポンスメッセージ */
        dataType: 'json', // 受信するメッセージボディのデータ型を指定
        
    })

    /* JQueryのDeferredモジュールを使用
    ajax()の処理が成功した場合に起こる処理．
    */ 
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

<br>

### Deferredモジュール

#### ・```Deferred.done().fail().always()```とは

JQueryの```ajax```メソッドの結果を，```done()```，```fail()```，```always()```の三つに分類し，これに応じたコールバック処理を実行する方法．

```javascript
$.ajax({
  url: "xxxxx", // URLを指定
  type: "GET", // GET,POSTなどを指定
  data: { // データを指定
    param1 : "AAA",
    param2 : "BBB"
  }
})
  // 通信成功時のコールバック処理
  .done((data) => {
  
  })
  // 通信失敗時のコールバック処理
  .fail((data) => {
  
  })
  // 常に実行する処理
  .always((data) => {
  
});
```

#### ・```Deferred.then()```とは

JQueryの```ajax```メソッドの結果を，```then()```の引数の順番で分類し，これに応じたコールバック処理を実行する方法．非同期処理を連続で行いたい場合に用いる．

```javascript
$.ajax({
  url: "xxxxx", // URLを指定
  type: "GET", // GET,POSTなどを指定
  data: { // データを指定
    param1 : "AAA",
    param2 : "BBB"
  }
})
// 最初のthen
.then(
  // 引数1つめは通信成功時のコールバック処理
  (data)　=> {
    
  },
  // 引数2つめは通信失敗時のコールバック処理
  (data) => {
    
})
// 次のthen
.then(
  // 引数1つめは通信成功時のコールバック処理
  (data)　=> {
    
});
```

