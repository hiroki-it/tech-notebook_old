#  フロントエンドアーキテクチャ

## 01. フロントエンドアーキテクチャの種類

### SPA：Single Page Application

#### ・SPAとは

1つのWebページの中で，サーバとデータを非同期通信し，ブラウザ側で部分的に静的ファイルを生成する方法のこと．非同期通信は，Ajaxの手法を用いて実現される．また，静的ファイルの部分的な生成は，MVVMアーキテクチャによって実現する．SPAでは，ページ全体の静的ファイルをリクエストするのは最初のみで，２回目以降は，サーバ側からJSONを受け取り，部分的にリクエストを行う．

![SPアプリにおけるデータ通信の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SPアプリにおけるデータ通信の仕組み.png)

#### ・MVVMアーキテクチャとは

Vue.jsでは，意識せずにMVVMアーキテクチャで実装できるようになっている．詳しくは，Vue.jsのノートを参考にせよ．

#### ・Ajaxとは：Asynchronous JavaScript + XML

![AJAXの処理フロー](https://user-images.githubusercontent.com/42175286/58467340-6741cb80-8176-11e9-9692-26e6401f1de9.png)

HTML，XHTML，CSS，JavaScript，DOM，XML，XSLT，を組み合わせて非同期通信を実現する手法のこと．これらの技術を以下の順で組み合わせる．

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

#### ・MPAとSPAの処理速度の違い

従来のアーキテクチャであるMPAと比較して，データを非同期的に通信できるため，1つのWebページの中で必要なデータだけを通信すればよく，レンダリングが速い．

![従来WebアプリとSPアプリの処理速度の違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/従来WebアプリとSPアプリの処理速度の違い.png)

<br>

### SSR：Server Side Rendering

#### ・SSRとは

1つのWebページの中で，サーバとデータを非同期通信し，サーバ側で部分的に静的ファイルを生成する方法のこと．SPAと同様にして，非同期通信は，Ajaxの手法を用いて実現される．また，静的ファイルの部分的な生成は，MVVMアーキテクチャによって実現する．また，ページ全体の静的ファイルをリクエストするのは最初のみで，２回目以降は，サーバ側からJSONを受け取り，部分的にリクエストを行う．

<br>

### SSG：Static Site Generation

#### ・SSGとは

静的ファイルとしてビルドされたWebページをフロントエンドとして使用する方法．動的な要素を含む静的ファイルについては，ビルド時にバックエンドからデータを取得し，これを元にビルドを行うようにする．

<br>

## 02. JQueryパッケージ

### ```ajax```メソッドによるAjaxの実現

#### ・```ajax```メソッドとは

HTTPメソッド，URL，ヘッダー，メッセージボディなどを設定し，非同期的にデータを送受信する．Promiseオブジェクトを返却する．

参考：https://api.jquery.com/jquery.ajax

**＊実装例＊**

```javascript
class Example {
    
    constructor(properties) {
        this.id = properties.id;
    }
    
    /**
     * ajaxメソッドのラッパーメソッド
     */
    static find() {
        return $.ajax({

            // ###################
            //  リクエストメッセージ
            // ###################
            
            // HTTPメソッドを指定
            type: 'POST',
            
            // ルートとパスパラメータを指定
            url: '/xxx/xxx/' + this.id + '/', 

            // 送信するデータの形式を指定
            contentType: 'application/json',

            // メッセージボディ
            data: {
                param1: "AAA",
                param2: "BBB"
            },

            // ###################
            //  レスポンスメッセージ
            // ###################
            
            // 受信するメッセージボディのデータ型を指定
            dataType: 'json',
        })
    }
}
```

<br>

### レスポンス受信後の処理分岐

#### ・```done```メソッド，```fail```メソッド，```always```メソッドとは

Promiseオブジェクトがもつメソッド．```ajax```メソッドによってレスポンスを受信した後，その結果を```done```，```fail```，```always```の三つに分類し，これに応じたコールバック処理を実行する方法．

**＊実装例＊**

```javascript
class Example {
    
    constructor(properties) {
        this.id = properties.id;
    }
    
    /**
     * ajaxメソッドのラッパーメソッド
     */
    static find() {
        return $.ajax({
            type: 'POST',
            url: '/xxx/xxx/' + this.id + '/', 
            contentType: 'application/json',
            data: {
                param1: "AAA",
                param2: "BBB"
            },
        })
            // 非同期通信の成功時のコールバック処理
            .done((data) => {

            })
        
            // 非同期通信の失敗時のコールバック処理
            .fail((data) => {
                toastr.error('', 'エラーが発生しました．');
            })
        
            // 非同期通信の成功失敗に関わらず常に実行する処理
            .always((data) => {
                this.isLoaded = false;
            });
    }
}
```

#### ・```then```メソッドとは

Promiseオブジェクトがもつメソッド．```ajax```メソッドによってレスポンスを受信した後，その結果を```then```メソッドの引数の順番で分類し，これに応じたコールバック処理を実行する方法．非同期処理を連続で行いたい場合に用いる．

**＊実装例＊**

```javascript
class Example {
    
    constructor(properties) {
        this.id = properties.id;
    }
    
    /**
     * ajaxメソッドのラッパーメソッド
     */
    static find() {
        return $.ajax({
            type: 'POST',
            url: '/xxx/xxx/' + this.id + '/', 
            contentType: 'application/json',
            data: {
                param1: "AAA",
                param2: "BBB"
            },
        })
            // 最初のthen
            .then(
                // 引数1つめは通信成功時のコールバック処理
                (data) => {

                },
                // 引数2つめは通信失敗時のコールバック処理
                (data) => {

                })
            // 次のthen
            .then(
                // 引数1つめは通信成功時のコールバック処理
                (data) => {

                });
    }
}
```

<br>

## 02-02. Axiosパッケージ

### axiosオブジェクトによるAjaxの実現

#### ・axiosオブジェクトとは

参考：https://github.com/axios/axios#axios

<br>

## 02-03. async/await宣言

### async/await宣言による非同期関数化

#### ・async/await宣言とは

宣言することにより，非同期関数として定義できる．定義された非同期関数は，Promiseオブジェクトを返却する．

**＊実装例＊**

```javascript
async function example() {
    // 何らかの処理
}
```

参考：https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/async_function

#### ・resolveとreject

**＊実装例＊**

```javascript
// resolve1!!をreturnしているため、この値がresolveされる
async function resolveExample() {
  return 'resolve!!';
}

// resolveExampleがPromiseを返し、resolve!!がresolveされるため
// then()が実行されコンソールにresolve!!が表示される
resolveExample().then(value => {
  console.log(value); // => resolve!!
});


// reject!!をthrowしているため、この値がrejectされる
async function rejectExample() {
  throw new Error('reject!!');
}

// rejectExampleがPromiseを返し、reject!!がrejectされるため
// catch()が実行されコンソールにreject!!が表示される
rejectExample().catch(err => {
  console.log(err); // => reject!!
});


// resolveErrorはasync functionではないため、Promiseを返さない
function resolveError() {
  return 'resolveError!!';
}

// resolveErrorはPromiseを返さないため、エラーが発生して動かない
// Uncaught TypeError: resolveError(...).then is not a function
resolveError().then(value => {
  console.log(value);
});
```
