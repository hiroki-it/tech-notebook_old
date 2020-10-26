# バックエンド側の検証ロジック

## 01. 検証

### 検証が必要な場合とは

データベースから取得した後に直接表示する値の場合，データベースでNullにならないように制約をかけられるため，変数の中身に例外検証を行う必要はない．しかし，データベースとは別に新しく作られる値の場合，バリデーションと例外検証が必要になる．

### 検証ロジックの比較

〇：```TRUE```

✕：```FALSE```

|                    | ```isset($var)```，```!is_null($var)``` |           ```if($var)```，```!empty($var)```            |
| :----------------- | :-------------------------------------: | :-----------------------------------------------------: |
| **```null```**     |                    ✕                    |                            ✕                            |
| **```0```**        |                 **〇**                  |                            ✕                            |
| **```1```**        |                 **〇**                  |                         **〇**                          |
| **```""```**       |                 **〇**                  |                            ✕                            |
| **```"あ"```**     |                 **〇**                  |                         **〇**                          |
| **```array(0)```** |                 **〇**                  |                            ✕                            |
| **```array(1)```** |                 **〇**                  |                         **〇**                          |
| **使いどころ**     |     ```null```だけを検証したい場合      | ```null```，```0```，```""```，```[]```を検証したい場合 |

<br>

## 02. 条件式

### ```if```-```elseif```-```else``` ，```switch```-```case```-```break```

**＊実装例＊**

曜日を検証し，文字列を出力する．

#### ・```if```-```elseif```-```else```

**＊実装例＊**

```PHP
<?php
// 変数に Tue を格納
$weeks = 'Tue';

// if文でTueに該当したら'火曜日'と表示する．
if ($weeks == 'Mon') {
    echo '月曜日';
} elseif ($weeks == 'Tue') {
    echo '火曜日';
} elseif ($weeks == 'Wed') {
    echo '水曜日';
} elseif ($weeks == 'Thu') {
    echo '木曜日';
} elseif ($weeks == 'Fri') {
    echo '金曜日';
} elseif ($weeks == 'Sat') {
    echo '土曜日';
} else {
    echo '日曜日';
}

// 実行結果
// 火曜日
```

#### ・```switch```-```case```-```break```

定数ごとに処理が変わる時，こちらの方が可読性が高い．

**＊実装例＊**

```PHP
<?php
// 変数に Tue を格納
$weeks = 'Tue';
 
// 条件分岐でTueに該当したら'火曜日'と表示する．breakでif文を抜けなければ，全て実行されてしまう．
switch ($weeks) {
  case 'Mon':
    echo '月曜日';
    break;
  case 'Tue':
    echo '火曜日';
    break;
  case 'Wed':
    echo '水曜日';
    break;
  case 'Thu':
    echo '木曜日';
    break;
  case 'Fri':
    echo '金曜日';
    break;
  case 'Sat':
    echo '土曜日';
    break;
  case 'Sun':
    echo '日曜日';
    break;
  default:
    echo '曜日がありません';  
}

// 実行結果
// 火曜日
```

<br>

### ```if```-```else```の回避方法

#### ・```if```-```else```を用いた場合

可読性が悪いため，避けるべき．

**＊実装例＊**

```PHP
<?php
// マジックナンバーを使わずに，定数として定義
const noOptionItem = 0;

function (){
// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
    if (!empty($routeEntity->options)) {
        foreach ($routeEntity->options as $option) {
            
            // if文を通過した場合，メソッドの返却値が格納される．
            // 通過しない場合，定数が格納される．
            if ($option->isOptionItemA()) {
                $result['optionItemA'] = $option->optionItemA();
            } else {
                $result['optionItemA'] = noOptionItem;
            }
            
            if ($option->isOptionItemB()) {
                $result['optionItemB'] = $option->optionItemB();
            } else {
                $result['optionItemB'] = noOptionItem;
            }
            
            if ($option->isOptionItemC()) {
                $result['optionItemC'] = $option->optionItemC();
            } else {
                $result['optionItemC'] = noOptionItem;
            }
        };
    }
    
    return $result;
}
```

#### ・三項演算子を用いた場合

よりすっきりした書き方になる．

**＊実装例＊**

```PHP
<?php
// マジックナンバーを使わずに，定数として定義
const noOptionItem = 0;

function ($result)
{
// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
    if (!empty($routeEntity->options)) {
        foreach ($routeEntity->options as $option) {
    
            // if文を通過した場合，メソッドの返却値が格納される．
            // 通過しない場合，定数が格納される．
            $result['optionItemA'] = ($option->isOptionItemA()) 
              ? $option->optionItemA() 
              : noOptionItem;
    
            $result['optionItemB'] = ($option->isOptionItemB()) 
              ? $option->optionItemB() 
              : noOptionItem;
    
            $result['optionItemC'] = ($option->isOptionItemC()) 
              ? $option->optionItemC() 
              : noOptionItem;
        };
    }
    
    return $result;
}
```

