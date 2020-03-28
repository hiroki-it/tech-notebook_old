

# 繰り返しロジック

## 01-01. 繰り返し処理

### :pushpin: ```foreach()```

#### ・いずれかの配列の要素を返却する場合

単に配列を作るだけでなく，要素にアクセスするためにも使われる．

```PHP
class Example
{
    
    // $options配列には，OptionA,B,Cエンティティのいずれかが格納されているものとします．
    public function checkOption(Array $options)
    {
        foreach ($options as $option) {
            
            if ($option->name() === 'オプションA') {
                $result = 'オプションAが設定されています．';
            }
            
            if ($option->name() === 'オプションB') {
                $result = 'オプションBが設定されています．';
            }
            
            if ($option->name() === 'オプションC') {
                $result = 'オプションCが設定されています．';
            }
            
        }
        
        return $result;
    }
}
```



#### ・エンティティごとに，データの値を持つか否かが異なる場合



### :pushpin: ```for()```

#### ・要素の位置を繰り返しズラす場合

```PHP
function moveFile($fromPos < $toPos)
{
    if($fromPos < $toPos){
        for($i = fromPos ; $i ≦ $toPos - 1; ++ 1){
            File[$i] = File[$i + 1];
        }
    }
}
```



### :pushpin: 無限ループ

反復処理では，何らかの状態になった時に反復処理を終えなければならない．しかし，終えることができないと，無限ループが発生してしまう．

#### ・```break```

```PHP
// 初期化
$i = 0; 
while($i < 4){
    
    echo $i;
    
    // 改行
    echo PHP_EOL;
}
```

#### ・```continue```



### :pushpin: 反復を含む流れ図における実装との対応

『N個の正負の整数の中から，正の数のみの合計を求める』という処理を行うとする．

#### ・```for()```

![流れ図_for文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/流れ図_for文.png)

```PHP
$a = [1, -1, 2, ..., N];
$sum = 0;

for ($i = 0; $i < N; $i++) {
    $x = $a[$i];
    if ($x > 0) {
        $sum += $x;
    }
}
```

#### ・```while()```

![流れ図_while文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/流れ図_while文.png)

```PHP
$a = [1, -1, 2, ..., N];
$sum = 0;

// 反復数の初期値
$i = 0;

while ($i < N) {
    $x = $a[$i];
    if ($x > 0) {
        $sum += $x;
    }
    $i += 1;
}
```

#### ・```foreach()```

![流れ図_foreach文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/流れ図_foreach文.png)

```PHP
$a = [1, -1, 2, ..., N];
$sum = 0;

foreach ($a as $x) {
    if ($x > 0) {
        $sum += $x;
    }
}
```

