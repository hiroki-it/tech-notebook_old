# プロトタイプベースのオブジェクト指向


## 01. 標準ビルトインオブジェクト

### 標準ビルトインオブジェクトとは

JavaScriptの実行環境にあらかじめ組み込まれたオブジェクト．

<br>

### Object

オブジェクトを生成するオブジェクト．他の全ての標準ビルトインオブジェクトの継承元になっているため，標準ビルトインオブジェクトは，Objectが持つメソッドとデータを使うことができる．

**＊実装例＊**

```javascript
// new演算子を使ってインスタンスを生成
var obj = new Object();
```

<br>

### Function

**＊実装例＊**

```

```

<br>

### Array

#### ・```Array.prototype.entries()```

配列からkeyとvalueを取得する．

**＊実装例＊**

```javascript
var array = ['a', 'b', 'c'];

// key，valueを取得できる．
var iterator = array.entries();

// for-ofで展開
for (const value of iterator) {
  console.log(e);
}

// [0, 'a']
// [1, 'b']
// [2, 'c']
```

#### ・```Array.prototype.map()```

**＊実装例＊**


```javascript
// ここに実装例
```

#### ・```Array.prototype.filter()```

**＊実装例＊**

```javascript
// ここに実装例
```

#### ・```Array.length```

要素数を出力する．

**＊実装例＊**

```javascript
const clothing = ['shoes', 'shirts', 'socks', 'sweaters'];

console.log(
    clothing.length
);

// 4
```

<br>

### JSON

#### ・```JSON.parse()```

JavaScriptからJSONにシリアライズする．

**＊実装例＊**

```javascript
console.log(
    JSON.stringify({
        x : 1,
        y : 5,
        z : "test"
    })
);

// JSON形式オブジェクト
// "{"x":5, "y":5 "z":"test"}"
```

#### ・```JSON.stringify()```

JSONからJavaScriptにデシリアライズする．

**＊実装例＊**

```javascript
console.log(
    JSON.parse("{
        "x" : 1,
        "y" : 5,
        "z" : "test"
     }")
);

// JavaScriptオブジェクト
// {x:5, y:5 z:"test"}
```

<br>

## 01-02. DOMオブジェクト

### Document

#### ・```Document.getElementbyId()```

指定した```id```のhtml要素を取得する．

**＊実装例＊**

```html
<html>
 <body>
  <p id="myid">Hello world!</p>
  <script>
   console.log(document.getElementById("myid"));
  </script>
 </body>
</html>
```

```javascript
// <p id="myid">Hello world!</p>
```

<br>

### EventTarget

#### ・```EventTarget.addEventListener()```

第一引数で，```click```などのイベントを設定し，第二引数でメソッド（無名関数でも可）を渡す．

**＊実装例＊**

```html
<button id="btn">表示</button>

<script>
const btn = document.getElementById('btn');
btn.addEventListener('click', function() {
    console.log('クリックされました！');
    },
    false
    );
</script>
```

<br>

## 02. オブジェクトの生成，初期化

### リテラル表記の使用

オブジェクトをリテラル表記で生成する方法．キャメルケース（小文字から始める記法）を用いる．

#### ・非省略形

**＊実装例＊**

```javascript
// リテラル表記
const example = {
  
  // 慣習的にアンダーバーでprivateを表す．
  _property: 0,
  
  alertValue: function(value) {
      alert(value);
  }, 
  
  set setValue(value) {
      this._property = value;
  },  
  
  get getValue() {
      return this._property;
  }
}
```

#### ・省略形

```methodA(): fucntion{}``` とするところを，```methodA() {}```と記述できる．

```javascript
// リテラル表記
const example = {
  
 // ~~ 省略 ~~
  
  alertValue(value) {
      alert(value);
  }, 
  
  // ~~ 省略 ~~
}
```

<br>

### コンストラクタ関数の使用

#### ・```Object```コンストラクタ関数

キャメルケース（小文字から始める記法）を用いる．プロパティを生成するためには，値を格納する必要がある．関数宣言あるいは関数式で記述する．パスカルケース（大文字から始める記法）を用いる．ちなみに，オブジェクトのプロパティ値として生成された関数を，メソッドと呼ぶ．

**＊実装例＊**

