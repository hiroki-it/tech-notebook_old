# 勉強の方針

1. 必ず、実例として、それが扱われているのかを覚えること。
2. 必ず、言葉ではなく、イラストを用いて覚えること。
3. 必ず、知識の『点』と『点』を繋ぎ、『線』にしろ
4. 必ず、まとめることでインプットしているだけなので、口頭で説明してアプトプットしろ。
5. キタミ式で大枠をとらえて、過去問で肉付けしていく。



# 17-01. データ型の実装

プログラムを書く際にはどのような処理を行うのかを事前に考え、その処理にとって最適なデータ構造で記述する必要がある。そのためにも、それぞれのデータ構造の特徴（長所、短所）を知っておくことが重要である。

### ◇ Object型

```
Fruit Object
(
	[id:private] => 1
	[name:private] => リンゴ
	[price:private] => 100
)	
```



### ◇ Array型

- **多次元配列**

  中に配列をもつ配列のこと。配列の入れ子構造が２段の場合、『二次元配列』と呼ぶ。

```
Array
( 
    [0] => Array
        (
            [0] => リンゴ
            [1] => イチゴ
            [2] => トマト
        )

    [1] => Array
        (
            [0] => メロン
            [1] => キュウリ
            [2] => ピーマン
        )
)
```

- **連想配列**

  中に配列をもち、キーに名前がついている（赤、緑、黄、果物、野菜）ような配列のこと。下の例は、二次元配列かつ連想配列である。

```
Array
(
    [赤] => Array
        (
            [果物] => リンゴ
            [果物] => イチゴ
            [野菜] => トマト
        )

    [緑] => Array
        (
            [果物] => メロン
            [野菜] => キュウリ
            [野菜] => ピーマン
        )
)
```



### ◇ List型

ポインタは、次のデータがどこにあるかのアドレスを表す。

- **単方向リスト**

![p555-1](C:\Projects\Summary_Notes\まとめノート\画像\p555-1.gif)

- **双方向リスト**

![p555-2](C:\Projects\Summary_Notes\まとめノート\画像\p555-2.gif)

- **循環リスト**

![p555-3](C:\Projects\Summary_Notes\まとめノート\画像\p555-3.gif)



### ◇ Queue型

phpでは、```array_push()```と```array_shift()```で実装可能。

