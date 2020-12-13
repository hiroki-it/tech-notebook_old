# プロトタイプベースのオブジェクト指向プログラミング（１）


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

ただし，公式からこのような記法は，非推奨とされている．以下の関数宣言，関数式，アロー関数による関数式省略，の記法が推奨される．特にアロー関数では，```this```が宣言されたオブジェクト自身を指すため，保守性が高くおすすめである．

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
ここでは，一番外側のWindowオブジェクトであり，object1とobject2ではない．
参照先は文脈によって変わらない．
*/

object1.printParam; // global param
object2.printParam; // global param
```

また，アロー関数がコールバック関数の引数となっている場合…（要勉強）
