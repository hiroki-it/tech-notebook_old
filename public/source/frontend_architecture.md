#  フロントエンドアーキテクチャ

## 01. フロントエンドアーキテクチャの種類

### SPA：Single Page Application

#### ・SPAとは

1つのWebページの中で，サーバとデータを非同期的に通信し，レンダリングすることができるようにする設計のこと．SPA設計では，ページ全体をローディングするのは最初のみで，２回目以降は，サーバ側からJsonデータを受け取り，部分的にローディングを行う．Vueでは，意識せずともSPA設計の元で実装できるようになっている．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SPアプリにおけるデータ通信の仕組み.png)

#### ・SPAの仕組み

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

1. urlにアクセスすることにより，サーバからデータがレスポンスされる．
2. DOMのマークアップ言語の解析により，Webページが構成される．
3. ページ上で任意のイベント（ページング操作，フォーム入力など）が発火し，紐づくハンドラ関数が実行される．
4. JavaScript型オブジェクトがJSONに変換される．
5. 非同期通信メソッドがバックエンドにリクエストを送信する．
6. コントローラは，JSON型データを受信し，またそれを元にDBからオブジェクトをReadする．
7. コントローラは，PHP型オブジェクトをJSONに変換し，レスポンスを返信する．
8. 非同期通信メソッドがバックエンドからレスポンスを受信する．
9. JSONがJavaScript型オブジェクトに変換される．
10. オブジェクトがマークアップ言語に出力される．
11. DOMを用いて，Webページを再び構成する．

#### ・従来WebアプリとSPAの処理速度の違い

サーバとデータを非同期的に通信できるため，1つのWebページの中で必要なデータだけを通信すればよく，レンダリングが速い．

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/従来WebアプリとSPアプリの処理速度の違い.png)

<br>

### SSR：Server Side Rendering

<br>

### SSG：Static Site Generation

<br>

## 02. Ajaxによる非同期的なデータ送受信

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

URLの各```<キー名>=<値>```が，「```&```」で結合され，クエリパラメータとなる．

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

