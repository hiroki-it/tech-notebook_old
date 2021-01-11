#  サイバー攻撃

## 01. サイバー攻撃からの防御方法

### 防御方法の種類

![ファイアウォール_ips_ids_waf](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ファイアウォール_ips_ids_waf.png)

<br>

### ファイアウォール

![内部，DMZ，外部](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/内部，DMZ，外部.png)

#### ・Proxyサーバによるアプリケーションゲートウェイ型ファイアウォール

Proxyサーバ上で，SSLサーバ証明書の認証，セキュリティ系のソフトウェアの稼働，を行い，ファイアウォールとして用いる．Proxyサーバセキュリティ精度を重視する場合はこちら．

![フォワードプロキシサーバーとリバースプロキシサーバ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/フォワードプロキシサーバーとリバースプロキシサーバ.png)

#### ・パケットフィルタリング型ファイアウォール

  パケットのヘッダ情報に記載された送信元IPアドレスやポート番号などによって，パケットを許可するべきかどうかを決定する．速度を重視する場合はこちら．ファイアウォールとWebサーバの間には，NATルータやNAPTルータが設置されている．これらによる送信元プライベートIPアドレスから送信元グローバルIPアドレスへの変換についても参照せよ．

![パケットフィルタリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パケットフィルタリング.gif)

**＊具体例＊**

Win10における設定画面

![パケットフィルタリングの設定](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パケットフィルタリングの設定.gif)

<br>

### Detection Systemとは

#### ・Detection Systemとは

ネットワーク上を流れるトラフィックを監視し，不正アクセスと思われるパケットを検出した時に，管理者に通知するシステム．あくまで通知するだけで，攻撃を防御することはしない．

![IDS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IDS.png)

<br>

### IPS：Intrusion Prevention Systemとは

#### ・IPSとは

ネットワーク上を流れるトラフィックを監視し，不正アクセスと思われるパケットを検出した時に，管理者に通知し，さらにパケットの侵入を防ぐシステム．

![IPS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IPS.png)

<br>

### WAF：Web Application Firewallとは

#### ・WAFとは

Webアプリケーション自体を保護するシステム．

![WAF](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/WAF.png)

<br>

## 02. Malware の種類と特徴

### Malware の語源

『malicious（悪意のある）＋software（ソフトウェア）』

<br>

### Macroウイルス

#### ・Macroウイルスとは

Wordなどのワープロアプリや，Excelなどの表計算アプリに感染

![Macroウイルス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Macroウイルス.jpg)

<br>

### Worm

#### ・Wormとは

自己複製し，1つのコンピュータから，4つの経路（ネットワーク，メール，共有フォルダ，USB）を辿って，他のコンピュータに感染を広げていく．パソコンがグローバルIPで直接インターネットに接続していると感染しやすい．ワームを防ぐためには，パソコンにプライベートIPアドレスを設定し，NATやNAPTなどを介して，インターネットに接続させる必要がある．

**＊具体例＊**

共有フォルダ経由での感染拡大

![Worm（共有フォルダ）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Worm（共有フォルダ）.jpg)

<br>

### トロイの木馬

#### ・トロイの木馬とは

**＊具体例＊**

Google play で，過去にアプリとして忍び込んでいたトロイの木馬

![トロイの木馬](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/トロイの木馬.jpg)

感染方法がギリシャ神話上のトロイの木馬に似ていることに由来する．有用なプログラムであるように見せかけて，パソコン利用者に実行させることで感染．裏で不正な処理を行う．

※トロイの木馬はギリシャ神話に登場する．ギリシャ軍は難攻不落のトロイ城を陥落させるため，中に精鋭部隊を忍び込ませた木馬をトロイ城の近くに置いて帰った．戦利品だと勘違いしたトロイ軍は，城内に木馬を持ち帰った．夜中，木馬の中に隠れた精鋭部隊が自軍の兵士をトロイ城に引き入れ，城を制圧した．

<br>

### Spyware

#### ・Spywareとは

パソコン利用者の個人情報を収集し，外部に送信する．

![スパイウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スパイウェア.png)

<br>

### Bot

#### ・Botとは

あらかじめBot化させておいたパソコンを踏み台として，攻撃者の命令通りに動かす．

#### ・パソコンがボット化するまでのプロセス

![ボット化のプロセス（パソコン）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ボット化のプロセス（パソコン）.jpg)

#### ・スマホがボット化するまでのプロセス

![ボット化のプロセス（スマホ）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ボット化のプロセス（スマホ）.jpg)

#### ・Bot の使われ方

  まず，攻撃対象のネットワーク内にあるパソコンをBot化させる．攻撃者は，Bot化したパソコンを踏み台としてサーバーを攻撃させるように，C&Cサーバーに命令を出す．

![C&Cサーバー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/C&Cサーバー.png)

<br>

## 03. IPS・IDSで防御可能なサイバー攻撃

### DoS攻撃：Denial of Service

#### ・DoS攻撃とは

アクセスが集中することでWebサーバーがパンクすることを利用し，悪意を持ってWebサーバーに大量のデータを送りつける手法．

![DoS攻撃](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DoS攻撃.png)

<br>

## 04. WAFで防御可能なサイバー攻撃

### SQL Injection

#### ・SQL Injectionとは

