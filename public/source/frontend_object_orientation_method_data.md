# プロトタイプベースのオブジェクト指向プログラミング（２）

## 01. 関数

### 関数オブジェクト

#### ・関数オブジェクトとは

オブジェクトでもある関数である．

#### ・リテラル表記による関数オブジェクト

```javascript
// 定義
const object = {
  foo: 'bar',
  age: 42,
  baz: {myProp: 12},
}
```

#### ・コンストラクタ関数

```Function```コンストラクタを，関数宣言の方式で定義している．

```javascript
// 関数宣言による定義
function car(make, model, year) {
   this.make = make;
   this.model = model;
   this.year = year;
}

// コール
const mycar = new car("Eagle", "Talon TSi", 1993);
```

<br>

### function命令

#### ・function命令とは

オブジェクトではない関数である．

**＊実装例＊**

```javascript
// 定義（コールする場所が前後しても無関係）
function methodA(){
    return "A";
}
```

```javascript
// コール
function methodA();
```

#### ・名前がドルマークのもの

JavaScriptでよく見かけるドルマーク．これは，関数の名前としてドルマークを使用しているだけである．

**＊実装例＊**

```javascript
// 定義
function $(){
    return 'A';
}
```

jQueryでは，ライブラリの読み込み宣言時に，「Jquery」という名前の代わりにドルマークを使用する仕様になってる．これと混乱しないように注意する．

**＊実装例＊**

```javascript
// jQuery.get() と同じ
$.get() {
    return 'A';
}
```

#### ・コールバック関数

```javascript
function asyncFunc(param, callback) {
  setTimeout(() => {
    
    // getDataメソッドは，数値を渡すとdataを取得してくれると仮定します．
    var data = getData(param);
    var err = data.getError();
      
    // 第二引数のコールバック関数は，getDataメソッドとgetErrorメソッドの後に実行される．
    callback(err, data);
  }, 0);
}

const test = 1

// asyFuncメソッドの第一引数が，第二引数で設定したコールバック関数に渡される．
// 渡されたコールバック関数は，getDataメソッドとgetErrorメソッドの後に実行されるため，errやdataを受け取れる
asyncFunc(test, (err, data) => {
  if (err) {
      throw err;
  }
    console.log(data);
});
```

<br>

## 02. データ型

### undefined，null

#### ・undefined

データを代入しない時に適用されるデータ型である．

**＊実装例＊**


```javascript
// 変数b: 初期化されていない（値が代入されていない）
const b;

// 変数bの出力
console.log(b);  // undefied
```


#### ・null

nullは，undefinedとは異なり，意図して代入しなければ適用されないデータ型である．

**＊実装例＊**

```javascript
// 変数a: 意図をもってnullを入れている
const a = null;

console.log(a); // null
```

#### ・undefined型データの返却

```undifined```を返却する場合，```return```のみを記述する．

**＊実装例＊**

```JavaScript
function hoge(){
    return; // 空の『return文』です。空なので『undefined』を返します。
}

const x = hoge(); // 変数『x』には関数『hoge』から返ってきた『undefined』が代入されます。
 
console.log(x); // 『undefined』が出力されます。
```

<br>

## 03. 変数

### 変数の種類

#### ・一覧表

|              | var          | let              | const            |
| :----------- | :----------- | :--------------- | ---------------- |
| **再宣言**   | 可能         | 不可能           | 不可能           |
| **再代入**   | 可能         | 可能             | 不可能           |
| **スコープ** | 関数スコープ | ブロックスコープ | ブロックスコープ |

#### ・```const```

基本的には，宣言に```const```を用いる

```javascript
if (true) {
  // ブロック外からアクセス不可
  const x = 'hoge';
    
  // 再宣言不可
  const x = 'fuga'; // ERROR
  
  // 再代入不可
  x = 'fuga'; // ERROR
}

// ブロック内のconstにアクセス不可
console.log(x); // ERROR
```

#### ・ ```let```

繰り返し処理において再代入が必要であれば，```const```ではなく```let```を用いる．


```javascript
if (true) {
  // ブロック外からアクセス不可
  let x = 'hoge';
    
  // 再宣言不可
  let x = 'fuga'; // ERROR
  
  // 再代入可能
  x = 'fuga';
}

// ブロック内のletにアクセス不可
console.log(x); // ERROR
```

#### ・ ```var```


```javascript
if (true) {
  // ブロック外からアクセス可
  var x = 'hoge';
    
  // 再宣言
  var x = 'fuga';
    
  // 再代入可能
  x = 'fuga';
}

// ブロック内のvarにアクセス可能
console.log(x); // fuga
```

<br>

### 変数の巻き上げ

#### ・巻き上げの対策

意図しない挙動を防ぐため，javascriptにおいて，変数の宣言と代入は，スコープの最初に行う．

#### ・```var```

確認のため```console.log```メソッドを実行した場合，```x```を宣言していないため，「x is not defined 」エラーになりそうだが，```x```に値が代入されていないことを示す「undefined」となる．

```javascript
console.log(x); // undefined

var x = 'hoge';
```

これは，スコープの範囲内で宣言代入した変数において，宣言処理がスコープの最初に行ったことになるという仕様のためである．

```javascript
var x // 宣言のみ行われる

console.log(x); // undefined

var x = 'hoge'; // 宣言と代入が行われる
```

#### ・```let```,```const```

宣言に```let```，```const```を使用した場合，巻き上げは起こらない．

```javascript
console.log(x); // x is not defined

let x = 'hoge';
```

