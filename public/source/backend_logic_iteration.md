

# 繰り返しロジック

## 01. 繰り返し処理

### ```foreach()```

#### ・いずれかの配列の要素を返却する場合

単に配列を作るだけでなく，要素にアクセスするためにも使われる．

```PHP
<?php

class Example
{
    // $options配列には，OptionA,B,Cエンティティのいずれかが格納されていると想定
    public function checkOption(array $options)
    {
        $result = "";
        
        foreach ($options as $option) {
            
            if ($option->name() === 'オプションA') {
                $result = 'オプションAが設定されています．';
                return $result;
            }
            
            if ($option->name() === 'オプションB') {
                $result = 'オプションBが設定されています．';
                return $result;
            }
            
            if ($option->name() === 'オプションC') {
                $result = 'オプションCが設定されています．';
                return $result;
            }
            
            return $result;
        }
        
        return $result;
    }
}
```

<br>

### 多次元配列の走査

#### ・二次元配列を一次元配列に変換

コールバック関数の使用が必要になる．```call_user_func_array```メソッドの第一引数に，コールバック関数の```array_merge```メソッドの文字列を渡し，第二引数に二次元配列を渡す．その結果，平坦になって一次元配列になる．例えば，不要なインデックス（0）で入れ子になっている場合に役に立つ．

```PHP
<?php
$oneD = call_user_func_array(
            'array_merge',
            // 二次元配列
            $twoD
            );
```

#### ・多次元配列でキー名から値を取得

例えば，以下のような多次元配列があったとする．

```PHP
<?php
$array = [
    [
        "date"  => "2015/11/1",
        "score" => 100,
        "color" => "red",
    ],
    [
        "date"  => "2015/11/2",
        "score" => 75,
        "color" => "blue",
    ],
    [
        "date"  => "2015/11/3",
        "score" => 90,
        "color" => "green",
    ],
];

// この配列の```score```キーから値を取り出し，一次元配列を生成する．
array_column($array, "score");

// Array
// (
//     [0] => 100
//     [1] => 75
//     [2] => 90
// )
```

<br>

### 無限ループ

反復処理では，何らかの状態になった時に反復処理を終えなければならない．しかし，終えることができないと，無限ループが発生してしまう．

#### ・```break```

```PHP
<?php
// 初期化
$i = 0;
while ($i < 4) {
    
    echo $i;
    
    // 改行
    echo PHP_EOL;
}
```

#### ・```continue```

<br>

### 反復を含む流れ図における実装との対応

『N個の正負の整数の中から，正の数のみの合計を求める』という処理を行うとする．

#### ・```for()```

![流れ図_for文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/流れ図_for文.png)

```PHP
<?php
$a = [1, -1, 2];
$sum = 0;

for ($i = 0; $i < 2; $i++) {
    $x = $a[$i];
    if ($x > 0) {
        $sum += $x;
    }
}
```

#### ・```while()```

![流れ図_while文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/流れ図_while文.png)

```PHP
<?php
$a = [1, -1, 2];
$sum = 0;

// 反復数の初期値
$i = 0;

while ($i < 2) {
    $x = $a[$i];
    if ($x > 0) {
        $sum += $x;
    }
    $i += 1;
}
```

#### ・```foreach()```

![流れ図_foreach文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/流れ図_foreach文.png)

```PHP
<?php
$a = [1, -1, 2];
$sum = 0;

foreach ($a as $x) {
    if ($x > 0) {
        $sum += $x;
    }
}
```

