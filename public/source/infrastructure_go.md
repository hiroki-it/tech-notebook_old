# Go

## 01. Goとは

### 特徴

手続き型言語であり，静的型付け言語．構造体と関数を組み合わせて処理を実装する．言語としてオブジェクトという機能を持っていないが，構造体に関数を関連付けることで，擬似的にオブジェクトを表現することもできる．また，同期処理や非同期処理とは異なり，並列処理で実行される．

### メリット

Goは開発者に実装方法を強制させられるため，可読性が高く，後続者が開発しやすい．また，静的解析のルールが厳しいため，バグを事前に見つけることができる．そのため，実装がスケーリングしやすく，特にバグが許されないような基盤部分に適している．

<br>

### ディレクトリ構造

#### ・```$GOPATH```

パスは好みであるが，```$HOME/go```とすることが多い．ディレクトリ構造のベストプラクティスは以下を参考にせよ．

参考：https://github.com/golang-standards/project-layout

```shell
$GOPATH # 例えば，『$HOME/go』とする．
├── bin
├── pkg
└── src
    ├── build # Dockerfileを配置するディレクトリ
    ├── cmd # main.goファイルや，サブmainパッケージを配置するディレクトリ
    │   ├── main.go
    │   └── example
    │       └── example.go
    │         
    ├── configs
    │   └── envrc.template
    │     
    ├── docs（ドキュメントを配置する）
    │   ├── BUG.md
    │   ├── ROUTING.md
    │   └── TODO.md
    │     
    ├── internal # cmdディレクトリ内でインポートさせないファイルを配置するディレクトリ
    │   └── pkg
    │ 
    ├── pkg # cmdディレクトリ内でインポートする独自goパッケージを配置するディレクトリ
    │   └── public
    │       └── add.go
    │     
    ├── scripts
    │   └── Makefile
    │     
    ├── test
    │   └── test.go
    │     
    └── web（画像，CSS，など）
        ├── static
        └── template
```

#### ・```bin```

ビルドされたアーティファクト（バイナリファイル）を配置するディレクトリ．バイナリファイル名を指定すると，処理を実行できる．

#### ・```pkg```

アーティファクトとは別に生成されるファイルを配置するディレクトリ

#### ・```src```

ソースコードを配置するディレクトリ

#### ・ディレクトリ名，ファイル名の命名規則

ディレクトリ名に関して，ビルド時にシンタックスエラーとなる可能性があるため，可能な限りハイフンを使用しない方が良い．

参考：https://zenn.dev/keitakn/articles/go-naming-rules

<br>

### ファイルの要素

#### ・package

名前空間として，パッケージ名を定義する．一つのディレクトリ内では，一つのパッケージ名しか宣言できない．

```go
package main
```

#### ・import

ビルトインパッケージ，内部パッケージ，事前にインストールされた外部パッケージを読み込む．

```go
import "<パッケージ名>"
```

#### ・func

詳しくは，関数を参考にせよ．

```go
func xxx() {

}
```

#### ・文の区切り

Goでは文の処理はセミコロンで区切られる．ただし，セミコロンはコンパイル時に補完され，実装時には省略できる．

<br>

## 01-02. コマンド

### install

#### ・オプション無し

ソースコードと外部パッケージに対して```build```コマンドを実行し，```$GOPATH```以下の```bin```ディレクトリまたは```pkg```ディレクトリにインストール（配置）する．内部または外部のソースコードからビルドされたアーティファクト（バイナリファイル）であれば```bin```ディレクトリに配置し，それ以外（例：```.a```ファイル）であれば```pkg```ディレクトリに配置する．

```shell
$ go install
```

<br>

### get

#### ・オプション無し

指定したパスからパッケージをダウンロードし，これに対して```install```コマンドを実行する．これにより，内部または外部のソースコードからビルドされたアーティファクト（バイナリファイル）であれば```bin```ディレクトリに配置し，それ以外（例：```.a```ファイル）であれば```pkg```ディレクトリに配置する．

```shell
$ go get <ドメインをルートとしたURL>
```

<br>

### build

#### ・オプション無し

指定したパスをビルド対象として，ビルドのアーティファクトを生成する．

```shell
# cmdディレクトリをビルド対象として，ルートディレクトリにcmdアーティファクトを生成する．
$ go build ./cmd
```

#### ・```-o```

指定したパスにビルドのアーティファクトを生成する．ビルド対象パスを指定しない場合，ルートディレクトリのgoファイルをビルドの対象とする．

```shell
# ルートディレクトリ内のgoファイルをビルド対象として
# $HOME/go/binディレクトリにルートディレクトリ名アーティファクトを生成する．
$ go build -o $HOME/go/bin
```

また，指定したパス内のgoファイルをビルド対象として，指定したパスにビルドのアーティファクトを生成することもできる．

```shell
# cmdディレクトリ内のgoファイルをビルド対象として
# $HOME/go/binディレクトリにcmdアーティファクトを生成する．
$ go build -o $HOME/go/bin ./cmd
```

 ちなみに，事前のインストールに失敗に，ビルド対象が存在していないと，以下のようなエラーになる．

```shell
package xxxxx is not in GOROOT (/usr/local/go/src/xxxxx)
```

<br>

### env

#### ・オプション無し

Goに関する環境変数を出力する．

**＊実装例＊**

```shell
$ go env

# go.modの有効化
GO111MODULE="on"
# コンパイラが実行されるCPUアーキテクチャ
GOARCH="amd64"
# installコマンドによるアーティファクトを配置するディレクトリ（指定無しの場合，$GOPATH/bin）
GOBIN=""
GOCACHE="/root/.cache/go-build"
GOENV="/root/.config/go/env"
GOEXE=""
GOFLAGS=""
GOHOSTARCH="amd64"
# コンパイラが実行されるOS
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/go/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
# ソースコードが配置されるディレクトリ
GOPATH="/go"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
# Go本体を配置するディレクトリ
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
# c言語製のライブラリの有効化．無効化しないと，vetコマンドが失敗する．
CGO_ENABLED="0"
GOMOD="/go/src/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build887404645=/tmp/go-build -gno-record-gcc-switches"
```

<br>

### fmt

#### ・オプション無し

指定したパスのファイルのインデントを整形する．パスとして『```./...```』を指定して，再帰的に実行するのがおすすめ．

```shell
$ go fmt ./...
```

<br>

### vet

#### ・オプション無し

指定したパスのファイルに対して静的解析を行う．パスとして『```./...```』を指定して，再帰的に実行するのがおすすめ．

```shell
$ go vet ./...
```

<br>

### test

#### ・オプション無し

指定したパスのファイルで『```Test```』から始まるテスト関数を実行する．testディレクトリ内を再帰的に実行するのがおすすめ．

```shell
$ go test ./test/...
```

#### ・-v

テスト時にテストの実行時間を出力する．

```shell
$ go test -v ./test/...
```

#### ・-cover

テスト時にテストの網羅率を出力する．

```shell
$ go test -cover ./test/...
```

<br>

## 02. データ型

### データ型の種類

#### ・データ型の初期値

データ型には，値が代入されていない時，初期値が代入されている．

#### ・基本型に属するデータ型

| データ型 | 表記                   | 初期値             |
| -------- | ---------------------- | ------------------ |
| 数値     | ```int```，```float``` | ```0```            |
| 文字列   | ```string```           | ```""```（空文字） |
| 真偽値   | ```boolean```          | ```false```        |

#### ・合成型に属するデータ型

| データ型 | 表記         | 初期値 |
| -------- | ------------ | ------ |
| 構造体   | ```struct``` |        |
| 配列     | ```[n]```    |        |

#### ・参照型に属するデータ型

