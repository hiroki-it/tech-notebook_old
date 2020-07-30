# Amazon Web Service

## 01. AWSにおけるグローバルネットワーク構成

AWSから，グローバルIPアドレスと完全修飾ドメイン名が提供され，Webサービスがリリースされる．

### クラウドデザイン例

以下のデザイン例では，Dualシステムが採用されている．

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AWSのクラウドデザイン一例.png)

### ACM：Amazon Certificate Manager

#### ・ACMとは

認証局であるATSによって認証されたSSLサーバ証明書を管理できるサービス．

| 自社の中間認証局名         | ルート認証局名 |
| -------------------------- | -------------- |
| ATS：Amazon Trust Services | Starfield社    |

#### ・SSLサーバ証明書の設置場所パターン

AWSの使用上，ACM証明書を設置できないサービスに対しては，外部の証明書を手に入れて設置する．HTTPSによるSSLプロトコルを受け付けるネットワークの最終地点のことを，SSLターミネーションという．

| パターン<br>（Route53には必ず設置）          | SSLターミネーション<br>（HTTPSの最終地点） |
| -------------------------------------------- | ------------------------------------------ |
| Route53 → ALB(+ACM証明書) → EC2              | ALB                                        |
| Route53 → ALB(+ACM証明書) → EC2(+外部証明書) | EC2                                        |
| Route53 → NLB → EC2(+外部証明書)             | EC2                                        |
| Route53 → EC2(+外部証明書)                   | EC2                                        |
| Route53 → CloudFront(+ACM証明書) → ALB → EC2 | CloudFront                                 |
| Route53 → CloudFront(+ACM証明書) → EC2       | CloudFront                                 |
| Route53 → CloudFront(+ACM証明書) → S3        | CloudFront                                 |
| Route53 → Lightsail(+ACM証明書)              | Lightsail                                  |

#### ・セキュリティポリシー

許可するプロトコルを定義したルールこと．SSL/TLSプロトコルを許可しており，対応できるバージョンが異なるため，ブラウザがそのバージョンのSSL/TLSプロトコルを使用できるかを認識しておく必要がある．

|                      | Policy-2016-08 | Policy-TLS-1-1 | Policy-TLS-1-2 |
| -------------------- | :------------: | :------------: | :------------: |
| **Protocol-TLSv1**   |       〇       |       ✕        |       ✕        |
| **Protocol-TLSv1.1** |       〇       |       〇       |       ✕        |
| **Protocol-TLSv1.2** |       〇       |       〇       |       〇       |



### Route53（＝DNSサーバ）

#### ・Route53とは

クラウドDNSサーバーとして働く．リクエストされた完全修飾ドメイン名とEC2のグローバルIPアドレスをマッピングしている．

![URLと電子メールの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/URLと電子メールの構造.png)

#### ・レコードタイプ

| レコードタイプ | 名前解決の仕組み（1） |      |    （2）    |      |    （3）    |
| -------------- | :-------------------: | :--: | :---------: | :--: | :---------: |
| A              |  完全修飾ドメイン名   |  →   | Public IPv4 |  →   |      -      |
| AAAA           |  完全修飾ドメイン名   |  →   | Public IPv6 |  →   |      -      |
| CNAME          |  完全修飾ドメイン名   |  →   | エイリアス  |  →   | Public IPv4 |

#### ・エイリアス

ルーティング先のAWSサービスのホスト名を設定する．ALBがルーティング先であれば，ALBのDNS名を設定する．

#### ・DNS検証

CNAMEレコードを用いて，ドメインの所有者であることを証明する方法．ACMによって生成されたCNAMEレコードランダムトークンをRoute53に設定しておけば，ACMがこれを元に定期的に検証し．証明書を自動更新してくれる．

#### （1）完全修飾ドメイン名に対応するIPアドレスのレスポンス

![Route53の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Route53の仕組み.png)

1. クライアントPCは，完全修飾ドメイン名を，フォワードProxyサーバにリクエスト．

2. フォワードProxyサーバは，完全修飾ドメイン名を，リバースProxyサーバに代理リクエスト．

3. リバースProxyサーバは，完全修飾ドメイン名を，DNSサーバに代理リクエスト．

