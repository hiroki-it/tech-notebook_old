# マイクロサービス

## 01. サービス内部の構成

### サービス

#### ・サービスとは

境界付けられたコンテキストを粒度としたロジックのまとまり．そのため，境界付けられたコンテキストをドメイン層としたドメイン駆動設計が必要になる．

#### ・依存性逆転の利用

ドメイン層がインフラストラクチャ層に依存しないようにするため，ドメイン層の依存性を逆転させる必要がある．詳しくは，ドメイン駆動設計のノートを参考にせよ．

<br>

### テスト

#### ・単体テスト

クラスやメソッドをテストする．下流サービスのコールはモック化またはスタブ化する．

#### ・サービステスト

サービスのコントローラがコールされてから，データベースの操作が完了するまでを，テストする．下流サービスのコールはモック化またはスタブ化する．

<br>

## 01. サービス間の連携

### アプリケーション層の連携

#### ・コレオグラフィとは

分散型システムとも言う．オーケストレーションとしてのプログラムは存在せず，各サービスで下流サービスに連携する責務を持たせる設計方法．一つのリクエストが送信された時に，サービスからサービスに処理が繋がっていく．サービス間のインターフェースとして，キューを設置する．このノートでは，コレオグラフィを用いたアプリケーション層の連携を説明する．

![choreography](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/choreography.png)

#### ・オーケストレーションとは

中央集権型システムとも言う．全てのサービスを制御する責務を持ったオーケストレーションプログラムを設置する設計方法．一つのリクエストが送信された時に，オーケストレーションプログラムは各サービスをコールしながら処理の結果を繋いでいく．

![orchestration](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/orchestration.png)

<br>

### インフラストラクチャ層の連携

#### ・ローカルトランザクションとは

各サービスに独立したトランザクション処理が存在しており，一つのトランザクション処理によって，特定のサービスのデータベースのみを操作する設計方法．推奨である．このノートでは，ローカルトランザクションを用いたインフラストラクチャ層の連携を説明する．

#### ・グローバルトランザクションとは

分散トランザクションとも言う．一つのトランザクション処理が各サービスに分散しており，一つのトランザクション処理によて，各サービスのデータベースを連続的に操作する設計方法．非推奨である．

#### ・Sagaパターンとは

ローカルトランザクションの時に，インフラストラクチャ層を実現する設計方法．上流サービスのデータベースの操作完了をイベントとして，下流サービスのデータベースの操作処理を連続的にコールする．ロールバック時には補償トランザクションが実行され，逆順にデータベースの状態が元に戻される．

![saga-pattern](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/saga-pattern.png)

<br>

### テストの連携

#### ・CDCテストとは：Consumer Drive Contract Test

<br>

### 障害対策

#### ・サーキットブレイカーとは

サービス間に設置され，他のサービスに連鎖する障害を吸収するプログラムのこと．下流サービスに障害が起こった時に，上流サービスにエラーを返してしまわないよう，直近の成功時の処理結果を返信する．

![circuit-breaker](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/circuit-breaker.png)

<br>

### 横断的な監視

#### ・分散トレーシングとは

サービス間で分散してしまう各ログを，一意なIDで紐づける方法．

![distributed-tracing](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/distributed-tracing.png)

<br>

## 02. フロントエンドのマイクロサービス化

### UI部品合成

#### ・UI部品合成とは

フロントエンドのコンポーネントを，各サービスに対応するように分割する設計方法．

![composite-ui](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/composite-ui.png)

<br>

### BFFパターン：Backends  For Frontends

#### ・BFFパターンとは

クライアントの種類（モバイル，Web，デスクトップ）に応じたAPIを構築し，このAPIから各サービスにルーティングする設計方法．

![bff-pattern](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/bff-pattern.png)