| データ型 | 表記     | 初期値                         |
| -------- | -------- | ------------------------------ |
| ポインタ | ```*```  | ```(nil)```                    |
| スライス | ```[]``` | ```<nil>```（要素数，容量：0） |
| マップ   |          |                                |
| チャネル |          |                                |
| 関数     |          |                                |

<br>

### 基本型のまとめ

####  ・基本型とは

**＊実装例＊**

```go
// 定義（初期値として『0』が割り当てられる）
var number int

// 代入
number = 5
```

#### ・独自の基本型

type宣言を使用して，独自の基本型を定義する．

**＊実装例＊**

int型を元に，Age型を定義する．

```go
type Age int
```

**＊実装例＊**

パッケージの型を元に，MyAppWriter型を定義する．

```go
type MyAppWriter io.Writer
```

#### ・基本型とメモリの関係

基本型の変数を定義すると，データ型のバイト数に応じて，空いているメモリ領域に，変数が割り当てられる．一つのメモリアドレス当たり１バイトに相当する．

![basic-variable_memory](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/basic-variable_memory.png)

#### ・各データ型のサイズ

| 種類                 | 型名       | サイズ(bit)          | 説明                         |
| -------------------- | ---------- | -------------------- | ---------------------------- |
| int（符号付き整数）  | int8       | ```8```              |                              |
|                      | int16      | ```16```             |                              |
|                      | int32      | ```32```             |                              |
|                      | int64      | ```64```             |                              |
|                      | int        | ```32``` or ```64``` | 実装環境によって異なる．     |
| uint（符号なし整数） | uint8      | ```8```              |                              |
|                      | uint16     | ```16```             |                              |
|                      | unit32     | ```32```             |                              |
|                      | uint64     | ```64```             |                              |
|                      | uint       | ```32``` or ```64``` | 実装環境によって異なる．     |
| float（浮動小数点）  | float32    | ```32```             |                              |
|                      | float64    | ```64```             |                              |
| complex（複素数）    | complex64  | ```64```             | 実部：float32，虚部：float32 |
|                      | complex128 | ```128```            | 実部：float64，虚部：float64 |

<br>

### 構造体

#### ・構造体とは

他の言語でいう『データのみを保持するオブジェクト』に相当する．

**＊実装例＊**

構造体を定義し，変数に代入する．

```go
var person struct {
    Name string
}
```

#### ・独自の構造体

type宣言を使用して，独自のデータ型の構造体を定義する．保持するデータの変数名の頭文字を大文字にした場合は，パッケージ外からのアクセスをパブリックに，小文字にした場合はプライベートになる．

**＊実装例＊**

パブリックなデータを持つ構造体は以下の通り．

```go
type Person struct {
	// パブリック
	Name string
}
```

プライベートなデータを持つ構造体は以下の通り．

```go
type Person struct {
	// プライベート
	name string
}
```

#### ・使用不可のデータ名

小文字の```type```は予約語のため使用不可である．大文字の```Type```は可能．

```go
type Person struct {
	// 定義不可エラー
	type string

	// 定義可能
	Type string
}
```

#### ・初期化

すでに値が代入されている構造体を初期化する場合，いくつか記法がある．その中では，タグ付きリテラルが推奨される．初期化によって構築する構造体は，ポインタ型または非ポインタ型のいずれでも問題ない．ただし，多くの関数がポインタ型を引数型としていることから，それに合わせてポインタ型を構築することが多い．

**＊実装例＊**

まずは，タグ付きリテラル表記．

```go
package main

import "fmt"

type Person struct {
	Name string
}

func main() {
	person := &Person{
		// タグ付きリテラル表記
		Name: "Hiroki",
	}

	fmt.Printf("%#v\n", person.Name) // "Hiroki"
}
```

二つ目に，タグ無しリテラル表記がある．

```go
package main

import "fmt"

type Person struct {
	Name string
}

func main() {
	person := &Person{
		// タグ無しリテラル表記
		"Hiroki",
	}

	fmt.Printf("%#v\n", person.Name) // "Hiroki"
}
```

三つ目に，```new```関数とデータ代入による初期化がある．```new```関数は，データが代入されていない構造体を作成するため，リテラル表記時でも表現できる．```new```関数は，構造体以外のデータ型でも使用できる．ポインタ型の構造体を返却する．

```go
package main

import "fmt"

type Person struct {
	Name string
}

/**
 * 型のコンストラクタ
 * ※スコープはパッケージ内のみとする．
 */
func newPerson(name string) *Person {
    // new関数を使用する．
    // &Person{} に同じ．
	person := new(Person)
	
    // ポインタ型の初期化された構造体が返却される．
	fmt.Printf("%#v\n", person) // &main.Person{Name:""}

	// フィールドに代入する
	person.Name = name

	return person
}

func main() {
	person := newPerson("Hiroki")
	fmt.Printf("%#v\n", person.Name) // "Hiroki"
}
```

#### ・JSONとのマッピング

構造体とJSONの間でパースを実行する時，構造体の各フィールドと，JSONのキー名を，マッピングしておくことができる．

**＊実装例＊**

```go
package main

import (
	"encoding/json"
	"fmt"
	"log"
)

type Person struct {
	Name string `json:"Name"`
}

func main() {
	person := &Person{
		Name: "Hiroki",
	}

	byteJson, err := json.Marshal(person)

	if err != nil {
		log.Println("JSONエンコードに失敗しました。")
	}

	// エンコード結果を出力
	fmt.Printf("%#v\n", string(byteJson)) // "{\"Name\":\"Hiroki\"}"
}
```

#### ・埋め込みによる入れ子構造体

構造体のデータとして，別の構造体を埋め込む．埋め込まれた側の構造体は，データの構造体が持つメソッドをコールできるようになる．埋め込む側の構造体の初期化の記法に癖があるので注意する．

**＊実装例＊**

```go
package main

import "fmt"

// 埋め込む側
type Name struct {
	LastName  string
	FirstName string
}

func (name Name) fullName() string {
	return fmt.Sprintf("%s %s", name.FirstName, name.LastName)
}

// 埋め込まれる側
type Person struct {
	*Name
}

func main() {
	// 埋め込まれた側の構造体の初期化
	person := &Person{
		// 埋め込む側の構造体の初期化
		Name: &Name{
			// タグ付きリテラル表記（タグ無しリテラル表記も可能）
			FirstName: "Hiroki",
			LastName:  "Hasegawa",
		},
	}

	// Person構造体から，Name構造体のメソッドをコールできる．
	fmt.Printf("%#v\n", person.fullName()) // "Hiroki Hasegawa"
}
```

#### ・無名構造体

構造体の定義と初期化を同時に行う．

**＊実装例＊**

```go
package main

import "fmt"

type Person struct {
	Name string
}

func main() {
	person := &struct {
		Name string
	}{
		// タグ付きリテラル表記（タグ無しリテラル表記も可能）
		Name: "Hiroki",
	}

	fmt.Printf("%#v\n", person.Name) // "Hiroki"
}
```

<br>

### 配列

#### ・配列とは

要素，各要素のメモリアドレス，からなるデータのこと．

![aggregate-type_array](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/aggregate-type_array.png)

**＊実装例＊**

配列を定義し，変数に代入する．

```go
package main

import "fmt"

func main() {
	// 定義と代入を同時に行う．また，型推論と要素数省略を行う．
	x := [...]string{"Hiroki", "Gopher"}

	fmt.Printf("%#v\n", x) // [Hiroki Gopher]
	fmt.Printf("%#v\n", x) // [2]string{"Hiroki", "Gopher"}

	// 定義と代入を同時に行う．また，要素数の定義が必要．
	var y [2]string = [2]string{"Hiroki", "Gopher"}

	fmt.Printf("%#v\n", y) // [Hiroki Gopher]
	fmt.Printf("%#v\n", y) // [2]string{"Hiroki", "Gopher"}

	// 定義と代入を別々に行う．また，要素数の定義が必要．
	var z [2]string
	z[0] = "Hiroki"
	z[1] = "Gopher"

	fmt.Printf("%#v\n", z) // [Hiroki Gopher]
	fmt.Printf("%#v\n", z) // [2]string{"Hiroki", "Gopher"}
}
```