4. Route53は，DNSサーバとして機能する．完全修飾ドメインにマッピングされるIPv4アドレスを取得し，リバースProxyサーバにレスポンス．

   |     完全修飾ドメイン名      |  ⇄   |     IPv4アドレス      |
   | :-------------------------: | :--: | :-------------------: |
   | ```http://www.kagoya.com``` |      | ```203.142.205.139``` |

5. リバースProxyサーバは，IPv4アドレスを，フォワードProxyサーバに代理レスポンス．（※NATによるIPv4アドレスのネットワーク間変換が起こる）

6. フォワードProxyサーバは，IPv4アドレスを，クライアントPCに代理レスポンス．

#### （2）IPアドレスに対応するWebページのレスポンス

1. クライアントPCは，レスポンスされたIPv4アドレスを基に，Webページを，リバースProxyサーバにリクエスト．
2. リバースProxyサーバは，Webページを，Webサーバに代理リクエスト．
3. EC2は，Webページを，リバースProxyサーバにレスポンス．
4. リバースProxyサーバは，Webページを，クライアントPCに代理レスポンス．



### CloudFront（＝プロキシサーバ）

#### ・CloudFrontとは

クラウドプロキシサーバとして働く．リクエストを受け付ける．動的コンテンツの場合は，リクエストをEC2に振り分ける．また，静的コンテンツの場合は，キャッシュした上でAmazon S3へ振り分ける．

![CloudFront](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudFront.png)

### CloudTrail

#### ・CloudTrailとは

IAMユーザによる操作や，ロールのアタッチの履歴を記録し，ログファイルとしてS3に転送する．CloudWatchと連携することもできる．

![CloudTrailとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudTrailとは.jpeg)



### S3：Simple Storage Service（＝外付けストレージ）

#### ・S3とは

クラウド外付けストレージとして働く．Amazon S3に保存するCSSファイルや画像ファイルを管理できる．



### API Gateway

#### ・API Gatewayとは

API Gatewayは，メソッドリクエスト，統合リクエスト，統合レスポンス，メソッドレスポンス，から構成される．

![APIGatewayの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/APIGatewayの仕組み.png)

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

![AmazonSQSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AmazonSQSとは.jpeg)

#### ・SQSの種類

スタンダード方式キューとFIFO方式：First In First Outキューがある．



### Lambda

#### ・Lambdaとは

Lambdaを軸に他のFaaSと連携させることによって，ユーザ側は関数プログラムを作成しさえすれば，これを実行することができる．この方法を，『サーバレスアーキテクチャ』という．

![サーバレスアーキテクチャとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/サーバレスアーキテクチャとは.png)



### CloudWatch


#### ・コマンド

```bash
# CloudWatchの状態を変更する．
aws cloudwatch set-alarm-state --alarm-name "Alarm名" --state-value ALARM --state-reason "アラーム文言"
```

#### ・CloudWatchエージェント

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

####  ・CloudWatch Logs（＝ ログ収集サーバ）とは

AWSの各種サービスで生成されたログファイルを収集できる．

#### ・CloudWatch Events

イベントやスケジュールを検知し，指定したアクションを行う．

| イベント例                | スケジュール例       |      | アクション例              |
| ------------------------- | -------------------- | ---- | ------------------------- |
| APIのコール               | Cron形式での日時指定 | ⇒    | Lambdaによる関数の実行    |
| AWSコンソールへのログイン |                      | ⇒    | SQSによるメッセージの格納 |
| インスタンスの状態変化    |                      | ⇒    | SNSによるメール通知       |
| ...                       | ...                  | ⇒    | ...                       |



### CodeDeploy

#### ・appspecファイル

デプロイの設定を行う．

```yaml
version: 0.0

Resources:
  - TargetService:
      # 使用するサービス
      Type: AWS::ECS::Service
      Properties:
        # 使用するタスク定義．<TASK_DEFINITION> とすると，自動補完してくれる．
        TaskDefinition: "<TASK_DEFINITION>"
        # 使用するロードバランサー
        LoadBalancerInfo:
          ContainerName: "xxx-container"
          ContainerPort: "80"
```



## 02. AWSにおけるプライベートネットワーク構成

