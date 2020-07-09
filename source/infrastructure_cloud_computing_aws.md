# Amazon Web Service

## 01. AWSにおけるグローバルネットワーク構成

AWSから，グローバルIPアドレスと完全修飾ドメイン名が提供され，Webサービスがリリースされる．

### クラウドデザイン例

以下のデザイン例では，Dualシステムが採用されている．

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/AWSのクラウドデザイン一例.png)



### Route53（＝DNSサーバ）

#### ・Route53とは

クラウドDNSサーバーとして働く．リクエストされた完全修飾ドメイン名とEC2のグローバルIPアドレスをマッピングしている．

![URLと電子メールの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/URLと電子メールの構造.png)

#### ・主要なレコードタイプと名前解決の仕組み

| レコードタイプ | 名前解決の仕組み（1） |      |    （2）    |      |    （3）    |
| -------------- | :-------------------: | :--: | :---------: | :--: | :---------: |
| A              |  完全修飾ドメイン名   |  →   | Public IPv4 |  →   |      -      |
| AAAA           |  完全修飾ドメイン名   |  →   | Public IPv6 |  →   |      -      |
| CNAME          |  完全修飾ドメイン名   |  →   | エイリアス  |  →   | Public IPv4 |

#### ・エイリアス

ルーティング先のリソースのホスト名を設定する．ALBがルーティング先であれば，ALBのDNS名を設定する．

![Route53の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Route53の仕組み.png)

#### ・（1）完全修飾ドメイン名に対応するIPアドレスのレスポンス

1. クライアントPCは，完全修飾ドメイン名を，フォワードProxyサーバにリクエスト．

2. フォワードProxyサーバは，完全修飾ドメイン名を，リバースProxyサーバに代理リクエスト．

3. リバースProxyサーバは，完全修飾ドメイン名を，DNSサーバに代理リクエスト．

4. Route53は，DNSサーバとして機能する．完全修飾ドメインにマッピングされるIPv4アドレスを取得し，リバースProxyサーバにレスポンス．

   |     完全修飾ドメイン名      |  ⇄   |     IPv4アドレス      |
   | :-------------------------: | :--: | :-------------------: |
   | ```http://www.kagoya.com``` |      | ```203.142.205.139``` |

5. リバースProxyサーバは，IPv4アドレスを，フォワードProxyサーバに代理レスポンス．（※NATによるIPv4アドレスのネットワーク間変換が起こる）

6. フォワードProxyサーバは，IPv4アドレスを，クライアントPCに代理レスポンス．

#### ・（2）IPアドレスに対応するWebページのレスポンス

1. クライアントPCは，レスポンスされたIPv4アドレスを基に，Webページを，リバースProxyサーバにリクエスト．
2. リバースProxyサーバは，Webページを，Webサーバに代理リクエスト．
3. EC2は，Webページを，リバースProxyサーバにレスポンス．
4. リバースProxyサーバは，Webページを，クライアントPCに代理レスポンス．



### CloudFront（＝プロキシサーバ）

#### ・CloudFrontとは

クラウドプロキシサーバとして働く．リクエストを受け付ける．動的コンテンツの場合は，リクエストをEC2に振り分ける．また，静的コンテンツの場合は，キャッシュした上でAmazon S3へ振り分ける．

![CloudFront](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CloudFront.png)

### CloudTrail

#### ・CloudTrailとは

IAMユーザによる操作や，ロールのアタッチの履歴を記録し，ログファイルとしてS3に転送する．CloudWatchと連携することもできる．

![CloudTrailとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CloudTrailとは.jpeg)



### S3：Simple Storage Service（＝外付けストレージ）

#### ・S3とは

クラウド外付けストレージとして働く．Amazon S3に保存するCSSファイルや画像ファイルを管理できる．



### API Gateway

#### ・API Gatewayとは

API Gatewayは，メソッドリクエスト，統合リクエスト，統合レスポンス，メソッドレスポンス，から構成される．

![APIGatewayの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/APIGatewayの仕組み.png)

#### 1. メソッドリクエスト

クライアントからリクエストメッセージを受信．また，リクエストメッセージからデータを抽出．（※メッセージについては，アプリケーション層の説明を参照せよ）

#### 2. 統合リクエスト

データを編集し，指定のAWSサービスにこれを送信．