#### ・配列とメモリの関係

配列型の変数を定義すると，空いているメモリ領域に，配列がまとまって割り当てられる．一つのメモリアドレス当たり１バイトに相当する．

![array-variable_memory](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/array-variable_memory.png)

<br>

### ポインタ

#### ・ポインタとは

メモリアドレスを代入できるデータ型のこと．定義された変数に対して，&（アンパサンド）を宣言すると，メモリアドレスを抽出できる．抽出したメモリアドレス値は，ポインタ型の変数に代入する必要があるが，型推論で記述すればこれを意識しなくてよい．PHPにおけるポインタは，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_object_orientation_method_data.html

**＊実装例＊**

```go
package main

import "fmt"

func main() {
	x := "a"

	// メモリアドレスを抽出する．
	var p *string = &x
	// p := &x と同じ

	// メモリアドレスを抽出する前
	fmt.Printf("%#v\n", x) // "a"

	// メモリアドレスを抽出した後
	fmt.Printf("%#v\n", p) // (*string)(0xc0000841e0)
}
```

#### ・メモリアドレスに割り当てられたデータ

ポインタ型の変数に対してアスタリスクを宣言すると，メモリアドレスに割り当てられているデータの実体を取得できる．

```go
package main

import "fmt"

func main() {

	x := "a"

	p := &x

	// メモリアドレスの実体を取得する．
	y := *p

	// メモリアドレスを抽出する前
	fmt.Printf("%#v\n", x) // "a"

	// メモリアドレスを抽出した後
	fmt.Printf("%#v\n", p) // (*string)(0xc0000841e0)

	// メモリアドレスに割り当てられたデータ
	fmt.Printf("%#v\n", y) // "a"
}
```

<br>

### スライス

#### ・スライスとは

参照先の配列に対するポインタ，長さ，容量を持つデータ型である．

![reference-types_slice](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/reference-types_slice.png)

```go
// Goのソースコードより
type slice struct {
	array unsafe.Pointer
	len   int
	cap   int
}
```

参考：https://github.com/golang/go/blob/04a4dca2ac3d4f963e3c740045ce7a2959bf0319/src/runtime/slice.go#L13-L17

**＊実装例＊**

```go
package main

import "fmt"

func main() {
	// 定義と代入を同時に行う．
	x := []string{"Hiroki", "Gopher"}

	fmt.Printf("%+v\n", x) // [Hiroki Gopher]
	fmt.Printf("%#v\n", x) // []string{"Hiroki", "Gopher"}

	// 定義と代入を同時に行う．また，型推論を行う．
	var y []string = []string{"Hiroki", "Gopher"}

	fmt.Printf("%+v\n", y) // [Hiroki Gopher]
	fmt.Printf("%#v\n", y) // []string{"Hiroki", "Gopher"}
}
```

全てのスライスが共通の配列を参照しているため，例えば，```xb```変数しか上書きしていないのにもかかわらず，他のスライスにもその上書きが反映される．

```go
package main

import "fmt"

func main() {
	// 最後の要素の後にもカンマが必要である．
	x := [5]string{"あ", "い", "う", "え", "お"}
	fmt.Printf("%#v\n", x) // [5]string{"あ", "い", "う", "え", "お"}

	xa := x[0:3]
	fmt.Printf("%#v\n", xa) // []string{"あ", "い", "う"}

	xb := x[2:5]
	fmt.Printf("%#v\n", xb) // []string{"う", "え", "お"}

	// xbスライスの0番目（"う"）を上書き
	xb[0] = "Hiroki"

	// xbしか上書きしていないが，他のスライスにも反映される．
	fmt.Printf("%#v\n", xa) // []string{"あ", "い", "Hiroki"}
	fmt.Printf("%#v\n", xb) // []string{"Hiroki", "え", "お"}
	fmt.Printf("%#v\n", x)  // [5]string{"あ", "い", "Hiroki", "え", "お"}
}
```

#### ・配列の参照

**＊実装例＊**

バイト配列を参照する．

```go
package main

import "fmt"

func main() {
	x := []byte("abc")

	fmt.Printf("%+v\n", x) // [97 98 99]
	fmt.Printf("%#v\n", x) // []byte{0x61, 0x62, 0x63}
}
```

構造体配列を参照する．

```go
package main

import "fmt"

type Person struct {
	Name string
}

func main() {
	person := []Person{{Name: "Hiroki"}}

	fmt.Printf("%+v\n", person) // [{Name:Hiroki}]
	fmt.Printf("%#v\n", person) // []main.Person{main.Person{Name:"Hiroki"}}
}
```

<br>

### インターフェース

####  ・埋め込み

インターフェースを構造体に埋め込むことにより，構造体をインターフェースの実装として扱うことができる．

**＊実装例＊**

InspectImpl構造体にAnimalインターフェースを埋め込み，構造体に```Eat```メソッド，```Sleep```メソッド，```Mating```メソッド，の実装を強制する．

```go
package main

import "fmt"

// インターフェースとそのメソッドを定義する．
type AnimalInterface interface {
	Name()
	Eat()
	Sleep()
}

// 構造体にインターフェースを埋め込む．インターフェースのメソッドの関連付けが強制される．
type InsectImpl struct {
	AnimalInterface
	name string
}

type FishImpl struct {
	AnimalInterface
	name string
}

type MammalImpl struct {
	AnimalInterface
	name string
}

// コンストラクタ
func NewInsect(name string) (*InsectImpl, error) {
	return &InsectImpl{
		name: name,
	}, nil
}

// 構造体に関数を関連付ける．
func (insect InsectImpl) GetName() string {
	return insect.Name
}

func (insect InsectImpl) Eat() string {
	return "食べる"
}

func (insect InsectImpl) Sleep() string {
	return "眠る"
}

func main() {
	insect, err := NewInsect("カブトムシ")

	if err != nil {
		fmt.Println(err)
	}

	// メソッドを実行する．
	fmt.Println(insect.GetName())
	fmt.Println(insect.Eat())
	fmt.Println(insect.Sleep())
}
```

もし，構造体に関連付けられたメソッドに不足があると，エラーが起こる．

```shell
# Eatメソッドを関連付けていない場合
cannot use insect (type Insect) as type Animal in assignment:
Insect does not implement Animal (missing Eat method)
```

#### ・他のデータ型からの変換

様々な値をインターフェース型として定義でき，これらをインターフェースに変換できる．

**＊実装例＊**

```go
var x interface{}

x = 1
x = 3.14
x = "Hiroki"
x = [...]unit8{1, 2, 3, 4, 5}

fmt.Printf("%#v\n", x)
// 1
// 3.14
// "Hiroki"
// [5]uint8{0x1, 0x2, 0x3, 0x4, 0x5}
```

なお，インターフェース型データは演算できない．

```go
var x, y interface{}

x,y = 1, 2

// エラーになる．
z := x + y
```

<br>

### nil

#### ・nilとは

いくつかのデータ型における初期値のこと．

#### ・ポインタの場合

**＊実装例＊**

```go
package main

import "fmt"

func main() {

	x := "x"

	// ポインタ型の定義のみ
	var p1 *string

	// ポインタ型の変数を定義代入
	var p2 *string = &x

	fmt.Printf("%#v\n", p1) // (*string)(nil)
	fmt.Printf("%#v\n", p2) // (*string)(0xc0000841e0)
}
```

####  ・インターフェースの場合

**＊実装例＊**

```go
package main

import "fmt"

func main() {
	var x interface{}

	fmt.Printf("%#v\n", x) // <nil>
}
```