### クラウドデザイン例（再掲）

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AWSのクラウドデザイン一例.png)



### RegionとAvailability Zone

#### ・Regionとは

2016年1月6日時点では，以下のRegionに物理サーバのデータセンターがある．

![AWSリージョンマップ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AWSリージョンマップ.PNG)

#### ・Availability Zone

Regionは，さらに，各データセンターは物理的に独立したAvailability Zoneというロケーションから構成されている．例えば，東京Regionには，3つのAvailability Zoneがある．AZの中に，VPC subnetを作ることができ，そこにEC2を構築できる．



### セキュリティグループ（＝ パケットフィルタリング型ファイアウォール）

#### ・セキュリティグループとは

クラウドパケットフィルタリング型ファイアウォールとして働く．インバウンド（受信ルール）では，プロトコルや受信元IPアドレスを設定でき，アウトバウンド（送信ルール）では，プロトコルや送信先プロトコルを設定できる．

#### ・パケットフィルタリング型ファイアウォールとは（セキュリティのノートを参照せよ）

パケットのヘッダ情報に記載された送信元IPアドレスやポート番号などによって，パケットを許可するべきかどうかを決定する．速度を重視する場合はこちら．ファイアウォールとWebサーバの間には，NATルータやNAPTルータが設置されている．これらによる送信元Private IPアドレスから送信元グローバルIPアドレスへの変換についても参照せよ．

![パケットフィルタリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パケットフィルタリング.gif)



### VPC：Virtual Private Cloud（＝プライベートネットワーク）

#### ・VPCとは

クラウドプライベートネットワークとして働く．Private IPアドレスが割り当てられた，VPCと呼ばれるプライベートネットワークを仮想的に構築することができる．異なるAvailability Zoneに渡ってEC2を立ち上げることによって，クラウドサーバをデュアル化することできる．

![VPCが提供できるネットワークの範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCが提供できるネットワークの範囲.png)




### VPC subnet

クラウドプライベートネットワークにおけるセグメントとして働く．

#### ・Public subnetとは

非武装地帯に相当する．攻撃の影響が内部ネットワークに広がる可能性を防ぐために，外部から直接リクエストを受ける，

#### ・Private subnetとは

内部ネットワークに相当する．外部から直接リクエストを受けずにレスポンスを返せるように，内のNATを経由させる必要がある．

![パブリックサブネットとプライベートサブネットの設計](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パブリックサブネットとプライベートサブネットの設計.png)

#### ・同一VPC内の各AWSサービスに割り当てる最低限のIPアドレス数

一つのVPC内には複数のSubnetが入る．そのため，SubnetのIPアドレス範囲は，Subnetの個数だけ狭めなければならない．また，VPCがもつIPアドレス範囲から，VPC内の各AWSサービスにIPアドレスを割り当てていかなければならない．VPC内でIPアドレスが枯渇しないように，　以下の手順で，割り当てを考える．

1. rfc1918 に準拠し，VPCに以下の範囲内でIPアドレスを割り当てる．

| IPアドレス                                | サブネットマスク（CIDR形式） | 範囲                 |
| ----------------------------------------- | ---------------------------- | -------------------- |
| ```10.0.0.0```  ~ ```10.255.255.255```    | ```/8```                     | ```10.0.0.0/8```     |
| ```172.16.0.0``` ~ ```172.31.255.255```   | ```/12```                    | ```172.16.0.0/12```  |
| ```192.168.0.0``` ~ ```192.168.255.255``` | ```/16```                    | ```192.168.0.0/16``` |

2. VPC内の各AWSサービスにIPアドレス範囲を割り当てる．

| AWSサービスの種類     | 最低限のIPアドレス数                    |
| ------------------ | --------------------------------------- |
| ALB                | ALB1つ当たり，8個                       |
| オートスケーリング | 水平スケーリング時のEC2最大数と同じ個数 |
| VPCエンドポイント  | VPCエンドポイント1つ当たり，1個         |
| ECS                | Elastic Network Interface 数と同じ個数  |
| Lambda             | Elastic Network Interface 数と同じ個数  |



### VPCエンドポイント

#### ・VPCエンドポイントとは

