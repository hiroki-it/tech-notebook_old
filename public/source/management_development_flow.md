# システム開発フローの全体像

## 01. システムの開発手法の種類

### システム開発の要素

#### ・設計

#### ・実装

#### ・テスト

⇒ 15章と16章で解説していく．



### ウォーターフォール型開発

![ウォーターフォール型](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ウォーターフォール型.png)

#### ・外部設計の詳細

  外部設計では，ユーザ向けのシステム設計が行われる．

![外部設計の詳細](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/外部設計の詳細.png)



### プロトタイプ型開発

システム設計に入るまでに試作品を作り，要件定義をより正確にする開発方法．

![p456](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p456.png)



### レビュー

各工程が完了した段階で，レビューを行う開発方法．

![p458](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p458.png)



### RAD（Rapid Application Development）

Visual Basicなどの開発支援ツールを用いて，短期間で設計～テストまでを繰り返す開発方法．

![p462-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p462-1.png)

![p462-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p462-2.png)



### スパイラル型開発

システムをいくつかのサブシステムに分割し，ウォーターフォール型開発で各サブシステムを開発していく方法．

![p457](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p457.png)



### アジャイル型開発

スパイラルモデルの派生型．スパイラルモデルよりも短い期間で，設計～テストまでを繰り返す開発方法．

![p463](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p463.png)



### CASEツール：Computer Aided Software Enginnering

システム開発をサポートするツール群のこと．

#### ・上流CASEツール

  データフロー図，ER図

#### ・下流CASEツール

  テスト支援ツール

#### ・保守CASEツール

  リバースエンジニアリング

![p459](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p459.png)



## 02. システム開発におけるプロジェクト管理

### ウォーターフォール型開発（再掲）

![ウォーターフォール型](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ウォーターフォール型.png)



### システム開発における様々な指標

『開発規模（か）』，『工数（こ）』，『生産性（せ）』の単位間の関係は，「みはじ」と同じである．

#### ・開発規模（か）

  （プログラム本数による開発規模）＝（プログラム本数）

  （プログラム行数による開発規模）＝（ｋステップ行数）

![kステップ行数による開発規模](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/kステップ行数による開発規模.png)

#### ・工数（こ）

  （人時による工数）＝（人数・時）＝（人数 × 時間）

  （人時による標準工数）＝（プログラム一本当たりの人数・時）＝（人数・時／本）

| 一期開発  | 外部設計   | 内部設計 | 開発 | 結合テスト | 総合テスト |
| :-------: | ---------- | -------- | ---- | ---------- | ---------- |
|   工数    | 42（時間） | 70       | 140  | 52.5       | 42.0       |
| 配分月数  | 3（ヶ月）  | 3        | 5    | 2          | 3          |
| A社動員数 | 12（人）   | 20       | 0    | 12         | 12         |
| B社動員数 | 2（人）    | 4        | 28   | 15         | 2          |

![プロジェクト管理](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/プロジェクト管理.png)

#### ・生産性（せ）

  （プログラム本数の生産性）

  ＝（プログラム本数／人時）

  ＝（プログラム本数による開発規模）÷（工数）

![プログラム本数による生産性](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/プログラム本数による生産性.png)

  （kステップ行数の生産性）

＝（ｋステップ行数／人時）

＝（ｋステップ行数による開発規模）÷（工数）

![kステップ行数による生産性](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/kステップ行数による生産性.png)

#### ・進捗率

![進捗率](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/進捗率.png)



### Arrow ダイアグラム

#### ・プロジェクトに必要な日数

  全体的な工程に必要な日数は，所要日数が最も多い経路に影響される．この経路を，Critical Path という．

![p509](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p509.jpg)

#### ・最早結合点時刻

  全体的な工程の中で，任意の結合点に取り掛かるために必要な最少日数のこと．Critical Path に影響されるので，注意．

![p510-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p510-1.jpg)

#### ・最遅結合点時刻

  全体的な工程の中で，任意の結合点に取り掛かるために必要な最多日数のこと．

![p510-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p510-2.jpg)