<br>

## 03. 関数

### main関数

#### ・```main```関数とは

goのエントリポイントとなる．goのプログラムが起動したときに，各パッケージの```init```関数が実行された後，```main```関数が実行される．```main```関数をビルド対象に指定すると，これを起点として読み込まれるファイルが枝分かれ状にビルドされていく．ステータス『0』でプロセスを終了する．

**＊実装例＊**

```go
package main

import "fmt"

func main() {
	fmt.Printf("%#v\n", "Hello world!")
}
```

当然，```main```パッケージや```main```関数が無いと，goのプログラムの起動時にエラーが発生する．

```shell
$ go run server.go

go run: cannot run non-main package
```

```shell
$ go run server.go

# command-line-arguments
runtime.main: call to external function main.main
runtime.main: main.main: not defined
runtime.main: undefined: main.main
```

<br>

### 独自関数

#### ・関数とは

構造体に関連付けられていない関数のこと．

**＊実装例＊**

```go
package main

import "fmt"

// 頭文字を大文字する
func Example(x string) string {
	fmt.Println(x)
}

func main() {
	Example("Hello world!")
}
```

#### ・Closure（無名関数）とは

名前のない関数のこと．

#### ・即時関数とは

定義したその場でコールされる無名関数のこと．

**＊実装例＊**

main関数で即時関数を実行する．

```go 
package main

import "fmt"

func main() {
	result := func() string {
		return "Closure is working!"
	}()

	fmt.Printf("%#v\n", result)
}
```

**＊実装例＊**

即時関数に引数を設定できる．その場合，仮引数と引数の両方を設定する必要がある．

```go
package main

import "fmt"

func main() {
	// 仮引数を設定
	result := func(x string) string {

		return x

	}("Closure is working!") // 引数に値を渡す

	fmt.Printf("%#v\n", result)
}
```

<br>

### メソッド

#### ・メソッドとは

データ型や型リテラルに関連付けられている関数のこと．

#### ・レシーバによる関連付け

データ型や型リテラルなどを関数のレシーバとして渡すことによって，それに関数を関連づけられる．関連付け後，関数はメソッドと呼ばれるようになる．メソッド名とデータ名に同じ名前は使用できない．

**＊実装例＊**

int型を値レシーバとして渡し，構造体に関数を関連付ける．

```go
package main

import "fmt"

type Age int

func (age Age) PrintAge() string {
    return fmt.Sprintf("%dです．", age)
}

func main() {
    var age Age = 20
    
    fmt.Printf("%#v\n", age.printAge())
}
```

**＊実装例＊**

構造体を値レシーバとして渡し，構造体に関数を関連付ける．

```go
package main

import "fmt"

// 構造体を定義
type Person struct {
	name string
}

// コンストラクタ
func NewPerson(name string) *Person {
	return &Person{
		name: name,
	}
}

// 構造体に関数を関連付ける．
func (person Person) GetName() string {
	return person.name
}

// 構造体から関数をコール
func main() {
	// 構造体を初期化
	person := NewPerson("Hiroki")

	fmt.Printf("%#v\n", person.GetName()) // "Hiroki"
}
```

#### ・値レシーバ

関連付け後，関数はメソッドと呼ばれるようになる．レシーバとして渡された引数をメソッド内でコピーしてから使用する．値レシーバによって関連付けられると，そのメソッドは構造体の状態を変えられなくなるので，構造体をイミュータブルにしたい場合は，値レシーバを使うと良い．

**＊実装例＊**

構造体を値レシーバとして渡し，構造体に関数を関連付ける．

```go
package main

import "fmt"

type Person struct {
	name string
}

// コンストラクタ
func NewPerson(name string) *Person {
	return &Person{
		name: name,
	}
}

// 値レシーバ
func (person Person) SetName(name string) {
	// 引数の構造体をコピーしてから使用
	person.name = name
}

func (person Person) GetName() string {
	return person.name
}

func main() {
	person := NewPerson("Gopher")

	person.SetName("Hiroki")

	fmt.Printf("%#v\n", person.GetName()) // "Gopher"
}
```

#### ・ポインタレシーバ

関連付け後，関数はメソッドと呼ばれるようになる．レシーバとして渡された引数をメソッド内でそのまま使用する．ポインタレシーバによって関連付けられると，そのメソッドは構造体の状態を変えられるようになるので，構造体をミュータブルにしたい場合は，ポインタレシーバを使うと良い．構造体を初期化する処理を持つコンストラクタ関数のみをポインタレシーバとし，他のメソッドを全て値レシーバとすると，最低限にミュータブルなプログラムを実装できる．

**＊実装例＊**

```go
package main

import "fmt"

type Person struct {
	Name string
}

// ポインタレシーバ
func (person *Person) SetName(name string) {
    // 引数の構造体をそのまま使用
	person.Name = name
}

func (person *Person) GetName() string {
    return person.Name
}

func main() {
	person := Person{Name: "Gopher"}

	person.SetName("Hiroki")
    
	fmt.Printf("%#v\n", person.GetName()) // "Hiroki"
}
```

<br>

### defer関数

#### ・defer関数とは

全ての処理の最後に必ず実行される遅延実行関数のこと．たとえ，ランタイムエラーのように処理が強制的に途中終了しても実行される．

**＊実装例＊**

即時関数をdefer関数化している．処理の最後にランタイムエラーが起こったとき，これを```recover```メソッドで吸収できる．

```go
package main

import "fmt"

func main() {
	fmt.Println("Start")

	// あらかじめdefer関数を定義しておく
	defer func() {
		err := recover()

		if err != nil {
			fmt.Printf("Recover: %#v\n", err)
		}

		fmt.Println("End")
	}()

	// ここで意図的に処理を停止させている．
	panic("Runtime error")
}
```

```shell
# 結果
Start
Recover: "Runtime error"
End
```

#### ・複数のdefer関数

deferは複数の関数で宣言できる．複数宣言した場合，後に宣言されたものから実行される．

**＊実装例＊**

```go
package main

import "fmt"

func main() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
}
```

```shell
# 結果
3
2
1
```

<br>

### 返却値

#### ・複数の返却値

**＊実装例＊**

```go
package main

import "fmt"

func division(x int, y int) (int, int) {

	// 商を計算する．
	quotient := x / y

	// 余りを計算する．
	remainder := x % y

	// 商と余りを返却する．
	return quotient, remainder
}

func main() {
	// 10÷3を計算する．
	q, r := division(10, 3)
	fmt.Printf("商=%d，余り=%d", q, r)
}
```

#### ・返却値の破棄

関数から複数の値が返却される時，使わない値をアンダースコアに代入することで，これを破棄できる．

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // errorインターフェースを破棄
    file, _ := os.Open("filename.txt")
    
    // エラーキャッチする必要がなくなる
    fmt.Printf("%#v\n", flle)
}
```

<br>

## 04. 変数

### 定義（宣言＋代入）

#### ・明示的な定義

**＊実装例＊**

```go
// 一つの変数を定義（宣言と代入が同時でない）
var number int
number = 5

// 一つの変数を定義（宣言と代入が同時）
var number int = 5

// 複数の変数を定義
var x, y, z int
x, y, z = 1, 3, 5
```

#### ・暗黙的な定義（型推論）

**＊実装例＊**

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

#### ・再宣言

基本的には，同じスコープ内で既存の変数を再宣言できない．ただし，複数の変数を宣言する時に，いずれかに新しい変数の宣言が含まれていれば，既存の変数を宣言したとしても，代入のみが実行される．

**＊実装例＊**

```go
package main

import (
	"fmt"
)