#### ・初期値と上書きのロジックを用いた場合

よりすっきりした書き方になる．

**＊実装例＊**

```PHP
<?php
// マジックナンバーを使わずに，定数として定義
const noOptionItem = 0;

function ($result)
{
    // 初期値0を設定
    $result['optionItemA'] = noOptionItem;
    $result['optionItemB'] = noOptionItem;
    $result['optionItemC'] = noOptionItem;

    // RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
    if(!empty($routeEntity->options)) {
        foreach ($routeEntity->options as $option) {
            
            // if文を通過した場合，メソッドの返却値によって初期値0が上書きされる．
            // 通過しない場合，初期値0が用いられる．
            if ($option->isOptionItemA()) {
                $result['optionItemA'] = $option->optionItemA();
            }
            
            if ($option->isOptionItemB()) {
                $result['optionItemB'] = $option->optionItemB();
            }
            
            if ($option->isOptionItemC()) {
                $result['optionItemC'] = $option->optionItemC();
            }
        };
    }
    
    return $result;
}

```

<br>

### ```if```-```elseif```-```else```の回避方法

#### ・決定表を用いた条件分岐の整理

**＊実装例＊**

うるう年であるかを検証し，文字列を出力する．以下の手順で設計と実装を行う．

1. 条件分岐の処理順序の概要を日本で記述する．
2. 記述内容を，条件部と動作部に分解し，決定表で表す．
3. 決定表を，流れ図で表す．

![決定表](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/決定表.png)

#### ・```if```-```elseif```-```else```は用いない

可読性が悪いため，避けるべき．

**＊実装例＊**

```PHP
<?php
// 西暦を格納する．
$year = N;
```

```PHP
<?php
function leapYear(int $year): string
{
    // (5)
    if ($year <= 0) {
        throw new Exception("負の数は検証できません．");

    // (4)
    } elseif ($year % 4 != 0) {
        return "平年";

    // (3)
    } elseif ($year % 100 != 0) {
        return "うるう年";

    // (2)
    } elseif ($year % 400 != 0) {
        return "平年";

    // (1)
    } else {
        return "うるう年";
    }
}
```

#### ・```if```と```return```を用いた早期リターン

```return```を用いることで，```if```が入れ子状になることを防ぐことができる．これを，早期リターンともいう．

**＊実装例＊**

```PHP
<?php
// 西暦を格納する．
$year = N;
```

```PHP
<?php
function leapYear(int $year): string
{
    // (5)
    if($year <= 0){
        throw new Exception("負の数は検証できません．");
    }

    // (4)
    if($year % 4 != 0 ){
        return "平年";
    }

    // (3)
    if($year % 100 != 0){
        return "うるう年";
    }

    // (2)
    if($year % 400 != 0){
        return "平年";
    }

    // (1)
    return "うるう年";
    
}
```

#### ・```switch```-```case```-```break```を用いた早期リターン

```switch```-```case```-```break```によって，実装に，『◯◯の場合に切り換える』という意味合いを持たせられる．ここでは，メソッドに実装することを想定して，```break```ではなく```return```を用いている．

**＊実装例＊**

```PHP
<?php
function leapYear(int $year): string
{   
    switch(true) {
    
    // (5)
    case($year <= 0):
        throw new Exception("負の数は検証できません．");

    // (4)
        case($year % 4 != 0 ):
        return "平年";

    // (3)
    case($year % 100 != 0):
        return "うるう年";

    // (2)
    case($year % 400 != 0):
        return "平年";

    // (1)
    dafault:
        return "うるう年";
    }

}
```

#### ・ガード節を用いた早期リターン

早期リターンのif文の波括弧を省略した記法を，ガード節という．

**＊実装例＊**

```PHP
<?php
public function leapYear(int $year): string
{
    // (5)
    if($year <= 0) throw new Exception("負の数は検証できません．");

    // (4)
    if($year % 4 != 0 ) return "平年";

    // (3)
    if($year % 100 != 0) return "うるう年";

    // (2)
    if($year % 400 != 0) return "平年";

    // (1)
    return "うるう年";
    
}
```

<br>

## 02-02. インスタンスの検証

### 等価演算子

#### ・イコールが2つの場合

同じオブジェクトから別々に作られたインスタンスであっても，『同じもの』として認識される．