#### 3. 統合レスポンス

指定のAWSサービスからデータを受信し，これを編集．

#### 4. メソッドレスポンス

HTTPステータスを追加．また，データをレスポンスメッセージとして，クライアントに送信．



### SQS：Amazon Simple Queue Service

#### ・SQSとは

クラウドメッセージキューとして働く．異なるVPC間でも，メッセージキューを同期できる．クラウドサーバで生成されたメッセージは，一旦SQSに追加される．コマンドによってバッチが実行され，メッセージが取り出される．その後，例えば，バッチ処理によってメッセージからデータが取り出されてファイルが生成され，S3に保存されるような処理が続く．

![AmazonSQSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/AmazonSQSとは.jpeg)

#### ・SQSの種類

スタンダード方式キューとFIFO方式：First In First Outキューがある．



### Lambdaと他FaaSの連携によるサーバレスアーキテクチャ

Lambdaを軸に他のFaaSと連携させることによって，ユーザ側は関数プログラムを作成しさえすれば，これを実行することができる．この方法を，『サーバレスアーキテクチャ』という．

![サーバレスアーキテクチャとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/サーバレスアーキテクチャとは.png)



### CloudWatch系

#### ・Cloud Watch Logs（＝ ログ収集サーバ）

AWSの各種サービスで生成されたログファイルを収集できる．

**【設定例】**

confファイルを，EC2内の```etc```ディレクトリ下に設置する．

```
# --- /etc/awslogs/awscli.conf --- # 
[plugins]
cwlogs = cwlogs
[default]
region = ap-northeast-1
```

```
# --- /etc/awslogs/awslogs.conf --- #
[/var/log/messages]

# タイムスタンプ（例）May 14 08:10:00
datetime_format = %b %d %H:%M:%S

# 収集したいログファイル．ここでは，CentOSのログを指定．
file = /var/log/messages

# 要勉強
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file

# AWS上で管理するロググループ名
log_group_name = /var/log/messages
```



#### ・Cloud Watch Events

イベントやスケジュールを検知し，指定したアクションを行う．

| イベント例                | スケジュール例       |      | アクション例              |
| ------------------------- | -------------------- | ---- | ------------------------- |
| APIのコール               | Cron形式での日時指定 | ⇒    | Lambdaによる関数の実行    |
| AWSコンソールへのログイン |                      | ⇒    | SQSによるメッセージの格納 |
| インスタンスの状態変化    |                      | ⇒    | SNSによるメール通知       |
| ...                       | ...                  | ⇒    | ...                       |



### SSLサーバ証明書の設置場所

#### ・認証局

| サーバ提供者 | 自社の中間認証局名         | ルート認証局名 |
| ------------ | -------------------------- | -------------- |
| AWS          | ATS：Amazon Trust Services | Starfield社    |

#### ・SSLサーバ証明書の設置場所でよくあるパターン

AWSの使用上，ATS証明書を設置できないサービスに対しては，外部の証明書を手に入れて設置する．SSLプロトコルを受け付けるネットワーク地点のことを，SSLターミネーションという．

| パターン                                     | SSLターミネーション |
| -------------------------------------------- | ------------------- |
| Route53 → ALB(+ATS証明書) → EC2              | ALB                 |
| Route53 → ALB(+ATS証明書) → EC2(+外部証明書) | EC2                 |
| Route53 → NLB → EC2(+外部証明書)             | EC2                 |
| Route53 → EC2(+外部証明書)                   | EC2                 |
| Route53 → CloudFront(+ATS証明書) → ALB → EC2 | CloudFront          |
| Route53 → CloudFront(+ATS証明書) → EC2       | CloudFront          |
| Route53 → CloudFront(+ATS証明書) → S3        | CloudFront          |
| Route53 → Lightsail(+ATS証明書)              | Lightsail           |



## 02. AWSにおけるプライベートネットワーク構成

### クラウドデザイン例（再掲）

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/AWSのクラウドデザイン一例.png)



### RegionとAvailability Zone

#### ・Regionとは

2016年1月6日時点では，以下のRegionに物理サーバのデータセンターがある．

![AWSリージョンマップ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/AWSリージョンマップ.PNG)

#### ・Availability Zone