func main() {
	x := 1

	// 新しい変数の宣言が含まれている
	x, y := 2, 3

	fmt.Printf("%#v\n", x) // 2
	fmt.Printf("%#v\n", y) // 3
}
```

<br>

### 定義位置の種類

#### ・パッケージ変数

関数の外部で定義された変数のこと．スコープとして，宣言されたパッケージ外部でも使用できる．

**＊実装例＊**

パッケージ変数を宣言し，関数内で値を代入する．

```go
package main

import (
    "fmt"
)

// パッケージ変数
var text string

func main() {
    text = "Hello World!"
    fmt.Printf("%#v\n", text)
}
```

変数への値の代入は関数内でしかできないため，宣言と代入を同時に行う型推論を使用するとエラーになる．

```go
package main

import (
    "fmt"
)

// エラーになる．
text := "Hello World!"

func main() {
    fmt.Printf("%#v\n", text)
}
```

#### ・ローカル変数

関数の内部で定義された変数のこと．スコープとして，宣言されたパッケージ内部でしか使用できない．

**＊実装例＊**

```go
package main

import (
    "fmt"
)

func main() {
    // ローカル変数
    text := "Hello World!"
    fmt.Printf("%#v\n", text)
}
```

<br>

## 05. スコープ

### 変数，定数

#### ・パッケージ内外から参照可能

変数名または定数名の頭文字を大文字すると，パッケージ内外でこれをコールできるようになる．

**＊実装例＊**

```go
package example

// 定数を定義する．
const (
	X  = "X"
)
```

```go
package main

import (
    "fmt"
)

func main() {
    fmt.Printf("%#v\n", X) // X
}
```

#### ・パッケージ内のみ参照可能

変数名または定数名の頭文字を小文字すると，パッケージ外でこれをコールできなくなる．

**＊実装例＊**

```go
package main

import (
    "fmt"
)

// 定数を定義する．
const (
	yZ = "yZ"
)

func main() {
    fmt.Printf("%#v\n", yZ) // yZ
}
```

<br>

### 関数

#### ・パッケージ内外から参照可能

関数名の頭文字を大文字すると，パッケージ内外でこれをコールできるようになる．

**＊実装例＊**

```go
package example

func Example() {
    // 何らかの処理
}
```

```go
package main

func main() {
    Example()
}
```

#### ・パッケージ内のみ参照可能

関数名の頭文字を小文字すると，パッケージ外でこれをコールできなくなる．

**＊実装例＊**

```go
package main

func example() {
    // 何らかの処理
}

func main() {
    example()
}
```

<br>

## 06. エラーキャッチ，例外スロー

### Goにおけるエラーキャッチと例外スロー

#### ・例外スローのある言語の場合

例外スローの意義は，以下の参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_logic_validation.html

#### ・Goには例外が無い

例えばPHPでは，エラーをキャッチし，システム開発者にわかる言葉に変換した例外としてスローする．Goには例外クラスに相当するものが無い．その代わり，エラーそのものがerrorインターフェースに保持されており，これを一つの値として扱える．下流で発生したerrorインターフェースを，そのまま上流に返却する．

<br>

### エラーキャッチ

#### ・nilの比較検証

関数から返却されたerrインターフェースが，```nil```でなかった場合に，エラーであると見なすようにする．

```go
if err != nil {
    // 何らかの処理
}
```

<br>

### errorインターフェース

#### ・標準エラー

Goでは複数の値を返却できるため，多くの関数では標準で，最後にerrorインターフェースが返却されるようになっている．errorインターフェースは自動的に```Error```メソッドを実行する．

```go
type error interface {
    Error() string
}
```

**＊実装例＊**

osパッケージの```Open```メソッドからerrorインターフェースが返却される．errorインターフェースはErrorメソッドを自動的に実行し，標準エラー出力に出力する．

```go
package main

import (
	"fmt"
	"log"
	"os"
)

func main() {
	// 処理結果とerrorインターフェースが返却される．
	file, err := os.Open("filename.txt")

	if err != nil {
		// エラーの内容を出力する．
		log.Fatalf("ERROR: %#v\n", err)
	}

	fmt.Printf("%#v\n", flle)
}
```

#### ・```New```関数による独自エラー

errorsパッケージの```New```メソッドにエラーを設定する．これにより，独自のエラーを保持するerrorインターフェースを定義できる．errorインターフェースはErrorメソッドを自動的に実行する．

参考：https://golang.org/pkg/errors/#New

**＊実装例＊**

```go
package main

import (
	"errors"
	"fmt"
	"log"
	"os"
)

func NewError() error {
	return errors.New("<エラーメッセージ>")
}

func main() {
	file, err := os.Open("filename.txt")

	if err != nil {
		// 独自エラーメッセージを設定する．
		myErr := NewError()
		log.Fatalf("ERROR: %#v\n", myErr)
	}

	fmt.Printf("%#v\n", flle)
}
```

#### ・```fmt.Errorf```メソッドによる独自エラー

fmtパッケージの```Errorf```メソッドで独自エラーを作成できる．事前に定義したフォーマットを元にエラーを設定する．これにより，独自のエラーを保持するerrorインターフェースを定義できる．errorインターフェースはErrorメソッドを自動的に実行する．

参考：https://golang.org/pkg/fmt/#Errorf

**＊実装例＊**

```go
package main

import (
	"fmt"
	"os"
)

func main() {

	file, err := os.Open("filename.txt")

	if err != nil {
		fmt.Errorf("ERROR: %s", err)
	}

	fmt.Printf("%#v\n", flle)
}
```

#### ・構造体による独自エラー

構造体に```Error```メソッドを定義すると，これにerrorインターフェースが構造体に自動的に埋め込まれる．これにより，独自のエラーを保持するerrorインターフェースを定義できる．errorインターフェースはErrorメソッドを自動的に実行する．

**＊実装例＊**

```go
package main

import (
	"fmt"
	"os"
)

type Error struct {
	Message string
}

func (error *Error) Error() string {
	return fmt.Sprintf("ERROR: %s", error.Message)
}

func main() {

	file, err := os.Open("filename.txt")

	if err != nil {
		// 構造体に値を設定する．
		myError := &Error{Message: "エラーが発生したため，処理を終了しました．"}
		// 構造体をコールするだけで，Errorメソッドが実行される．
		fmt.Printf("%#v\n", myError)
		os.Exit(1)
	}

	fmt.Printf("%#v\n", flle)
}
```

<br>

### xerrorsパッケージ

#### ・xerrorsパッケージとは

標準のerrorsパッケージには，エラーにスタックトレース情報が含まれていない．xerrorsパッケージによって生成されるerrorインターフェースには，errorインターフェースが返却された行数がスタックトレースとして含まれている．

#### ・```New```関数によるトレース付与

**＊実装例＊**

```go
package main

import (
	"fmt"
	"golang.org/x/xerrors"
	"log"
	"os"
)

func NewErrorWithTrace() error {
	return xerrors.New("<エラーメッセージ>")
}

func main() {
	file, err := os.Open("filename.txt")

	if err != nil {
		// errorインターフェースが返却された行数が付与される．
		errWithStack := NewErrorWithTrace()
		// %+v\n を使用する．
		log.Fatalf("ERROR: %+v\n", errWithStack)
	}

	fmt.Printf("%#v\n", flle)
}
```

#### ・```Errorf```メソッドによるトレース付与

```go
package main

import (
	"fmt"
	"golang.org/x/xerrors"
	"log"
	"os"
)

