# バックエンド側の検証ロジック

## 01. 検証

### 検証の必要性の有無

#### ・不要な場合

データベースから取得した後に直接表示する値の場合，データベースでNullにならないように制約をかけられる．そのため，値が想定通りの状態になっているかを改めて検証する必要はない．

#### ・必要な場合

データベースからの値を直接表示する場合と異なり，新しく作られる値を用いる場合，その値が想定外の状態になっている可能性がある．そのため，値が想定通りの状態になっているかを検証する必要がある．検証パターンについては，後述の説明を参考にせよ．

<br>

### 検証パターンと検証メソッドの対応

〇：```TRUE```

✕：```FALSE```

フロントエンドの検証については以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/frontend_logic_validation.html

| 検証パターン           | ```isset($var)```，```!is_null($var)``` |           ```if($var)```，```!empty($var)```            |
| :--------------------- | :-------------------------------------: | :-----------------------------------------------------: |
| **```null```**         |                    ✕                    |                            ✕                            |
| **```0```**            |                 **〇**                  |                            ✕                            |
| **```1```**            |                 **〇**                  |                         **〇**                          |
| **```""```**（空文字） |                 **〇**                  |                            ✕                            |
| **```"あ"```**         |                 **〇**                  |                         **〇**                          |
| **```array(0)```**     |                 **〇**                  |                            ✕                            |
| **```array(1)```**     |                 **〇**                  |                         **〇**                          |
| **使いどころ**         |     ```null```だけを検証したい場合      | ```null```，```0```，```""```，```[]```を検証したい場合 |

<br>

## 02. 条件式

### if-elseif-else ，switch-case-break

**＊実装例＊**

曜日を検証し，文字列を出力する．

#### ・if-elseif-else

**＊実装例＊**

```php
<?php
// 変数に Tue を格納
$weeks = "Tue";

// if文でTueに該当したら"火曜日"と表示する．
if ($weeks == "Mon") {
    echo "月曜日";
} elseif ($weeks == "Tue") {
    echo "火曜日";
} elseif ($weeks == "Wed") {
    echo "水曜日";
} elseif ($weeks == "Thu") {
    echo "木曜日";
} elseif ($weeks == "Fri") {
    echo "金曜日";
} elseif ($weeks == "Sat") {
    echo "土曜日";
} else {
    echo "日曜日";
}

// 実行結果
// 火曜日
```

#### ・switch-case-break

定数ごとに処理が変わる時，こちらの方が可読性が高い．

**＊実装例＊**

```php
<?php

// 変数に Tue を格納
$weeks = "Tue";

// 条件分岐でTueに該当したら"火曜日"と表示する．breakでif文を抜けなければ，全て実行されてしまう．
switch ($weeks) {
    case "Mon":
        echo "月曜日";
        break;
    case "Tue":
        echo "火曜日";
        break;
    case "Wed":
        echo "水曜日";
        break;
    case "Thu":
        echo "木曜日";
        break;
    case "Fri":
        echo "金曜日";
        break;
    case "Sat":
        echo "土曜日";
        break;
    case "Sun":
        echo "日曜日";
        break;
    default:
        echo "曜日がありません";
}

// 実行結果
// 火曜日
```

<br>

### if-elseの回避方法

#### ・if-elseを用いた場合

可読性が悪いため，避けるべき．

**＊実装例＊**

```php
<?php

class Example
{
    /**
     * マジックナンバー
     */
    const noOptionItem = 0;

    /**
     * @var Entity
     */
    private $routeEntity;

    public function example($result)
    {

        // RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
        if (!empty($this->routeEntity->options)) {
            foreach ($this->routeEntity->options as $option) {

                // if文を通過した場合，メソッドの返却値が格納される．
                // 通過しない場合，定数が格納される．
                if ($option->isOptionItemA()) {
                    $result["optionItemA"] = $option->optionItemA();
                } else {
                    $result["optionItemA"] = self::noOptionItem;
                }

                if ($option->isOptionItemB()) {
                    $result["optionItemB"] = $option->optionItemB();
                } else {
                    $result["optionItemB"] = self::noOptionItem;
                }

                if ($option->isOptionItemC()) {
                    $result["optionItemC"] = $option->optionItemC();
                } else {
                    $result["optionItemC"] = self::noOptionItem;
                }
            }
        }

        return $result;
    }
}
```