Regionは，さらに，各データセンターは物理的に独立したAvailability Zoneというロケーションから構成されている．例えば，東京Regionには，3つのAvailability Zoneがある．AZの中に，VPC subnetを作ることができ，そこにEC2を構築できる．



### セキュリティグループ（＝ パケットフィルタリング型ファイアウォール）

#### ・セキュリティグループとは

クラウドパケットフィルタリング型ファイアウォールとして働く．インバウンド（受信ルール）では，プロトコルや受信元IPアドレスを設定でき，アウトバウンド（送信ルール）では，プロトコルや送信先プロトコルを設定できる．

#### ・パケットフィルタリング型ファイアウォールとは（セキュリティのノートを参照せよ）

パケットのヘッダ情報に記載された送信元IPアドレスやポート番号などによって，パケットを許可するべきかどうかを決定する．速度を重視する場合はこちら．ファイアウォールとWebサーバの間には，NATルータやNAPTルータが設置されている．これらによる送信元Private IPアドレスから送信元グローバルIPアドレスへの変換についても参照せよ．

![パケットフィルタリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/パケットフィルタリング.gif)



### VPC：Virtual Private Cloud（＝プライベートネットワーク）

#### ・VPCとは

クラウドプライベートネットワークとして働く．Private IPアドレスが割り当てられた，VPCと呼ばれるプライベートネットワークを仮想的に構築することができる．異なるAvailability Zoneに渡ってEC2を立ち上げることによって，クラウドサーバをデュアル化することできる．

![VPCが提供できるネットワークの範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VPCが提供できるネットワークの範囲.png)




### VPC subnet

クラウドプライベートネットワークにおけるセグメントとして働く．

#### ・Public subnetとは

非武装地帯に相当する．攻撃の影響が内部ネットワークに広がる可能性を防ぐために，外部から直接リクエストを受ける，

#### ・Private subnetとは

内部ネットワークに相当する．外部から直接リクエストを受けずにレスポンスを返せるように，内のNATを経由させる必要がある．

![パブリックサブネットとプライベートサブネットの設計](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/パブリックサブネットとプライベートサブネットの設計.png)

#### ・IPアドレス範囲について

一つのVPC内には複数のSubnetが入るため，SubnetのIPアドレス範囲は，Subnetの個数だけ狭めなければならない．CIDR形式によるIPアドレス範囲の表現は，ネットワークのノートを参照．



### VPCエンドポイント

#### ・VPCエンドポイントとは

NATとインターネットゲートウェイを経由せずにVPCの外側と通信できるため，NATの負荷を抑え，またより安全に通信できる．

![VPCエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VPCエンドポイント.png)



### ALB：Application Load Balancing（＝ リバースプロキシサーバ ＋ ロードバランサー）

#### ・ALBとは

リバースプロキシサーバかつロードバランサーとして働く．リクエストを代理で受信し，インスタンスへのアクセスをバランスよく分配することによって，サーバへの負荷を緩和する．

#### ・機能

![ターゲットグループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ターゲットグループ.jpg)

| 機能               | 内容                                                         |
| ------------------ | ------------------------------------------------------------ |
| リスナー           | ・リクエストのうちで，受信するプロトコルを設定．<br>・ALBでリクエストを受信するポート番号を設定．<br>・リクエストをターゲットグループにルーティング． |
| ルール             | リクエストのルーティングのロジックを設定                     |
| ターゲットグループ | ・ALBからターゲットグループへのルーティングで使用するプロトコルとポート番号を設定<br>・ルーティング先のターゲットを設定．ターゲットは，IPアドレス，インスタンス，Lambdaなどから選択可能． |
| ヘルスチェック     | ALBからターゲットに対して，定期的にリクエストを送信する．    |

#### ・IPアドレス範囲

ALBのIPアドレス範囲には，VPCのものが適用される．そのため，EC2のセキュリティグループでは，VPCのIPアドレス範囲を許可するように設定する必要がある．



### Internet Gateway，NAT Gateway


|              | Internet Gateway                                             | NAT Gateway     |
| :----------- | :----------------------------------------------------------- | :-------------- |
| **機能**     | グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT） | NAPT（動的NAT） |
| **設置場所** | VPC上                                                        | Public subnet内 |

#### ・Internet Gatewayとは

グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT）の機能を持つ．一つのPublic IPに対して，一つのEC2のPrivate IPを紐づけられる．詳しくは，NAT（静的NAT）を参照せよ．

#### ・NAT Gatewayとは

NAPT（動的NAT）の機能を持つ．一つのPublic IPに対して，複数のEC2のPrivate IPを紐づけられる．Public subnetに置き，Private SubnetのEC2からのレスポンスを受け付ける．詳しくは，NAPT（動的NAT）を参照せよ．

![InternetGatewayとNATGateway](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/InternetGatewayとNATGateway.png)



### Route Table（= マッピングテーブル）

#### ・Route Tableとは

クラウドルータのマッピングテーブルとして働く．ルータについては，NATとNAPTを参照せよ．

| Destination（Private IPの範囲） |                Target                 |
| :-----------------------------: | :-----------------------------------: |
|        ```xx.x.x.x/xx```        | Destinationの範囲内だった場合の送信先 |

#### ・具体例1

以下の図中で，サブネット2にはルートテーブル1が関連づけられており，サブネット2内のインスタンスの送信先のPrivate IPが，```10.0.0.0/16```の範囲内にあれば，local（VPC内の他サブネット）を送信先に選び，範囲外にあれば通信を破棄する．

| Destination（Private IPの範囲） |  Target  |
| :-----------------------------: | :------: |
|        ```10.0.0.0/16```        |  local   |
|       指定範囲以外の場合        | 通信破棄 |

#### ・具体例2

以下の図中で，サブネット3にはルートテーブル2が関連づけられており，サブネット3内のインスタンスの送信先のPrivate IPが，```10.0.0.0/16```の範囲内にあれば，local（VPC内の他サブネット）を送信先に選び，```0.0.0.0/0```（全てのIPアドレス）の範囲内にあれば，インターネットゲートウェイを送信先に選ぶ．

| Destination（Private IPの範囲） |      Target      |
| :-----------------------------: | :--------------: |
|        ```10.0.0.0/16```        |      local       |
|         ```0.0.0.0/0```         | Internet Gateway |

![ルートテーブル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ルートテーブル.png)



### ネットワークACL



### データベース

#### ・AWSが提供するデータベースの種類

データベースの種類については，別のノートを参照せよ．

|                        | Aurora | RDS  | DynamoDB | ElasticCache |
| :--------------------: | :----: | :--: | :------: | :----------: |
| **データベースの種類** |  RDB   | RDB  |  NoSQL   |              |



### オートスケーリング

#### ・オートスケーリングとは

ユーザが指定した条件で，EC2の自動水平スケーリングを行う．他のスケーリングについては，ネットワークのノートを参照．

| スケールアウト      | スケールイン        |
| ------------------- | ------------------- |
| ・起動するEC2の個数 | ・終了するEC2の条件 |

![Auto-scaling](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Auto-scaling.png)



## 02-02. プライベートネットワーク間の接続

### VPCピアリング接続

#### ・VPCピアリング接続とは

異なるVPCにあるAWSのサービス間で，相互にデータ通信を行うことができる．

![VPCピアリング接続](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VPCピアリング接続.png)



### 接続の可否の条件

#### ・条件一覧

| アカウント   | VPCのあるリージョン | VPC内のCIDRブロック    | 接続の可否 |
| ------------ | ------------------- | ---------------------- | ---------- |
| 同じ／異なる | 同じ／異なる        | 全て異なる             | **〇**     |
|              |                     | 同じものが一つでもある | ✕          |

#### ・CIDRブロックが同じ場合

VPC に複数の IPv4 CIDR ブロックがあり，一つでも 同じCIDR ブロックがある場合は、VPC ピアリング接続はできない．

![VPCピアリング接続不可の場合-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VPCピアリング接続不可の場合-1.png)

たとえ，IPv6が異なっていても，同様である．

![VPCピアリング接続不可の場合-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/VPCピアリング接続不可の場合-2.png)



## 03. ECSを用いたプライベートネットワーク構成

### クラウドデザイン例

![Fargateを用いたクラウドデザインの一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Fargateを用いたクラウドデザインの一例.png)



### Fargate



### クラスター

#### ・クラスターとは

タスクとサービスをグルーピングしたもの．

![ECSクラスター](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ECSクラスター.png)



### タスク，タスク定義