func main() {

	file, err := os.Open("filename.txt")

	if err != nil {
		// errorインターフェースが返却された行数が付与される．
		errWithStack := xerrors.Errorf("ERROR: %w", err)
		// %+v\n を使用する．
		log.Fatalf("ERROR: %+v\n", errWithStack)
	}

	fmt.Printf("%#v\n", flle)
}
```

<br>

## 06-02. ロギング

### logパッケージ

#### ・logパッケージとは

Goには標準で，ロギング用パッケージが用意されている．ただし，機能が乏しいので，外部パッケージ（例：logrus）も推奨である．

参考：

- https://pkg.go.dev/log
- https://github.com/sirupsen/logrus

#### ・接尾辞```Print```メソッド

引数に渡されたエラーを標準出力に出力する．

**＊実装例＊**

```go
if err != nil {
	log.Printf("ERROR: %#v\n", err)
}
```

#### ・接尾辞```Fatal```メソッド

引数に渡されたエラーを標準出力に出力し，```os.Exit(1)```を実行して，ステータス『1』で処理を終了する．

**＊実装例＊**

```go
if err != nil {
	// 内部でos.Exit(1)を実行する．
	log.Fatalf("ERROR: %#v\n", err)
}
```

#### ・接尾辞```Panic```メソッド

引数に渡されたエラーを標準出力に出力し，予期せぬエラーが起きたと見なして```panic```メソッドを実行する．ちなみに，```panic```メソッドによって，エラーメッセージ出力，スタックトレース出力，処理停止が行われる．

**＊実装例＊**

```go
if err != nil {
    // panicメソッドを実行する．
    log.Panicf("ERROR: %#v\n", err)
}
```

<br>

## 07. 制御文

### 配列またはスライスの走査

#### ・for ... range

配列またはスライスを走査する．PHPの```foreach```に相当する．

```go
package main

import (
	"fmt"
)

func main() {

	slice := []string{"a", "b", "c"}

	for key, value := range slice {
		fmt.Println(key, value)
	}
}

// 0 a
// 1 b
// 2 c
```

<br>

## 08. テスト

### testify

#### ・testifyとは

モック，スタブ，アサーションメソッドを提供するライブラリ．Goではオブジェクトの概念がないため，モックオブジェクトとは言わない．モックとスタブについては，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_testing.html

#### ・モック化

| よく使うメソッド | 説明                                                         |
| ---------------- | ------------------------------------------------------------ |
| なし             | データとして，構造体に```Mock```を設定すれば，その構造体はモック化される． |

**＊実装例＊**

AWSクライアントをモック化する．

```go
package amplify

import (
	"github.com/stretchr/testify/mock"
)

/**
 * AWSクライアントをモック化します．
 */
type MockedAwsClient struct {
	mock.Mock
}
```

#### ・スタブ化

参考：https://pkg.go.dev/github.com/stretchr/testify/mock?tab=versions

| よく使うメソッド              | 説明                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| ```Mock.Called```メソッド     | 関数の一部の処理をスタブ化する時に使用する．関数に値が渡されたことをモックに伝える． |
| ```Arguments.Get```メソッド   | 関数の一部の処理をスタブ化する時に使用する．引数として，返却値の順番を渡す．独自のデータ型を返却する処理を定義する． |
| ```Arguments.Error```メソッド | 関数の一部の処理をスタブ化する時に使用する．引数として，返却値の順番を渡す．エラーを返却する処理を定義する． |

**＊実装例＊**

関数の一部の処理をスタブ化し，これをAWSクライアントのモックに関連付ける．

```go
package amplify

import (
	aws_amplify "github.com/aws/aws-sdk-go-v2/service/amplify"
	"github.com/stretchr/testify/mock"
)

type MockedAmplifyAPI struct {
	mock.Mock
}

/**
 * AmplifyのGetBranch関数の処理をスタブ化します．
 */
func (mock *MockedAmplifyAPI) GetBranch(ctx context.Context, params *aws_amplify.GetBranchInput, optFns ...func(*aws_amplify.Options)) (*aws_amplify.GetBranchOutput, error) {
	arguments := mock.Called(ctx, params, optFns)
	return arguments.Get(0).(*aws_amplify.GetBranchOutput), arguments.Error(1)
}
```

#### ・アサーションメソッドによる検証

参考：

- https://pkg.go.dev/github.com/stretchr/testify/mock?tab=versions

- https://pkg.go.dev/github.com/stretchr/testify/assert?tab=versions

| よく使うメソッド                      | 説明                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| ```Mock.On```メソッド                 | 関数の検証時に使用する．関数内部のスタブに引数として渡される値と，その時の返却値を定義する． |
| ```Mock.AssertExpectations```メソッド | 関数の検証時に使用する．関数内部のスタブが正しく実行されたかどうかを検証する． |
| ```assert.Exactly```メソッド          | 関数の検証時に使用する．期待値と実際値の整合性を検証する．値だけでなく，データ型も検証できる． |

**＊実装例＊**

以下のファイルを参考にせよ．

参考：https://github.com/hiroki-it/notify-slack-of-amplify-events/blob/develop/test/unit/amplify_test.go

<br>

### Tips

#### ・POSTデータの切り分け

POSTリクエストを受信するテストを行う時に，JSONデータをファイルに切り分けておく．これを```ReadFile```関数で読み出すようにする．

**＊実装例＊**

```go
package test

import (
	"io/ioutil"
)

/**
 * mainメソッドをテストします．
 */
func TestMain(t *testing.T) {
	// jsonファイルの読み出し
	data, err := ioutil.ReadFile("../testdata/example.json")

	// 以下にテストコードを実装していく

}
```

#### ・回帰テスト

回帰テストを実現するため，過去のテスト結果をテストデータを保存しておき，今回のテスト結果が過去のものと一致するかを確認する．Goでは，このテストデータをファイルを『Golden File』という．Golden（金）は化学的に安定した物質であることに由来しており，『安定したプロダクト』とかけている．回帰テストについては，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_testing.html

<br>

## 09. ビルトインパッケージ

### パッケージのソースコード

参考：https://golang.org/pkg/

<br>

### bytes

#### ・```Buffer```メソッド

渡された文字列を結合し，標準出力に出力する．

**＊実装例＊**

```go
package main

import (
	"bytes"
	"fmt"
)

func main() {
	var buffer bytes.Buffer

	buffer.WriteString("Hello ")

	buffer.WriteString("world!")

	fmt.Printf("%#v\n", buffer.String()) // "Hello world!"
}
```

<br>

### encoding/json

#### ・```Marshal```関数

構造体をJSONに変換する．変換前に，マッピングを行うようにする．引数のデータ型は，ポインタ型または非ポインタ型のいずれでも問題ない．ただし，他の多くの関数がポインタ型を引数型としていることから，それに合わせてポインタ型で渡すことが多い．```Marshal```関数に渡す構造体のデータはパブリックが必須である．

参考：https://golang.org/pkg/encoding/json/#Marshal

**＊実装例＊**

```go
package main

import (
	"encoding/json"
	"fmt"
	"log"
)

type Person struct {
	// Marshalに渡す構造体のデータはパブリックが必須
	Name string `json:"Name"`
}

func main() {
	person := &Person{Name: "Hiroki"}

	// ポインタ型と非ポインタ型の両方の引数に対応
	byteJson, err := json.Marshal(person)

	if err != nil {
		log.Fatalf("ERROR: %#v\n", err)
	}

	// エンコード結果を出力
	fmt.Printf("%#v\n", string(byteJson)) // "{\"Name\":\"Hiroki\"}"
}
```

#### ・```Unmarshal```関数

JSONを構造体に変換する．リクエストの受信によく使われる．リクエストのメッセージボディにはバイト型データが割り当てられているため，```Unmarshal```関数の第一引数はバイト型になる．また，第二引数として，変換後の構造体のメモリアドレスを渡すことにより，第一引数がその構造体に変換される．内部的には，そのメモリアドレスに割り当てられている変数を書き換えている．```Unmarshal```関数に渡す構造体のデータはパブリックが必須である．

参考：https://golang.org/pkg/encoding/json/#Unmarshal

**＊実装例＊**

```go
package main

import (
	"encoding/json"
	"fmt"
	"log"
)

type Person struct {
	// Unmarshalに渡す構造体のデータはパブリックが必須
	Name string
}