#### ・三項演算子を用いた場合

よりすっきりした書き方になる．

**＊実装例＊**

```php
<?php

class Example
{
    /**
     * マジックナンバー
     */
    const noOptionItem = 0;

    /**
     * @var Entity
     */
    private $routeEntity;

    public function example($result)
    {
        // RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
        if (!empty($this->routeEntity->options)) {
            foreach ($this->routeEntity->options as $option) {

                // if文を通過した場合，メソッドの返却値が格納される．
                // 通過しない場合，定数が格納される．
                $result["optionItemA"] = ($option->isOptionItemA())
                  ? $option->optionItemA()
                  : self::noOptionItem;

                $result["optionItemB"] = ($option->isOptionItemB())
                  ? $option->optionItemB()
                  : self::noOptionItem;

                $result["optionItemC"] = ($option->isOptionItemC())
                  ? $option->optionItemC()
                  : self::noOptionItem;
            };
        }

        return $result;
    }
}
```

#### ・初期値と上書きのロジックを用いた場合

よりすっきりした書き方になる．

**＊実装例＊**

```php
<?php

class Example
{
    /**
     * マジックナンバー
     */
    const noOptionItem = 0;

    /**
     * @var Entity
     */
    private $routeEntity;

    public function example($result)
    {
        // 初期値0を設定
        $result["optionItemA"] = self::noOptionItem;
        $result["optionItemB"] = self::noOptionItem;
        $result["optionItemC"] = self::noOptionItem;
    
        // RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す．
        if(!empty($this->routeEntity->options)) {
            foreach ($this->routeEntity->options as $option) {
            
                // if文を通過した場合，メソッドの返却値によって初期値0が上書きされる．
                // 通過しない場合，初期値0が用いられる．
                if ($option->isOptionItemA()) {
                    $result["optionItemA"] = $option->optionItemA();
                }
            
                if ($option->isOptionItemB()) {
                    $result["optionItemB"] = $option->optionItemB();
                }
            
                if ($option->isOptionItemC()) {
                    $result["optionItemC"] = $option->optionItemC();
                }
            };
        }
    
        return $result;
    }
}

```

<br>

### if-elseif-elseの回避方法

#### ・決定表を用いた条件分岐の整理

**＊実装例＊**

うるう年であるかを検証し，文字列を出力する．以下の手順で設計と実装を行う．

1. 条件分岐の処理順序の概要を日本で記述する．
2. 記述内容を，条件部と動作部に分解し，決定表で表す．
3. 決定表を，流れ図で表す．

![決定表](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/決定表.png)

#### ・if-elseif-elseは用いない

可読性が悪いため，避けるべき．

**＊実装例＊**

```php
<?php
// 西暦を格納する．
$year = N;
```

```php
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

#### ・ifとreturnを用いた早期リターン

各if文で```return```を用いることで，```if```が入れ子状になることを防ぐことができる．これを，早期リターンともいう．

**＊実装例＊**

```php
<?php
    
// 西暦を格納する．
$year = N;
    
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

#### ・switch-case-breakを用いた早期リターン

if文の代わりに，```switch-case-break```によって，実装に，『◯◯の場合に切り換える』という意味合いを持たせられる．ここでは，メソッドに実装することを想定して，```break```ではなく```return```を用いている．

**＊実装例＊**

```php
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

```php
<?php
    
function leapYear(int $year): string
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

```php
<?php

class Example {};

if(new Example == new Example){
    echo "同じです";
} else { echo "異なります"; }

// 実行結果
// 同じです
```

#### ・イコールが3つの場合

同じオブジェクトから別々に作られたインスタンスであっても，『異なるもの』として認識される．

**＊実装例＊**

```php
<?php
    
class Example {};

if (new Example === new Example) {
    echo "同じです";
} else {
    echo "異なります";
}

// 実行結果
// 異なります
```