データベースのSQLクエリのパラメータとなる入力に，不正な文字列を入力して不正なSQLクエリを実行させ，データベースの情報を抜き取る手法．ただし，近年は減少傾向にある．

![SQLインジェクション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SQLインジェクション.jpg)

#### ・特殊な記号の無効化による対策

  データベースのSQLクエリのパラメータとなる入力では，SQLで特別な意味を持つ，『シングルクオーテーション』や『バックスラッシュ』を無効化させる．

#### ・**プレースホルダーによる対策**

プリペアードステートメントともいう．SQL中にパラメータを設定し，値をパラメータに渡した上で，SQLとして発行する方法．処理速度が速い．また，パラメータに誤ってSQLが渡されても，これを実行できなくなるため，SQLインジェクションの対策になる

**＊実装例＊**

```php
use Doctrine\DBAL\Connection;

class dogToyQuey(Value $toyType): array
{
  // QueryBuilderインスタンスを作成する
  $queryBuilder = $this->createQueryBuilder();

  // SELECTを設定する
  $queryBuilder->select([
                  'dog_toy.type AS dog_toy_type',
                  'dog_toy.name AS dog_toy_name',
                  'dog_toy.number AS number',
                  'dog_toy.price AS dog_toy_price',
                  'dog_toy.color_value AS color_value'
                  ])

                  // FROMを設定する．
                  ->from('mst_dog_toy', 'dog_toy')

                  // WHEREを設定する．この時，値はプレースホルダーとしておく．
                  ->where('dog_toy.type = :type')

                  // プレースホルダーに値を設定する．ここでは，引数で渡す『$toyType』とする．
                  ->setParameter('type', $toyType);


  // データベースから『$toyType』に相当するレコードを取得する．
  return $queryBuilder->getConnection()

                      // 設定したSQLとプレースホルダーを取得する．
                      ->executeQuery($queryBuilder->getSQL(),
                                      $queryBuilder->getParameters(),
                      )
    
                      // レコードを取得する．
                      ->fetchAll();

}
```

<br>

### XSS：Cross Site Scripting

#### ・XSSとは

WebアプリケーションによるHTML出力のエスケープ処理の欠陥を悪用し，利用者のWebブラウザで悪意のあるスクリプトを実行させる ．

![Cross Cite Scripting](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Cross Cite Scripting.png)

<br>

### Directory traversal

#### ・Directory traversalとは

traversalは，横断する（ディレクトリの構造を乗り越える）の意味．パス名を使ってファイルを指定し，管理者の意図していないファイルを不正に閲覧またはダウンロードする．

![ディレクトリトラバーサル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ディレクトリトラバーサル.jpg)

<br>

## 05. パスワードに関するサイバー攻撃

### パスワードリスト攻撃

#### ・パスワード攻撃

漏洩したパスワードを用いて，正面から正々堂々とアクセスする手法．

![パスワードリスト攻撃](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パスワードリスト攻撃.png)

<br>

### Brute-force攻撃とReverse Brute-force攻撃

#### ・Brute-force攻撃とReverse Brute-force攻撃とは

Brute-forceは力ずくの意味．IDを固定して，パスワードを総当たりで試す手法．例えば，5桁数字のパスワードなら，9の5乗通りの組み合わせを試す．一方で，Reverse Brute-forceは，パスワードを固定して，IDを総当たりで試す手法．

![Brute-force攻撃とReverse Brute-force攻撃](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Brute-force攻撃とReverse Brute-force攻撃.png)

#### ・パスワードのパターン数

![パスワードのパターン数](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パスワードのパターン数.png)

<br>

### Rainbow攻撃

#### ・Rainbow攻撃とは

  ハッシュ化された暗号から，元のパスワードを解析する手法．

![Rainbow攻撃](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Rainbow攻撃.png)

<br>

## 06. その他のサイバー攻撃

### ソーシャルエンジニアリング

#### ・ソーシャルエンジニアリングとは

技術的な手法ではなく，物理的な手法（盗み見，盗み聞き，成りすまし，詐欺など）によってパスワードを取得し，アクセスする手法．

![ソーシャルエンジニアリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ソーシャルエンジニアリング.png)

<br>

### 踏み台攻撃

#### ・踏み台攻撃とは

対象のインターネット内のパソコンに攻撃プログラムを仕込んで置き，攻撃者からの命令でサーバを攻撃させる手法（※ボットを用いた攻撃など）

#### ・パソコンがボット化するまでのプロセス（再掲）

![ボット化のプロセス（パソコン）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ボット化のプロセス（パソコン）.jpg)

#### ・スマホがボット化するまでのプロセス（再掲）

![ボット化のプロセス（スマホ）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ボット化のプロセス（スマホ）.jpg)

#### ・Bot の使われ方（再掲）

![C&Cサーバー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/C&Cサーバー.png)

<br>

### DNS Cache Poisoning

#### ・DNS Cache Poisoningとは

キャッシュDNSサーバーがもつIPアドレスを偽のIPアドレスに変え，偽のWebサイトに強制的にアクセスさせる手法．

![DNSキャッシュポイズニング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DNSキャッシュポイズニング.gif)

<br>

### Back Door

#### ・Back Doorとは

例えば，Webサイトのカード決済画面やサーバに潜ませることによって，カード情報を第三者に送信する手法．

![バックドア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/バックドア.png)