func main() {
	// リクエストを受信した場合を想定する．
	byte := []byte(`{"name":"Hiroki"}`)

	var person Person

	fmt.Printf("%#v\n", person) // main.Person{Name:""}（変数はまだ書き換えられていない）

	// person変数を変換後の値に書き換えている．
	err := json.Unmarshal(byteJson, &person)

	if err != nil {
		log.Fatalf("ERROR: %#v\n", err)
	}

	fmt.Printf("%#v\n", person) // main.Person{Name:"Hiroki"}（変数が書き換えられた）
}
```

#### ・```RawMessage```関数

JSONから構造体にパースするために```Unmarshal```関数を実行した時に，部分的にパースせずにJSONのまま取得できる．

**＊実装例＊**

CloudWatchは様々なイベントを扱うため，一部のJSON構造が動的に変化する．そのため，```RawMessage```関数が使用されている．

参考：https://github.com/aws/aws-lambda-go/blob/master/events/cloudwatch_events.go

```go
package events

import (
	"encoding/json"
	"time"
)

type CloudWatchEvent struct {
	Version    string          `json:"version"`

    // ～ 省略 ～
    
	Resources  []string        `json:"resources"`
    
    // 動的に変化するJSON構造
	Detail     json.RawMessage `json:"detail"`
}
```

イベントのJSONを文字列のまま取得できる．

```go
package handler

import (
	"fmt"
)

/**
 * Lambdaハンドラー関数
 */
func HandleRequest(event events.CloudWatchEvent) (string) {
    
	return fmt.Printf("%#v\n", event.Detail)
}
```

<br>

### fmt

#### ・接頭接尾辞無しメソッド

接頭接尾辞の無いメソッド（```Print```メソッド，```Sprint```メソッド，```Fprint```メソッド，など）が属する．複数の引数をスペースを挟んで繋ぐ．

参考：

- https://golang.org/pkg/fmt/#Print
- https://golang.org/pkg/fmt/#Fprint
- https://golang.org/pkg/fmt/#Sprint

**＊実装例＊**

```go
package main

import "fmt"

func main() {
    fmt.Print("Hello world!") // Hello world! 
}
```

**＊実装例＊**

```go
package main

import "fmt"

func main() {
    
    // 複数の引数をスペースで挟んで繋ぐ
    fmt.Print(1, 2, 3) // 1 2 3
}
```

ただし，引数のいずれかが文字列の値の場合，スペースが挿入されない．

```go
package main

import "fmt"

func main() {
	// いずれかが文字列
	fmt.Print("Hello", "world!", 12345) // Helloworld!12345
}
```

また，連続で使用しても，改行が挿入されない．

```go
package main

import "fmt"

func main() {
    fmt.Print("Hello", "world!")
    fmt.Print("Hello", "world!")
    
    // Hello world!Hello world!
}
```

#### ・接頭辞```S```メソッド

接頭辞に```S```のあるメソッド（```Sprint```メソッド，```Sprintf```メソッド，```Sprintln```メソッド，など）が属する．接頭辞が```F```や```P```のメソッドとは異なり，処理結果を標準出力に出力せずに返却する．標準出力に出力できる他の関数の引数として渡す必要がある．

参考：

- https://golang.org/pkg/fmt/#Sprint
- https://golang.org/pkg/fmt/#Sprintf
- https://golang.org/pkg/fmt/#Sprintln

**＊実装例＊**

```go
package main

import "fmt"

func main() {
    
    // Sprintは返却するだけ
    fmt.Print(fmt.Sprint(1, 2, 3)) // 1 2 3
}
```

#### ・接尾辞```ln```メソッド

接尾辞に```ln```のあるメソッド（```Println```メソッド，```Fprintln```メソッド，```Sprintln```メソッド，など）が属する．複数の引数をスペースを挟んで繋ぎ，最後に改行を挿入して結合する．

参考：

- https://golang.org/pkg/fmt/#Println
- https://golang.org/pkg/fmt/#Fprintln
- https://golang.org/pkg/fmt/#Sprintln

**＊実装例＊**

文字を連続で標準出力に出力する．

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello", "world!")
    fmt.Println("Hello", "world!")
    
    // Hello world!
    // Hello world!
}
```

#### ・接尾辞```f```メソッド

渡された引数を，事前に定義したフォーマットにも基づいて結合する．

| よく使う識別子 | 標準出力に出力されるもの     | 備考                                                 |
| -------------- | ---------------------------- | ---------------------------------------------------- |
| ```%s```       | 文字列またはスライスとして   |                                                      |
| ```%p```       | ポインタとして               |                                                      |
| ```%+v```      | フィールドを含む構造体として | データの構造を確認できるため，デバッグに有効である． |
| ```%#v```      | Go構文として                 | データの構造を確認できるため，デバッグに有効である． |

参考：

- https://golang.org/pkg/fmt/#Printf
- https://golang.org/pkg/fmt/#Fprintf
- https://golang.org/pkg/fmt/#Sprintf

**＊実装例＊**

渡された引数を文字列として結合する

```go
package main

import "fmt"

func main() {
    fmt.Printf("String is %s", "Hello world!")
}
```

また，連続して使用しても，改行は挿入されない．

```go
package main

import "fmt"

func main() {
    fmt.Printf("String is %s", "Hello world!")
    fmt.Printf("String is %s", "Hello world!")
    
    // String is Hello world!String is Hello world!
}
```

**＊実装例＊**

渡された引数をポインタとして結合する．

```go
package main

import "fmt"

type Person struct {
    Name     string
}

func main() {
    person:= new(Person)
    
    person.Name = "Hiroki"
    
    fmt.Printf("Pointer is %p", person) // 0xc0000821e0
}
```

**＊実装例＊**

渡された複数の引数を文字列として結合する．

```go
package main

import "fmt"

func main() {
    var first string = "Hiroki"
    
    var last string = "Hasegawa"
    
    fmt.Printf("Im %s %s", first, last) // Im Hiroki Hasegawa
}
```

<br>

### net/http

#### ・httpパッケージとは

HTTPクライアントまたはサーバを提供する．

参考：https://golang.org/pkg/net/http/#pkg-index

#### ・```Get```メソッド

**＊実装例＊**

```go
package main

import (
	"fmt"
    "log"
	"net/http"
)

func main() {
    
	response, err := http.Get("http://xxx/api.com")

	defer response.Body.Close()

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(response.Body)
}
```

#### ・```Post```メソッド

**＊実装例＊**

```go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type User struct {
	id   int    `json:"id"`
	name string `json:"name"`
}

// コンストラクタ
func NewUser(id int, name string) *User {

	return &User{
		id:   id,
		name: name,
	}
}

func main() {

	user := NewUser(1, "Hiroki")

	byteJson, err := json.Marshal(user)

	response, err := http.Post(
		"http://xxx/api.com",  // URL
		"application/json",    // Content-Type
		bytes.NewBuffer(byteJson), // メッセージボディ
	)

	defer response.Body.Close()

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(response.Body)
}
```

#### ・```NewRequest```メソッド

**＊実装例＊**

```go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type User struct {
	id   int    `json:"id"`
	name string `json:"name"`
}

// コンストラクタ
func NewUser(id int, name string) *User {

	return &User{
		id:   id,
		name: name,
	}
}

func main() {

	user := NewUser(1, "Hiroki")

	byteJson, err := json.Marshal(user)

	// リクエストを作成する．
	request, err := http.NewRequest(
		"POST",                    // HTTPメソッド
		"http://xxx/api.com",      // URL
		bytes.NewBuffer(byteJson), // メッセージボディ
	)

	// ヘッダーを作成する．
	request.Header.Set("Content-Type", "application/json") // Content-Type

	// クライアントを作成する．
	client := &http.Client{}

	// リクエストを送信する．
	response, err := client.Do(request)

	defer response.Body.Close()

	if err != nil || response.StatusCode != 200 {
		log.Fatal(err)
	}

	// レスポンスのボディを取得する．
	// 代わりに，httputil.DumpResponseを使用してもよい．
	body, _ := ioutil.ReadAll(response.Body)

	log.Println(string(body))
}
```