同一のインスタンスの場合のみ，『同じもの』として認識される．

**＊実装例＊**

```php
<?php
    
class Example {};

$a = $b = new Example;

if ($a === $b) {
    echo "同じです";
} else {
    echo "異なります";
}

// 実行結果
// 同じです
```

<br>

## 03. エラーキャッチ，例外スロー，ロギング

### エラーとロギングのコツ

#### ・エラーの種類

プログラムの実行が強制停止されるランタイムエラー，停止せずに続行される非ランタイムエラー，に分類される．

#### ・データベースにとって

データベース更新系の処理の途中にエラーが発生すると，データベースが中途半端な更新状態になってしまう．そのため，エラーをキャッチし，これをきっかけにロールバック処理を実行する必要がある．なお，下流クラスのエラーの内容自体は握りつぶさずに，スタックトレースとして上流クラスでロギングしておく．

#### ・システム開発者にとって

エラーが画面上に返却されたとしても，これはシステム開発者にとってわかりにくい．そのため，エラーをキャッチし，システム開発者にわかる言葉に変換した例外としてスローする必要がある．なお，下流クラスのエラー自体は握りつぶさずに，スタックトレースとして上流クラスでロギングしておく．

#### ・ユーザにとって

エラーが画面上に返却されたとしても，ユーザにとっては何が起きているのかわからない．また，エラーをキャッチし，例外としてスローしたとしても，システム開発者にとっては理解できるが，ユーザにとっては理解できない．そのため，例外スローをさらに上流クラスに持ち上げ，最終的には，これをポップアップなどでわかりやすく通知する必要がある．これらは，サーバサイドのtry-catch-finally文や，フロントエンドのポップアップ処理で実現する．なお，下流クラスのエラー自体は握りつぶさずに，スタックトレースとして上流クラスでロギングしておく．

<br>

### スローされる例外

#### ・標準例外クラス

参考：https://www.php.net/manual/ja/spl.exceptions.php

#### ・独自例外クラス

エラーの種類に合わせて，```Exception```クラスを継承した独自例外クラスを実装し，使い分けるとよい．

**＊実装例＊**

「Example変数が見つからない」というエラーに対応する例外クラスを定義する．

```php
<?php

class ExampleNotFoundException extends Exception
{
    // 基本的に何も実装しない．
}
```

```php
<?php

use Exception\ExampleNotFound;

function example(string $example) {
    
    if (empty($exmaple)) {
        throw new ExampleNotFoundException("Example is not found.");
    }
    
    return "これは ${example} です．";
}
```
<br>

### エラーのキャッチ

#### ・if-throw文

特定の処理の中に，想定できる例外があり，それを例外クラスとしてするために用いる．ここでは，全ての例外クラスの親クラスである```Exception```クラスのインスタンスを投げている．

**＊実装例＊**

```php
<?php

function value(int $value) {
    
    if (empty($value)) {
        // 例外クラスを返却
        throw new Exception("Value is empty");
    }
    
    return "これは ${value} です．";
}
```

ただし，if-throwでは，都度例外を検証するがあり，様々な可能性を考慮しなければいけなくなる．

```php
<?php
    
function value() {
    
    if (...) {
        throw new ExternalApiException();
    }
    
    if (...) {
        throw new ExampleInvalidArgumentException();
    }
        
    return "成功です．"
}
```

#### ・try-catch-finally文とは

try-catch-finallyでは，特定の処理の中で起こる想定できない例外を捉えることができる．定義されたエラー文は，デバック画面に表示される．

**＊実装例＊**

```php
<?php

use \Exception\ExternalApiErrorException;
use \Exception\HttpRequestErrorException;

class Example
{
    public function sendMessage(Message $message)
    {
        try {

            // ExternalApiErrorException，HttpRequestErrorException，Exceptionが起こる

        } catch (ExternalApiErrorException $exception) {

            // ExternalApiErrorExceptionが起こったときの処理

        } catch (HttpRequestErrorException $exception) {

            // HttpRequestErrorExceptionが起こったときの処理

        } catch (Exception $exception) {

            // その他（自社システムなど）のExceptionが起こっときの処理

        } finally {

            // どの例外をcatchした場合でも必ず行われる
            // try句やcatch句の返却処理や終了処理が行われる直前に実行される．

        }
    }
}

```

