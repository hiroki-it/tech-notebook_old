# プロトタイプベースのオブジェクト指向

## 01-01. オブジェクトの生成，初期化

### :pushpin: リテラル表記の使用

オブジェクトをリテラル表記で生成する方法．キャメルケース（小文字から始める記法）を用いる．

```javascript
// リテラル表記
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



### :pushpin: コンストラクタ関数の使用

#### ・```Object```コンストラクタ関数

キャメルケース（小文字から始める記法）を用いる．プロパティを生成するためには，値を格納する必要がある．関数宣言あるいは関数式で記述する．パスカルケース（大文字から始める記法）を用いる．ちなみに，オブジェクトのプロパティ値として生成された関数を，メソッドと呼ぶ．

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

```javascript
const Example = new Function();
```

ただし，公式からこのような記法は，非推奨とされている．以下の関数宣言，関数式，アロー関数による関数式省略，の記法が推奨される．

```javascript
// 関数宣言
function Example() {
    
    // 慣習的にアンダーバーでprivateを表す．
    _property = 0;

    // プロパティ値として定義した関数を，メソッドという．
    this.setValue = function(value) {
        this._property = value;
    };   
  
    this.getValue = function(){
        return this._property;
    };
}
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

リテラル表記と```Object```コンストラクタ関数による生成とは異なり，コンストラクタ関数によって定義されたオブジェクトは，暗示的に```prototype```プロパティをもつ．

```javascript
// リテラル表記による生成
const object1 = {};

// Objectコンストラクタ関数による生成
const object2 = new Object({});

// ユーザ定義Functionコンストラクタ関数による生成
const Object3 = function(){};

// 出力結果
console.log(
    object1.prototype, // undefined
    object2.prototype,  // undefined
    Object3.prototype // Object3 {}
);
```



### :pushpin: 糖衣構文の```class```の使用

ES6から，糖衣構文の```class```によって，オブジェクトを定義できるようになった．クラス宣言あるいはクラス式で記述する．オブジェクトの生成時，```constructor()```でオブジェクトの初期化を行う．パスカルケース（大文字から始める記法）を用いる．

```javascript
// クラス宣言
class Example {
    
    // classでしか使えない．
    // Setterの代わりにコンストラクタでImmutableを実現．
    // データの定義と格納が同時に行われる．
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
    // データの定義と格納が同時に行われる．
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



## 01-02. オブジェクトの操作

### :pushpin: 継承とプロトタイプチェーン

オブジェクトが暗示的に持つ```prototype```プロパティに，別のオブジェクトのメンバを追加することによって，そのオブジェクトのプロトタイプを継承することができる．オブジェクトからプロパティやメソッドをコールした時，そのオブジェクトにこれらが存在しなければ，継承元まで辿る仕組みを『プロトタイプチェーン』という．クラスベースのオブジェクト指向で用いられるクラスチェーンについては，別ノートを参照せよ．

#### ・```new Obejct()```を用いた継承

```javascript
// 大元となるオブジェクトは個別ファイルで管理しておくのがベター．
// コンストラクタ関数の関数式による定義．
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

```javascript
// 継承元のオブジェクトのファイルを読み込むことも忘れずに．
// prototypeプロパティの継承先のオブジェクトを定義．
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

// new Object()を用いた継承．
SubExample.prototype = new Object();

// SubExampleクラスにはgetValue()は無い．
// 継承元まで辿り，Examlpeクラスからメソッドがコールされる（プロトタイプチェーン）．
var result = SubExample.getValue()
console.log(result);
```

#### ・```Object.create()```を用いた継承とメンバ追加

```javascript
// 継承元のオブジェクトのファイルを読み込むことも忘れずに．
// prototypeプロパティの継承先のオブジェクトを定義．
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
var result = SubExample.getValue();
console.log(result);
```

また，```Object.create()```を用いる場合，継承だけでなく，メンバを新しく追加することもできる．

```javascript
// Object.create()による継承．
SubExample.prototype = Object.create(Example.prototype, {

    // メソッドを追加する．
    this.printSubValue = function() {
        return 'これは' + this.subProperty + 'です．';
    };
  
});

// SubExampleクラスにはprintSubValue()が追加された．
var result = SubExample.printSubValue();
console.log(result);
```



## 01-03. ```this```の参照先

### :pushpin: メソッドとしてコールする場合

メソッド内の```this```は，exampleオブジェクトを指す．

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



### :pushpin: コンストラクタ関数としてコールする場合

#### ・関数宣言と関数式によるコンストラクタ関数内の```this```の場合

コンストラクタ関数内のthisは，自身がコールされたオブジェクトを指す．

```javascript
param = 'global param';

// 関数宣言
function printParam(){
  console.log(this.param);
}

let object = {
  param: 'object param',
  func: printParam
}

let object2 = {
  param: 'object2 param',
  func: printParam
}
```

```javascript
// コンストラクタ関数内のthisの場合
object.printParam; // param

object2.printParam; // param

// コンストラクタ関数内のthisは，自身がコールされたオブジェクトを指す．ここでは，objectとobject2．
```

#### ・アロー関数によるコンストラクタ関数内の```this```の場合

アロー関数内の```this```の参照先には，十分な注意が必要である．今まで，JavaScriptでは，```this```の参照先が文脈によって変わることに批判が集まっていた．そこで，参照先が文脈によって変わらない機能が追加された．```this```は，自身が定義されたオブジェクトを指す．

```javascript
param = 'global param';

// アロー関数による省略記法
let printParam = () => {
  console.log(this.param);
};

let object = {
  param: 'object param',
  func: printParam
};

let object2 = {
  param: 'object2 param',
  func: printParam
}
```

```javascript
// アロー関数内のthisの場合
object.printParam; // global param

object2.printParam; // global param

// thisは，自身が定義されたオブジェクトを指す．ここでは，一番外側のWindowオブジェクト．
// 参照先は文脈によって変わらない．
```

また，アロー関数がコールバック関数の引数となっている場合…（要勉強）