![タスクとタスク定義](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/タスクとタスク定義.png)

#### ・タスクとは

タスク（コンテナの集合）をどのような設定値（```json```形式ファイル）に基づいて構築するかを設定できる．タスク定義は，バージョンを示す「リビジョンナンバー」で番号づけされる．

#### ・ネットワークモードとは

| 項目   | 相当するDockerのネットワーク機能 |
| ------ | -------------------------------- |
| bridge | bridgeネットワーク               |
| host   | hostネットワーク                 |
| awsvpc | なし                             |

#### ・タスクサイズとは

| 項目         | 内容                                     |
| ------------ | ---------------------------------------- |
| タスクメモリ | タスク当たりのコンテナの合計メモリ使用量 |
| タスクCPU    | タスク当たりのコンテナの合計CPU使用量    |

#### ・コンテナ定義とは

タスク内のコンテナ一つに対して，環境を設定する．

| 項目             | 内容                                                         | 対応するdockerコマンドオプション             |
| ---------------- | ------------------------------------------------------------ | -------------------------------------------- |
| メモリ制限       | プロセスが使用できるメモリの閾値を設定．                     | ```--memory```<br>```--memory-reservation``` |
| ポートマッピング | ホストOSに対して，コンテナのポートを解放．                   | ```--publish```                              |
| ヘルスチェック   | コンテナからホストOSに対して，```curl```コマンドによるリクエストを送信し，レスポンス内容を確認． | ```--health-cmd```                           |
| 間隔             | ヘルスチェックの間隔を設定．                                 | ```--health-interval```                      |
| 再試行           | ヘルスチェックを成功と見なす回数を設定．                     | ```--health-retries```                       |
| CPUユニット数    | 仮想cpu数                                                    | ```--cpus```                                 |
| ホスト名         | コンテナにホスト名を設定．                                   | ```--hostname```                             |
| DNSサーバ        | コンテナが名前解決に使用するDNSサーバのIPアドレスを設定      | ```--dns```                                  |
| マウントポイント |                                                              |                                              |
| ボリュームソース | Volumeマウントを行う．                                       | ```--volumes-from```                         |
| ulimit           |                                                              | Linuxコマンドの<br>```--ulimit```に相当      |
| 制約             | タスク（コンテナの集合）の配置の割り振り方を設定．<br>・Spread：タスクを各場所にバランスよく配置<br>・Binpack：タスクを一つの場所にできるだけ多く配置． |                                              |



### サービス

#### ・サービスとは

タスク定義に基づいたタスクを，どのように自動的に配置するかを設定できる，タスク定義一つに対して，サービスを一つ定義する．

| 項目           | 内容                                                         |
| -------------- | ------------------------------------------------------------ |
| タスクの数     | タスクの構築数をいくつに維持するかを設定．タスクが何らかの原因で停止した場合，空いているリソースを使用して，タスクが自動的に補填される． |
| デプロイメント | ローリングアップデートと，Blue/Greenデプロイがある．         |

#### ・ローリングアップデートとは

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. ローリングアップデートによって，タスク定義を基に，新しいタスクがリリースされる．

#### ・CodeDeployを使用したBlue/Greenデプロイとは

![Blue-Greenデプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Blue-Greenデプロイ.jpeg)

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. CodeDeployによって，タスク定義を基に，現行の本番環境のタスク（ブルー）とは別に，新しい本番環境（グリーン）が構築される．ロードバランサーの接続先をブルーからグリーンのターゲットグループに切り替え，テストを行う．問題なければリリースする．



### ECR

#### ・タグの変性／不変性



## 04. IAM：Identify and Access Management

### ユーザ

#### ・ルートユーザとは

全ての権限をもったアカウントのこと．

#### ・IAMユーザとは

特定の権限をもったアカウントのこと．

### グループ

#### ・グループとは

IAMユーザをグループ化したもの．グループごとにロールを付与すれば，IAMユーザのロールを管理しやすくなる．

![グループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/グループ.png)

### ロール

#### ・ロールとは

#### ・ロールを付与する方法

まず，グループに対して，ロールを紐づける．そのグループに対して，ロールを付与したいIAMユーザを追加していく．

![グループに所属するユーザにロールを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/グループに所属するユーザにロールを付与.png)



### ポリシー

#### ・ポリシーとは