```javascript
const example = new Object({

    // 慣習的にアンダーバーでprivateを表す．
    _property: 0,
  
    set setValue(value) {
        this._property = value;
    },  
    
    get getValue() {
        return this._property;
    }
})
```

#### ・```Function```コンストラクタ関数

**＊実装例＊**

```javascript
const Example = new Function();
```

ただし，公式からこのような記法は，非推奨とされている．以下の関数宣言，関数式，アロー関数による関数式省略，の記法が推奨される．

**＊実装例＊**

```javascript
// 関数宣言
function Example() {
    
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;

    // プロパティ値として宣言した関数を，メソッドという．
    this.setValue = function(value) {
        this._property = value;
    };   
  
    this.getValue = function(){
        return this._property;
    };
}

// コール
const Example = new Example();
```

```javascript
// 関数式
const Example = function(value) {
    
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;
  
    this.setValue = function(value) {
        this._property = value;
  };
  
    this.getValue = function() {
        return this._property;
    };
}

// アロー関数による関数式の省略記法
const Example = (value) => {
    
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;
  
    this.setValue = function(value) {
        this._property = value;
  };
  
    this.getValue = function() {
        return this._property;
    };
}
```

リテラル表記と```Object```コンストラクタ関数による生成とは異なり，コンストラクタ関数によって宣言されたオブジェクトは，暗示的に```prototype```プロパティをもつ．

**＊実装例＊**

```javascript
// リテラル表記による生成
const object1 = {};

// Objectコンストラクタ関数による生成
const object2 = new Object({});

// ユーザ宣言Functionコンストラクタ関数による生成
const Object3 = function(){};

// 出力結果
console.log(
    object1.prototype, // undefined
    object2.prototype,  // undefined
    Object3.prototype // Object3 {}
);
```

<br>

### 糖衣構文の```class```の使用

ES6から，糖衣構文の```class```によって，オブジェクトを宣言できるようになった．クラス宣言あるいはクラス式で記述する．オブジェクトの生成時，```constructor()```でオブジェクトの初期化を行う．パスカルケース（大文字から始める記法）を用いる．

**＊実装例＊**

```javascript
// クラス宣言
class Example {
    
    // classでしか使えない．
    // Setterの代わりにコンストラクタでImmutableを実現．
    // データの宣言と格納が同時に行われる．
    constructor(value) {
        this.property = value;
    }
    
    getValue() {
        return this.property;
    }
}
```

```javascript
// クラス式
const Example = class {
    
    // classでしか使えない．
    // Setterの代わりにコンストラクタでImmutableを実現．
    // データの宣言と格納が同時に行われる．
    constructor(value) {
        this._property = value;
    }
    
    getValue() {
        return this._property;
    }
}
```

```javascript
// 生成，初期化
const example = new Example(1)
```

<br>

## 02-02. オブジェクトの操作

### プロトタイプチェーンによる継承

#### ・プロトタイプチェーンとは

オブジェクトが暗示的に持つ```prototype```プロパティに，別のオブジェクトのメンバを追加することによって，そのオブジェクトのプロトタイプを継承することができる．オブジェクトからプロパティやメソッドをコールした時，そのオブジェクトにこれらが存在しなければ，継承元まで辿る仕組みを『プロトタイプチェーン』という．クラスベースのオブジェクト指向で用いられるクラスチェーンについては，別ノートを参照せよ．

#### ・```new Obejct()```を用いた継承

**＊実装例＊**

```javascript
// 大元となるオブジェクトは個別ファイルで管理しておくのがベター．
// コンストラクタ関数の関数式による宣言．
const Example = function(value) {
  
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;
  
    this.setValue = function(value) {
        this._property = value;
  }  
  
    this.getValue = function() {
        return this._property;
    };
}
```

別クラスで，以下のように継承する．

**＊実装例＊**

```javascript
// 継承元のオブジェクトのファイルを読み込むことも忘れずに．
// prototypeプロパティの継承先のオブジェクトを宣言．
const SubExample = function(subValue) {
    
    // 慣習的にアンダーバーでprivateを表す．
    this.subProperty = subValue;
  
    this.setSubValue = function(subValue) {
        this.subProperty = subValue;
  }  
  
    this.getSubValue = function() {
        return this.subProperty;
    };
}

// new Example()を用いた継承．
SubExample.prototype = new Example();

// SubExampleクラスにはgetValue()は無い．
// 継承元まで辿り，Examlpeクラスからメソッドがコールされる（プロトタイプチェーン）．
const result = SubExample.getValue()
console.log(result);
```

