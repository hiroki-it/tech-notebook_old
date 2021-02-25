# Go

## Goとは

手続き型言語．構造体と関数を組み合わせて処理を実装する．言語としてオブジェクトという機能を持っていないが，構造体に関数を関連付けることで，擬似的にオブジェクトを表現することもできる．

<br>

## 擬似的なオブジェクト

### 構造体

```go
type Person struct {
    Name string
    Age  int
}
```

### 関数

```go
func name() string {
    return "Hiroki"
}
```

<br>

### 構造体と関数の関連付け

```go
package main
import "fmt"

// 構造体を定義
type Person struct {
    Name string
}

// 構造体に関数を関連付ける
func (person *Person) name() string {
    return person.Name
}

// 構造体から関数をコール
func main () {
    // 構造体に値を渡す
    person := Person{Name: "Hiroki"}
    fmt.Println(person.name())
}
```



<br>

## データ型

### 配列型

<br>

## 変数

### 定義方法

#### ・明示的な定義

```go
// 一つの変数を定義
var number int
number = 5

// 複数の変数を定義
var x, y, z int
x, y, z = 1, 3, 5
```

#### ・暗黙的な定義（型推論）

```go
// データ型が自動的に認識される
w := 1
x := true
y := 3.14
z := "abc"

var w = 1

var (
    x = true
    y = 3.14
    z = "abc"
)
```

<br>

## 定数

### 定義

<br>

## 