NATとインターネットゲートウェイを経由せずにVPCの外側と通信できるため，NATの負荷を抑え，またより安全に通信できる．

![VPCエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCエンドポイント.png)



### ALB：Application Load Balancing（＝ リバースプロキシサーバ ＋ ロードバランサー）

#### ・ALBとは

リバースプロキシサーバかつロードバランサーとして働く．リクエストを代理で受信し，インスタンスへのアクセスをバランスよく分配することによって，サーバへの負荷を緩和する．

#### ・機能

![ターゲットグループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ターゲットグループ.jpg)

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

![InternetGatewayとNATGateway](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/InternetGatewayとNATGateway.png)



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

![ルートテーブル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ルートテーブル.png)



### ネットワークACL



### データベース

#### ・データベースエンジンとDBMSの種類

| データベースエンジン | DBMS              |
| -------------------- | ----------------- |
| Amazon Aurora        | MySQL／PostgreSQL |
| MariaDB              | MariaDB           |
| MySQL                | MySQL             |
| PostgreSQL           | PostgreSQL        |







### ElastiCache

| Redis  | Memcached |
| ------ | --------- |
| 要学習 | 要学習    |
| 要学習 | 要学習    |
| 要学習 | 要学習    |



### オートスケーリング

#### ・オートスケーリングとは

ユーザが指定した条件で，EC2の自動水平スケーリングを行う．他のスケーリングについては，ネットワークのノートを参照．

| スケールアウト      | スケールイン        |
| ------------------- | ------------------- |
| ・起動するEC2の個数 | ・終了するEC2の条件 |

![Auto-scaling](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Auto-scaling.png)



## 02-02. プライベートネットワーク間の接続

### VPCピアリング接続

#### ・VPCピアリング接続とは

異なるVPCにあるAWSのサービス間で，相互にデータ通信を行うことができる．

![VPCピアリング接続](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続.png)



### 接続の可否の条件

#### ・条件一覧

| アカウント   | VPCのあるリージョン | VPC内のCIDRブロック    | 接続の可否 |
| ------------ | ------------------- | ---------------------- | ---------- |
| 同じ／異なる | 同じ／異なる        | 全て異なる             | **〇**     |
|              |                     | 同じものが一つでもある | ✕          |

#### ・CIDRブロックが同じ場合

VPC に複数の IPv4 CIDR ブロックがあり，一つでも 同じCIDR ブロックがある場合は、VPC ピアリング接続はできない．

![VPCピアリング接続不可の場合-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-1.png)

たとえ，IPv6が異なっていても，同様である．

![VPCピアリング接続不可の場合-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-2.png)



## 03. ECSを用いたプライベートネットワーク構成

### クラウドデザイン例

![Fargateを用いたクラウドデザインの一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Fargateを用いたクラウドデザインの一例.png)



### Fargate



### クラスター

#### ・クラスターとは

タスクとサービスをグルーピングしたもの．

![ECSクラスター](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ECSクラスター.png)



### タスク，タスク定義

![タスクとタスク定義](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/タスクとタスク定義.png)

#### ・タスクとは

タスク（コンテナの集合）をどのような設定値（```json```形式ファイル）に基づいて構築するかを設定できる．タスク定義は，バージョンを示す「リビジョンナンバー」で番号づけされる．

#### ・ネットワークモード

| 項目   | 相当するDockerのネットワーク機能 |
| ------ | -------------------------------- |
| bridge | bridgeネットワーク               |
| host   | hostネットワーク                 |
| awsvpc | なし                             |

#### ・タスクサイズ

| 項目         | 内容                                     |
| ------------ | ---------------------------------------- |
| タスクメモリ | タスク当たりのコンテナの合計メモリ使用量 |
| タスクCPU    | タスク当たりのコンテナの合計CPU使用量    |

#### ・コンテナ定義

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
| タスクの数     | タスクの構築数をいくつに維持するかを設定．タスクが何らかの原因で停止した場合，空いているAWSサービスを使用して，タスクが自動的に補填される． |
| デプロイメント | ローリングアップデートと，Blue/Greenデプロイがある．         |

#### ・ローリングアップデート

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. ローリングアップデートによって，タスク定義を基に，新しいタスクがリリースされる．