#### ・```Object.create()```を用いた継承とメンバ追加

**＊実装例＊**

```javascript
// 継承元のオブジェクトのファイルを読み込むことも忘れずに．
// prototypeプロパティの継承先のオブジェクトを宣言．
const SubExample = function() {
    
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;
  
    this.setSubValue = function(subValue) {
        this.subProperty = subValue;
    };
  
    this.getSubValue = function() {
        return this.subProperty;
    };
};

// Object.create()を用いた継承．
SubExample.prototype = Object.create(Example.prototype);

// SubExampleクラスにはgetValue()は無い．
// 継承元まで辿り，Examlpeクラスからメソッドがコールされる（プロトタイプチェーン）．
const result = SubExample.getValue();
console.log(result);
```

また，```Object.create()```を用いる場合，継承だけでなく，メンバを新しく追加することもできる．

**＊実装例＊**

```javascript
// Object.create()による継承．
SubExample.prototype = Object.create(Example.prototype, {

    // データを定義
    subProperty: "テスト"
    
    // メソッドを定義
    printSubValue: function() {
        return 'これは' + this.subProperty + 'です．';
    }
  
});

// SubExampleクラスにはprintSubValue()が追加された．
const result = SubExample.printSubValue();
console.log(result);
```

<br>

## 02-03. ```this```の参照先

### メソッドとしてコールする場合

メソッド内の```this```は，exampleオブジェクトを指す．

**＊実装例＊**

```javascript
const example = {
  
  // 慣習的にアンダーバーでprivateを表す．
  _property: 0,
  
    set setValue(value) {
        this._property = value;
    },  
    
    get getValue() {
        return this._property;
    }
}	
```

```javascript
// メソッド内のthisは，exampleオブジェクトを指す．
example.setValue(1);
example.getValue(); // 1
```

<br>

### コンストラクタ関数としてコールする場合

#### ・関数宣言と関数式によるコンストラクタ関数内の```this```の場合

コンストラクタ関数内のthisは，自身がコールされたオブジェクトを指す．

**＊実装例＊**

```javascript
// 一番外側はWindowオブジェクト
param = 'global param';

// 関数宣言
function printParam(){
  console.log(this.param);
}

// オブジェクト1
const object1 = {
  param: 'object1 param',
  func: printParam
}

// オブジェクト2
const object2 = {
  param: 'object2 param',
  func: printParam
}
```

```javascript
/* コンストラクタ関数内のthisの場合
コンストラクタ関数内のthisは，自身がコールされたオブジェクトを指す．
ここでは，object1とobject2
*/

object1.printParam; // object1 param
object2.printParam; // object2 param
```

#### ・アロー関数によるコンストラクタ関数内の```this```の場合

アロー関数内の```this```の参照先には，十分な注意が必要である．今まで，JavaScriptでは，```this```の参照先が文脈によって変わることに批判が集まっていた．そこで，参照先が文脈によって変わらない機能が追加された．```this```は，自身が宣言されたオブジェクトを指す．

**＊実装例＊**

```javascript
// 一番外側はWindowオブジェクト
param = 'global param';

// アロー関数による省略記法
const printParam = () => {
  console.log(this.param);
};

// オブジェクト1
const object1 = {
  param: 'object1 param',
  func: printParam
};

// オブジェクト2
const object2 = {
  param: 'object2 param',
  func: printParam
}
```

```javascript
/* アロー関数内のthisの場合
thisは，自身が宣言されたオブジェクトを指す．
ここでは，一番外側のWindowオブジェクト．
参照先は文脈によって変わらない．
*/

object1.printParam; // global param
object2.printParam; // global param
```

また，アロー関数がコールバック関数の引数となっている場合…（要勉強）

<br>

## 03. 関数

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



## 04. データ型

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

## 05. 変数

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

```console.log()```を実行した場合，```x```を宣言していないため，「x is not defined 」エラーになりそうだが，```x```に値が代入されていないことを示す「undefined」となる．

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

```let```，```const```の場合は，巻き上げは起こらない．

```javascript
console.log(x); // x is not defined

let x = 'hoge';
```