**＊実装例＊**

```PHP
<?php
class Example {};

if(new Example == new Example){
    echo '同じです';
} else { echo '異なります'; }

// 実行結果
// 同じです
```

#### ・イコールが3つの場合

同じオブジェクトから別々に作られたインスタンスであっても，『異なるもの』として認識される．

**＊実装例＊**

```PHP
<?php
class Example {};

if (new Example === new Example) {
    echo '同じです';
} else {
    echo '異なります';
}

// 実行結果
// 異なります
```

同一のインスタンスの場合のみ，『同じもの』として認識される．

**＊実装例＊**

```PHP
<?php
class Example {};

$a = $b = new Example;

if ($a === $b) {
    echo '同じです';
} else {
    echo '異なります';
}

// 実行結果
// 同じです
```

<br>

## 03. 例外処理とロギング

### 例外クラスと例外スロー

#### ・Exceptionクラスを継承した独自例外クラス

**＊実装例＊**

```PHP
<?php

// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
    // インスタンスが作成された時に実行される処理
    public function __construct()
    {
        parent::__construct("HTTPリクエストに失敗しました", 400);
    }
    
    // 新しいメソッドを定義
    public function example()
    {
        // なんらかの処理;
    }
}
```

#### ・```if```-```throw```文

特定の処理の中に，想定できる例外があり，それをエラー文として出力するために用いる．ここでは，全ての例外クラスの親クラスであるExceptionクラスのインスタンスを投げている．

**＊実装例＊**

```PHP
<?php
if (empty($value)) {
    throw new Exception('Variable is empty');
}

return $value;
```

<br>

### ```try```-```catch```文

#### ・単なる```if```-```throw```文との違い

何らかの処理の合間全てに```if```-```throw```を行うと，様々な可能性を考慮しなければいけなくなる．

```php
<?php

// WebAPIの接続に失敗した場合
if (...){
    throw new WebAPIException();
}

if (...){
    throw new HttpRequestException();
}
```

そこで，特定の処理の中で起こる想定できない例外を捉え，エラー文として出力するために用いる．定義されたエラー文は，デバック画面に表示される．

**＊実装例＊**

```PHP
<?php
    
// try文で指定のExceptionが投げられた時に，指定のcatch文に入る
try {


// あらかじめ出力するエラーが設定されている独自例外クラス（以下参照）
} catch (WebAPIException $exception) {
    
    
} catch (HttpRequestException $exception) {

    
// Exceptionクラスはtry文で生じた全ての例外をキャッチしてしまうため，最後に記述するべき．
} catch (Exception $exception) {


// 正常と例外にかかわらず，必ず実行される．
} finally {
    // 正常と例外にかかわらず，必ずファイルを閉じるための処理
}
```

以下，上記で使用した独自の例外クラス．

**＊実装例＊**

```PHP
<?php
    
// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
    // インスタンスが作成された時に実行される処理
    public function __construct()
    {
        parent::__construct("HTTPリクエストに失敗しました", 400);
    }
}
```

```PHP
<?php
// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
    // インスタンスが作成された時に実行される処理
    public function __construct()
    {
        parent::__construct("HTTPリクエストに失敗しました", 400);
    }
}
```

<br>

### ロギング

#### ・ロギングの出力分け

例えば，メッセージアプリのAPIに対してメッセージ生成のリクエストを送信する時，例外処理に合わせて，外部APIとの接続失敗によるエラーログを生成と，自社システムなどその他原因によるエラーログを生成を行う必要がある．

**＊実装例＊**

```PHP
<?php

use \Exception\ExternalApiException;
use \Exception\CouldNotSendNotificationException;

class Example
{
    /**
     * @param message $message
     * @return bool
     * @throws ExternalApiException|CouldNotSendMessageException
     */
    public function sendMessage(Message $message)
    {
        // 外部APIのURL，送信方法，トークンなどのパラメータが存在するかを検証．
        
        try {
            
            // 外部APIのためのリクエストメッセージを生成．
            // 外部APIのURL，送信方法，トークンなどのパラメータを設定．
            
        } catch (\ExternalApiException $exception) {
            
            // 外部APIとの接続失敗によるエラーログを生成
            error_log(
                $exception->getMessage(),
                3,
                __DIR__ . '/external_api_error.log'
            );
            
        } catch (\Exception $exception) {
            
            // 自社システムなどその他原因によるエラーログを生成
            error_log(
                $exception->getMessage(),
                3,
                __DIR__ . '/app_error.log'
            );
        }
        
        // 問題なければTRUEを返却．
        return true;
    }
}
```