#### ・CodeDeployを使用したBlue/Greenデプロイ

![Blue-Greenデプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Blue-Greenデプロイ.jpeg)

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを作成．
3. サービスを更新．
4. CodeDeployによって，タスク定義を基に，現行の本番環境のタスク（ブルー）とは別に，新しい本番環境（グリーン）が構築される．ロードバランサーの接続先をブルーからグリーンのターゲットグループに切り替え，テストを行う．問題なければリリースする．



### ECR

#### ・タグの変性／不変性



## 04. IAM：Identify and Access Management

### IAMポリシー，IAMステートメント

#### ・IAMポリシーとは

実行権限のあるアクションが定義されたIAMステートメントのセットを持つ，JSON型オブジェクトデータのこと．

#### ・IAMポリシーの種類

| IAMポリシーの種類    | 意味 |
| -------------------- | ---- |
| アクセス許可ポリシー |      |
| 信頼関係ポリシー     |      |

**【具体例】**

以下に，EC2の読み出しのみ権限（```AmazonEC2ReadOnlyAccess```）を付与できるポリシーを示す．このIAMポリシーには，他のAWSサービスに対する権限も含まれている．

```yaml
# AmazonEC2ReadOnlyAccess
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
```

####  ・IAMステートメントとは

実行権限のあるアクションを定義した，JSON型オブジェクトデータのこと．

**【具体例】**

以下に，```AmazonEC2ReadOnlyAccess```に含まれるIAMステートメントの一つを示す．```elasticloadbalancing:XXX```を用いて，ELBに対する実行権限を定義できる．ここでは，```Describe```の文字から始まるアクションの権限が与えられている．

```yaml
{
# ~~~ 省略 ~~~
    "Statement": [    
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
    ]
# ~~~ 省略 ~~~
}
```

以下に，```Describe```の文字から始まるアクションをいくつか示す．


| アクション名                | 権限                                                         | アクセスレベル |
| --------------------------- | ------------------------------------------------------------ | -------------- |
| ```DescribeLoadBalancers``` | 指定されたロードバランサーの説明を表示できる．               | 読み出し       |
| ```DescribeRules```         | 指定されたルール，または指定されたリスナーのルールの説明を表示できる． | 読み出し       |
| ```DescribeTargetGroups```  | 指定されたターゲットグループまたはすべてのターゲットグループの説明を表示できる． | 読み出し       |

#### ・ポリシータイプ

| ポリシータイプ      | 意味                               |
| ------------------- | ---------------------------------- |
| ユーザによる管理    | ユーザが新しく作成したポリシー     |
| AWSによる管理       | デフォルトで作成されているポリシー |
| AWS管理のジョブ機能 |                                    |



### IAMポリシーを付与できる対象

#### ・IAMユーザに対する付与

![IAMユーザにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMユーザにポリシーを付与.jpeg)

#### ・IAMグループに対する付与

![IAMグループにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMグループにポリシーを付与.jpeg)

#### ・IAMロールに対する付与

![IAMロールにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMロールにポリシーを付与.jpeg)



### ルートユーザ，IAMユーザ

#### ・ルートユーザとは

全ての権限をもったアカウントのこと．

#### ・IAMユーザとは

特定の権限をもったアカウントのこと．

### IAMグループ

#### ・IAMグループとは

IAMユーザをグループ化したもの．IAMグループごとにIAMロールを付与すれば，IAMユーザのIAMロールを管理しやすくなる．

![グループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループ.png)

### IAMロール

#### ・IAMロールとは

IAMポリシーのセットを持つ

#### ・IAMロールの種類

| IAMロールの種類                  | 意味                                        |
| -------------------------------- | ------------------------------------------- |
| サービスロール                   | AWSのサービスに対して付与するためのロール． |
| クロスアカウントのアクセスロール |                                             |
| プロバイダのアクセスロール       |                                             |

#### ・IAMロールを付与する方法

まず，IAMグループに対して，IAMロールを紐づける．そのIAMグループに対して，IAMロールを付与したいIAMユーザを追加していく．

![グループに所属するユーザにロールを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループに所属するユーザにロールを付与.png)