![Queue1](C:\Projects\Summary_Notes\まとめノート\画像\Queue1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 

![Queue2](C:\Projects\Summary_Notes\まとめノート\画像\Queue2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 

![Queue3](C:\Projects\Summary_Notes\まとめノート\画像\Queue3.gif)



### ◇ Stack

phpでは、```array_push()```と```array_pop()```で実装可能。

![Stack1](C:\Projects\Summary_Notes\まとめノート\画像\Stack1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 

![Stack2](C:\Projects\Summary_Notes\まとめノート\画像\Stack2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 

![Stack3](C:\Projects\Summary_Notes\まとめノート\画像\Stack3.gif)

### ◇ ツリー構造

- **二分探索木**

  各ノードにデータが格納されている。

![二分探索木](C:\Projects\Summary_Notes\まとめノート\画像\二分探索木1.gif)



- **ヒープ**

  Priority Queueを実現するときに用いられる。各ノードにデータが格納されている。

  ![ヒープ1](C:\Projects\Summary_Notes\まとめノート\画像\ヒープ1.gif)

  ![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![ヒープ1](C:\Projects\Summary_Notes\まとめノート\画像\ヒープ2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![ヒープ2](C:\Projects\Summary_Notes\まとめノート\画像\ヒープ3.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![ヒープ3](C:\Projects\Summary_Notes\まとめノート\画像\ヒープ4.gif)



# 17-02. データ整列の概念

例えば、次のような表では、どのような仕組みで「昇順」「降順」への並び替えが行われるのだろうか。

![ソートの仕組み](C:\Projects\Summary_Notes\まとめノート\画像\ソートの仕組み.gif)



### ◇ 基本交換法（バブルソート）

隣り合ったデータの比較と入替えを繰り返すことによって，小さな値のデータを次第に端のほうに移していく方法。

![バブルソート1](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![バブルソート2](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 

![バブルソート3](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート3.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![バブルソート4](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート4.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![バブルソート5](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート5.gif)



![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

 



![バブルソート6](C:\Projects\Summary_Notes\まとめノート\画像\バブルソート6.gif)



### ◇ 基本選択法（選択ソート）

データ中の最小値を求め，次にそれを除いた部分の中から最小値を求める。この操作を繰り返していく方法。

![選択ソート1](C:\Projects\Summary_Notes\まとめノート\画像\選択ソート1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![選択ソート2](C:\Projects\Summary_Notes\まとめノート\画像\選択ソート2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![選択ソート3](C:\Projects\Summary_Notes\まとめノート\画像\選択ソート3.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![選択ソート4](C:\Projects\Summary_Notes\まとめノート\画像\選択ソート4.gif)

### ◇ 基本挿入法（挿入ソート）

既に整列済みのデータ列の正しい位置に，データを追加する操作を繰り返していく方法。

### ◇ ヒープソート



### ◇ シェルソート



### ◇ クイックソート

適当な基準値を選び，それより小さな値のグループと大きな値のグループにデータを分割する。同様にして，グループの中で基準値を選び，それぞれのグループを分割する。この操作を繰り返していく方法。

![クイックソート-1](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-1.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-2](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-2.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-3](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-3.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-4](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-4.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-5](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-5.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-6](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-6.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-7](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-7.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-8](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-8.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-9](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-9.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-10](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-10.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-11](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-11.JPG)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![クイックソート-12](C:\Projects\Summary_Notes\まとめノート\画像\クイックソート-12.JPG)



# 17-03. データ探索の概念

### ◇ 線形探索法

  今回は「６」を探す。

![線形探索法1](C:\Projects\Summary_Notes\まとめノート\画像\線形探索法1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![線形探索法2](C:\Projects\Summary_Notes\まとめノート\画像\線形探索法2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![線形探索法3](C:\Projects\Summary_Notes\まとめノート\画像\線形探索法3.gif)

### ◇ 二分探索法

  前提として、ソートによって、すでにデータが整列させられているとする。今回は「６」を探す。

![二分探索法1](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法1.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![二分探索法2](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法2.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![二分探索法3](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法3.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![二分探索法4](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法4.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![二分探索法5](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法5.gif)

![矢印_80x82](C:\Projects\Summary_Notes\まとめノート\画像\矢印_80x82.jpg)

![二分探索法6](C:\Projects\Summary_Notes\まとめノート\画像\二分探索法6.gif)

### ◇ ハッシュ法











# 17-04.  TRUE vs. FALSE

### ◇ FALSE の定義

- **表示なし**

- **キーワード FALSE false**

- **整数 0**

- **浮動小数点 0.0**

- **空の文字列 " "**

- **空の文字列 ' '**

- **文字列 "0"（文字列としての0）**

- **要素数が 0 の配列$ary = array();**

- **プロパティーやメソッドを含まない空のオブジェクト**

- **NULL値**

  

### ◇ TRUE の定義

上記の値以外は、全て TRUE



### ◇ 変数に値が入っているのかを確かめるシリーズ

![値が存在するのかを確かめる](C:\Projects\Summary_Notes\まとめノート\画像\値が存在するのかを確かめる.jpg)

```
# 右辺には、上記に当てはまらない状態『TRUE』が置かれている。
if($this->$var == TRUE){
	処理A;
}

# ただし、基本的に右辺は省略すべき。

if($this->$var){
	処理A;
}
```



# 17-05. 条件式の実装方法

### ◇ 『else』はできるだけ用いない

- **『else』を用いる場合**

冗長になってしまう。

```
// マジックナンバーを定義
noOptionItem = 0;

// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す。
if(!empty($routeEntity->options) {
    foreach ($routeEntity->options as $option) {
    
    	// if文を通過した場合、メソッドの返り値が格納される。通過しない場合、マジックナンバー0が格納される。
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
```

- **初期値と上書きのロジックを用いる場合**

よりすっきりした書き方になる。

```
// マジックナンバーを定義
noOptionItem = 0;

// 初期値0を設定
$result['optionItemA'] = noOptionItem;
$result['optionItemB'] = noOptionItem;
$result['optionItemC'] = noOptionItem;

// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す。
if(!empty($routeEntity->options) {
    foreach ($routeEntity->options as $option) {
    
    	// if文を通過した場合、メソッドの返り値によって初期値0が上書きされる。通過しない場合、初期値0が用いられる。
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
```



### ◇ エラー文

エラー文は、『ログファイル』に出力される。if文を通過してしまった理由は、empty()でTRUEが返ったためである。empty()がFALSEになるように、デバッグする。

```
if (empty($value)) {
	throw new Exception('Variable is empty');
}
return $value
```



# 17-06.   『Java』 について

### ◇ Javaで書かれているプログラム

- **Java Applet**

Javaで書かれたWebのフロントエンドで動くプログラム。Java9より非推奨になり、Java 11で廃止。

![Java Applet](C:\Projects\Summary_Notes\まとめノート\画像\Java Applet.gif)



- **Java Servlet**

Javaで書かれたWebのサーバーエンドで動くプログラム。

![Java Servlet](C:\Projects\Summary_Notes\まとめノート\画像\Java Servlet.gif)



### ◇ Garbage collection

Javaでは、Javaオブジェクトに対するメモリ領域の割り当てや解放をJVM（Java仮想マシン）が自動的に行う。この自動解放メカニズムを『Garbage collection』という。