#### ・finally句の仕様

finally句は，try句やcatch句の返却処理が行われる直前に実行されるため，finally句では，```return```や```continue```を使用しないようにする．

```php
<?php

use Exception\ExternalApiErrorException;
use Exception\HttpRequestErrorException;

class Example
{
    public function sendMessage(Message $message)
    {
        try {

            // （１）
            echo "Aの直前です";
            return "Aです．";
            
        } catch (ExternalApiErrorException $exception) {

            // （２）
            echo "Bの直前です";
            return "Bです．";
            
        } catch (HttpRequestErrorException $exception) {

            // （３）
            echo "Cの直前です";
            return "Cです．";
            
        } catch (Exception $exception) {

            // （４）
            echo "Dの直前です";
            return "Dです．";
            
        } finally {

            // returnやcontinueを使用しない
            echo "Eです．";

        }
    }
}
```


（１）～（４）のいずれかで返却される時，返却の直前にfinally句が実行されることがわかる．
```php
// （１）の場合
// Aの直前です．
// Eです．
// Aです．

// （２）の場合
// Bの直前です．
// Eです．
// Bです．

// （３）の場合
// Cの直前です．
// Eです．
// Cです．

// （４）の場合
// Dの直前です．
// Eです．
// Dです．
```

<br>

### ロギング

#### ・エラー処理関数

PHPには標準で，エラー処理関数が用意されている．その中でも，```error_log```メソッドをよく使う．

参考：https://www.php.net/manual/ja/ref.errorfunc.php

```php
error_log(
    "<エラーメッセージ>",
    "<メッセージの出力先（3の場合にファイル出力）>",
    "<ログファイルの場所>"
)
```

**＊実装例＊**

```php
<?php

class Notification
{
    public function sendMessage()
    {
        try {

            // 下流クラスによる例外スローを含む処理

        } catch (\exception $exception) {

            error_log(
                sprintf(
                    "ERROR: %s at %s line %s",
                    $exception->getMessage(),
                    $exception->getFile(),
                    $exception->getLine()
                ),
                3,
                __DIR__ . "/error.log"
            );
        }
    }
}
```
他に，Loggerインターフェースを使用することも多い．

参考：https://github.com/php-fig/log

```php
<?php

use Psr\Log\LoggerInterface;

class Notification
{
    private $logger;

    public function __construct(LoggerInterface $logger = null)
    {
        $this->logger = $logger;
    }

    public function sendMessage()
    {
        try {

            // 下流クラスによる例外スローを含む処理

        } catch (\exception $exception) {

            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));
        }
    }
}
```

#### ・例外スローごとのロギング

例えば，メッセージアプリのAPIに対してメッセージ生成のリクエストを送信する時，例外処理に合わせて，外部APIとの接続失敗によるエラーログを生成と，自社システムなどその他原因によるエラーログを生成を行う必要がある．

**＊実装例＊**

```php
<?php

use Exception\ExternalApiErrorException;
use Exception\HttpRequestErrorException;

class Example
{
    public function sendMessage(Message $message)
    {
        try {

            // 外部APIのURL，送信方法，トークンなどのパラメータが存在するかを検証．
            // 外部APIのためのリクエストメッセージを生成．
            // 外部APIのURL，送信方法，トークンなどのパラメータを設定．

        } catch (\HttpRequestErrorException $exception) {
            
            // 下流クラスによる例外スローを含む処理

            // 外部APIとの接続失敗によるエラーをロギング
            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));

        } catch (\ExternalApiErrorException $exception) {
            
            // 下流クラスによる例外スローを含む処理

            // 外部APIのシステムエラーをロギング
            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));

        } catch (\Exception $exception) {
            
            // 下流クラスによる例外スローを含む処理

            // その他（自社システムなど）によるエラーをロギング
            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));
        }

        // 問題なければTRUEを返却．
        return true;
    }
}
```