#### ・```ListenAndServe```メソッド

サーバを起動する．第一引数にサーバのURL，第二引数にServeMux関数（マルチプレクサ関数）を渡す．第二引数に```nil```を渡した場合，デフォルト引数として```http.DefaultServeMux```が渡される．

**＊実装例＊**

```go
package main

import (
	"net/http"
	"log"
)

func main() {

	err := http.ListenAndServe(":8080", nil)

	// 以下でも同じ．
	// http.ListenAndServe(":8080", http.DefaultServeMux)

	if err != nil {
		log.Fatal("Error ListenAndServe : ", err)
	}
}
```

#### ・```NewServeMux```メソッド

サーバーを起動する```ListenAndServe```メソッドに対して，自身で定義したServeMux関数を渡す場合，```NewServeMux```メソッドを使用する必要がある．これの```HandleFunc```関数に対してルーティングと関数を定義する．

**＊実装例＊**

HTMLをレスポンスとして返信するサーバ（```http://localhost:8080/```）を起動する．

```go
package main

import (
	"log"
	"net/http"
)

func myHandler(writer http.ResponseWriter, request *http.Request) {
	// HTMLをレスポンスとして返信する．
	fmt.Fprintf(writer, "<h1>Hello world!</h1>")
}

func main() {
	mux := http.NewServeMux()

	// ルーティングと関数を設定する．
	mux.HandleFunc("/", myHandler)

	// サーバを起動する．
	err := http.ListenAndServe(":8080", mux)

	if err != nil {
		log.Fatal("Error ListenAndServe : ", err)
	}
}
```

JSONをレスポンスとして返信するサーバ（```http://localhost:8080/```）を起動する．

```go
package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type User struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

// コンストラクタ
func NewUser(id int, name string) *User {

	return &User{
		Id:   id,
		Name: name,
	}
}

func myHandler(writer http.ResponseWriter, request *http.Request) {

	user := NewUser(1, "Hiroki")

	byteJson, err := json.Marshal(user)

	if err != nil {
		log.Fatal(err)
	}

	// JSONをレスポンスとして返信する．
	writer.Header().Set("Content-Type", "application/json; charset=utf-8")
	writer.Write(byteJson)
}

func main() {
	mux := http.NewServeMux()

	// ルーティングと関数を設定する．
	mux.HandleFunc("/", myHandler)

	// サーバを起動する．
	err := http.ListenAndServe(":8080", mux)

	if err != nil {
		log.Fatal(err)
	}
}
```

<br>

### os

#### ・```Open```関数

ファイルをReadOnly状態にする．

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    file, err := os.Open("filename.txt")
    
    if err != nil {
        log.Fatalf("ERROR: %#v\n", err)
    }
    
    fmt.Printf("%#v\n", file)
}
```

<br>

### strings

#### ・```Builder```関数

渡された文字列を結合し，標準出力に出力する．

**＊実装例＊**

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	var builder strings.Builder

	builder.WriteString("Hello ")

	builder.WriteString("world!")

	fmt.Println(builder.String()) // Hello world!
}
```

<br>

## 09-02. AWSパッケージ

### aws-sdk-go-v2

#### ・aws-sdk-go-v2とは

参考：https://pkg.go.dev/github.com/aws/aws-sdk-go-v2?tab=versions

#### ・aws

汎用的な関数が同梱されている．

参考：https://pkg.go.dev/github.com/aws/aws-sdk-go-v2/aws?tab=versions

ポインタ型から文字列型に変換する```ToString```関数や，反対に文字列型からポインタ型に変換する```String```関数をよく使う．

参考：

- https://pkg.go.dev/github.com/aws/aws-sdk-go-v2/aws#String
- https://pkg.go.dev/github.com/aws/aws-sdk-go-v2/aws#ToString

#### ・serviceパッケージ

参考：https://pkg.go.dev/github.com/aws/aws-sdk-go-v2/service/amplify?tab=versions

<br>

### aws-lambda-go

#### ・aws-lambda-goとは

Lambdaで稼働するGoにおいて，Lambdaの機能を使用するためのパッケージのこと．イベント駆動であり，他のAWSリソースのイベントをパラメータとして受信できる．contextパラメータについては以下を参考にせよ．

参考：https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/golang-context.html

#### ・SNSイベントの場合

```go
package main

import (
	"context"
    
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

func main() {
	lambda.Start(HandleRequest)
}

/**
 * Lambdaハンドラー関数
 */
func HandleRequest(context context.Context, event events.SNSEvent) (string, error) {

}
```

#### ・CloudWatchイベントの場合

```go
package main

import (
	"context"
    
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

func main() {
	lambda.Start(HandleRequest)
}

/**
 * Lambdaハンドラー関数
 */
func HandleRequest(context context.Context, event events.CloudWatchEvent) (string, error) {

}
```

#### ・APIGatewayイベントの場合

```go
package main

import (
	"context"
    
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

func main() {
	lambda.Start(HandleRequest)
}

/**
 * Lambdaハンドラー関数
 */
func HandleRequest(context context.Context, event events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

}
```

<br>

## 09-03. 外部パッケージの管理

### go.modファイル

#### ・```go.mod```ファイルとは

PHPにおける```composer.json```ファイルに相当する．インターネット上における自身のパッケージ名とGoバージョンを定義するために，全てのGoアプリケーションで必ず必要である．インストールしたい外部パッケージも定義できる．

```
module github.com/hiroki-it/example_repository

go 1.16
```

#### ・インターネットからインポート

ドメイン名をルートとしたURLと，バージョンタグを用いて，インターネットからパッケージをインポートする．なお，パスの最初にはドットを含ませる必要がある．

参考：https://github.com/golang/go/wiki/Modules#should-i-commit-my-gosum-file-as-well-as-my-gomod-file

```
module github.com/hiroki-it/example_repository

go 1.16

require (
    <ドメインをルートとしたURL> <バージョンタグ>
    github.com/hoge/fuga v1.3.0
    github.com/internal/example_repository v1.0.0
)
```

```go
import "github.com/hoge/fuga"

func main() {
    // 何らかの処理
}
```

#### ・ローカルPCからインポート

アプリケーションで使用する独自共有パッケージは，インターネット上での自身のリポジトリからインポートせずに，```replace```関数を使用してインポートする必要がある．実際，```unknown revision```のエラーで，バージョンを見つけられない．

参考：https://qiita.com/hnishi/items/a9217249d7832ed2c035

```
module example.com/hiroki-it/example_repository/local-pkg

go 1.16

replace (
    github.com/example_repository/local-pkg/local-pkg => ./local-pkg
)
```

また，ルートディレクトリだけでなく，各パッケージにも```go.mod```ファイルを配置する必要がある．

```shell
example_repository
├── cmd
│   └── hello.go
│ 
├── go.mod
├── go.sum
└── local-pkg
    ├── go.mod # 各パッケージにgo.modを配置する．
    └── module.go
```

```
module example.com/hiroki-it/example_repository/local-pkg

go 1.16
```

これらにより，ローカルのパッケージをインポートできるようになる．

```go
import "local.packages/local-pkg"

func main() {
    // 何らかの処理
}
```

<br>

### go.sumファイル

#### ・```go.sum```ファイルとは

PHPにおける```composer.lock```ファイルに相当する．```go.mod```ファイルによって実際にインストールされたパッケージが自動的に実装される．パッケージごとのチェックサムが記録されるため，前回のインストール時と比較して，ライブラリに変更があるかどうかを検知できる．