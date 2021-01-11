# Amazon Web Service

## 01. コンピューティング｜EC2

### EC2

#### ・EC2とは

クラウドサーバとしては働く．注意点があるものだけまとめる．

| 設定項目                  | 説明                                              |                                                              |
| ------------------------- | ------------------------------------------------- | ------------------------------------------------------------ |
| AMI：Amazonマシンイメージ | OSを選択する．                                    | ベンダー公式のものを選択すること．（例：CentOSのAMI一覧 https://wiki.centos.org/Cloud/AWS） |
| インスタンスの詳細設定    | EC2インスタンスの設定する．                       | ・インスタンス自動割り当てパブリックにて，EC2に動的パブリックIPを割り当てる．EC2インスタンス構築後に有効にできない．<br/>・終了保護は必ず有効にすること． |
| ストレージの追加          | EBSボリュームを設定する．                         | 一般的なアプリケーションであれば，20～30GiBでよい．踏み台サーバの場合，最低限で良いため，OSの下限までサイズを下げる．（例：AmazonLinuxの下限は8GiB，CentOSは10GiB） |
| キーペア                  | EC2の秘密鍵に対応した公開鍵をインストールできる． | キーペアに割り当てられるフィンガープリント値を調べることで，公開鍵と秘密鍵の対応関係を調べることができる． |


#### ・キーペアのフィンガープリント値

ローカルに置かれている秘密鍵が，該当するEC2に置かれている公開鍵とペアなのかどうか，フィンガープリント値を照合して確認する方法

```sh
$ openssl pkcs8 -in <秘密鍵>.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
```

#### ・EC2へのSSH接続

クライアントのSSHプロトコルもつパケットは，まずインターネットを経由して，インターネットゲートウェイを通過する．その後，Route53，ALBを経由せず，そのままEC2へ向かう．

![SSHポートフォワード](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SSHポートフォワード.png)

<br>

## 01-02. コンピューティング｜Lambda

### Lambda

![サーバレスアーキテクチャとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/サーバレスアーキテクチャとは.png)

#### ・Lambdaとは

サーバレスでスクリプトを実行できる．Lambdaを軸に他のFaaSと連携させることによって，ユーザ側は関数プログラムを作成しさえすれば，これを実行することができる．

| 設定項目                           | 説明                                                         | 備考                                                         |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| メモリ                             | Lambdaに割り当てるメモリ量を設定する．                       | 最大10240MBまで増設でき，増設するほどパフォーマンスが上がる．インターネットで向上率グラフを検索せよ． |
| タイムアウト                       |                                                              |                                                              |
| 実行ロール                         | Lambda内のメソッドが実行される時に必要なポリシーをもつロールを設定する． |                                                              |
| 既存ロール                         | Lambdaにロールを設定する．                                   |                                                              |
| Lambdaレイヤー                     | 異なる関数の間で，特定の処理を共通化できる．                 |                                                              |
| プロビジョニングされた同時実行設定 | Lambdaは，関数の実行中に再びリクエストが送信されると，関数のインスタンスを新しく作成する．そして，各関数インスタンスを用いて，同時並行的にリクエストに応じる． |                                                              |
| ランタイム                         | 関数の実装に使用する言語を設定する．                         |                                                              |
| ハンドラ                           | 関数の実行時にコールしたい具体的メソッド名を設定する．       | ・Node.js：```index.js``` というファイル名で ```exports.handler``` メソッドを呼び出したい場合，ハンドラ名を```index.handler```とする |

#### ・最低限必要なポリシー

Lambdaを実行するためには，デプロイされた関数を使用する権限が必要である．そのため，関数を取得するためのステートメントを設定する．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:<リージョン>:<アカウントID>:function:<関数名>*"
    }
  ]
}
```

#### ・テストとデバッグ

Lambdaで関数を作成すると，CloudWatch Logsのロググループに，「```/aws/lambda/<関数名>```」というグループが自動的に作成される．Lambdaの関数内で発生したエラーや```console.log```メソッドのログはここに出力されるため，都度確認すること．

<br>

### ハンドラ関数

#### ・ハンドラ関数は

Lambdaはハンドラ関数をコールし，引数のオブジェクト（event，context，callback）に値をわたす．このオブジェクトにはメソッドとプロパティを持つ．ハンドラ関数の初期名は```handler```であるが別名でもよい．

**＊実装例＊**

基本的に，どの言語でもハンドラ関数の引数は共通している．実装例として，Node.jsの場合を示す．

```javascript
exports.MyHandler = (event, context, callback) => {
  // なんらかの処理
}
```

| 引数                 | 説明                                                         | 備考                                                         |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| eventオブジェクト    | HTTPリクエストに関するデータが格納されている．               | Lambdaにリクエストを送信するAWSリソースごとに，オブジェクトの構造が異なる．構造は以下の通り．<br>参考：https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-services.html |
| contextオブジェクト  | Lambdaに関するデータ（名前，バージョンなど）を取得できるメソッドとプロパティが格納されている． | オブジェクトの構造は以下の通り<br>参考：https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/nodejs-context.html |
| callbackオブジェクト |                                                              |                                                              |

<br>

### Node.jsを用いた関数例

#### ・AWS-SDKの読み込み

**＊実装例＊**

```javascript
// AWS SDK for JavaScript を読み込む
const aws = require('aws-sdk');
```

#### ・API Gateway & Lambda & S3

**＊実装例＊**

```javascript
"use strict";

const aws = require('aws-sdk');

const s3 = new aws.S3();

exports.handler = (event, context, callback) => {
    
  // API Gatewayとのプロキシ統合を意識したJSON構造にする
  // レスポンスメッセージの初期値
  const response = {
      "statusCode": null,
      "body" : null
  };
  
  s3.putObject({
      Bucket: '<バケット名>',
      Key: '<パスを含む保存先ファイル>',
      Body: '<保存データ>',
    },
    (err, data) => {
      if (err) {
          response.statusCode = 500;
          response.body = "[ERROR] " + err;
          return callback(null, response);
      }
      response.statusCode = 200;
      response.body = "OK";
      return callback(null, response);
    });
}
```

また，LambdaがS3に対してアクションを実行できるように，事前に，AWS管理ポリシーの「```AWSLambdaExecute```」が付与されたロールをLambdaにアタッチしておく必要がある．

<br>

## 01-03. コンピューティング｜Lambda@Edge

### Lambda@Edge

![Lambda@Edge](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Lambda@Edge.png)

#### ・Lambda@Edgeとは

Cloud Frontに統合されたLambdaを，特別にLambda@Edgeという．Cloud Frontのビューワーリクエスト，オリジンリクエスト，オリジンレスポンス，ビューワーレスポンス，をトリガーとする．エッジロケーションのCloud Frontに，Lambdaのレプリカが構築される．

| トリガーの種類       | 発火のタイミング                                             |
| -------------------- | ------------------------------------------------------------ |
| ビューワーリクエスト | Cloud Frontが，ビューワーからリクエストを受信した後（キャッシュを確認する前）． |
| オリジンリクエスト   | Cloud Frontが，リクエストをオリジンサーバーに転送する前（キャッシュを確認した後）． |
| オリジンレスポンス   | Cloud Frontが，オリジンからレスポンスを受信した後（キャッシュを確認する前）． |
| ビューワーレスポンス | Cloud Frontが，ビューワーにレスポンスを転送する前（キャッシュを確認した後）． |

#### ・最低限必要なポリシー

Lambda@Edgeを実行するためには，最低限，以下の権限が必要である．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:GetFunction",
        "lambda:EnableReplication*"
      ],
      "Resource": "arn:aws:lambda:<リージョン名>:<アカウントID>:function:<関数名>:<バージョン>"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:UpdateDistribution"
      ],
      "Resource": "arn:aws:cloudfront::<アカウントID>:distribution/<DistributionID>"
    }
  ]
}

```

#### ・各トリガーのeventオブジェクトへのマッピング

各トリガーのeventオブジェクトへのマッピングは，以下を参照せよ．

参考：https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html

<br>

### Node.jsを用いた関数例

#### ・オリジンの動的な切り替え

![Lambda@Edge_動的オリジン](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Lambda@Edge_動的オリジン.png)

**＊実装例＊**

eventオブジェクトの```domainName```と```host.value```に格納されたバケットのドメイン名によって，ルーティング先のバケットが決まる．そのため，この値を切り替えれば，動的オリジンを実現できる．なお，各バケットには同じOAIを設定する必要がある．

```javascript
'use strict';

exports.handler = (event, context, callback) => {

    const request = event.Records[0].cf.request;
    // ログストリームに変数を出力する．
    console.log(JSON.stringify({request}, null, 2));

    const headers = request.headers;
    const s3Backet = getBacketBasedOnDeviceType(headers);

    request.origin.s3.domainName = s3Backet
    request.headers.host[0].value = s3Backet
    // ログストリームに変数を出力する．
    console.log(JSONデータ.stringify({request}, null, 2));

    return callback(null, request);
};

/**
 * デバイスタイプに基づいて、オリジンを切り替える．
 * 
 * @param   {Object} headers
 * @param   {string} env
 * @returns {string} pcBucket|spBucket
 */
const getBacketBasedOnDeviceType = (headers) => {

    const pcBucket = env + '-bucket.s3.amazonaws.com';
    const spBucket = env + '-bucket.s3.amazonaws.com';

    if (headers['cloudfront-is-desktop-viewer']
        && headers['cloudfront-is-desktop-viewer'][0].value === 'true') {
        return pcBucket;
    }

    if (headers['cloudfront-is-tablet-viewer']
        && headers['cloudfront-is-tablet-viewer'][0].value === 'true') {
        return pcBucket;
    }

    if (headers['cloudfront-is-mobile-viewer']
        && headers['cloudfront-is-mobile-viewer'][0].value === 'true') {
        return spBucket;
    }

    return spBucket;
};
```

オリジンリクエストは，以下のeventオブジェクトのJSONデータにマッピングされている．なお，一部のキーは省略している．

```json
{
  "Records": [
    {
      "cf": {
        "request": {
          "body": {
            "action": "read-only",
            "data": "",
            "encoding": "base64",
            "inputTruncated": false
          },
          "clientIp": "nnn.n.nnn.nnn",
          "headers": {
            "host": [
              {
                "key": "Host",
                "value": "prd-sp-bucket.s3.ap-northeast-1.amazonaws.com"
              }
            ],
            "cloudfront-is-mobile-viewer": [
              {
                "key": "CloudFront-Is-Mobile-Viewer",
                "value": true
              }
            ],
            "cloudfront-is-tablet-viewer": [
              {
                "key": "loudFront-Is-Tablet-Viewer",
                "value": false
              }
            ],
            "cloudfront-is-smarttv-viewer": [
              {
                "key": "CloudFront-Is-SmartTV-Viewer",
                "value": false
              }
            ],
            "cloudfront-is-desktop-viewer": [
              {
                "key": "CloudFront-Is-Desktop-Viewer",
                "value": false
              }
            ],
            "user-agent": [
              {
                "key": "User-Agent",
                "value": "Amazon CloudFront"
              }
            ]
          },
          "method": "GET",
          "origin": {
            "s3": {
              "authMethod": "origin-access-identity",                
              "customHeaders": {
                  "env": [
                      {
                          "key": "env",
                          "value": "prd"
                      }
                  ]
              },
              "domainName": "prd-sp-bucket.s3.amazonaws.com",
              "path": "",
              "port": 443,
              "protocol": "https",
              "region": "ap-northeast-1"
            }
          },
          "querystring": "",
          "uri": "/images/12345"
        }
      }
    }
  ]
}
```

<br>

## 01-04. コンピューティング｜Security Group

### Security Group

#### ・Security Groupとは

アプリケーションのクラウドパケットフィルタリング型ファイアウォールとして働く．インバウンド通信（プライベートネットワーク向き通信）では，プロトコルや受信元IPアドレスを設定でき，アウトバウンド通信（グローバルネットワーク向き通信）では，プロトコルや送信先プロトコルを設定できる．

#### ・パケットフィルタリング型ファイアウォールとは

パケットのヘッダ情報に記載された送信元IPアドレスやポート番号などによって，パケットを許可するべきかどうかを決定する．速度を重視する場合はこちら．ファイアウォールとWebサーバの間には，NATルータやNAPTルータが設置されている．これらによる送信元プライベートIPアドレスから送信元グローバルIPアドレスへの変換についても参照せよ．

![パケットフィルタリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パケットフィルタリング.gif)

<br>

### インバウンドルール

#### ・セキュリティグループIDの紐づけ

ソースに対して，セキュリティグループIDを設定した場合，そのセキュリティグループがアタッチされているリソース（ネットワークインターフェースを含む）を許可することになる．リソースのIPアドレスが動的に変化する場合，有効な方法である．

#### ・アプリケーションEC2の例

ALBに割り振られる可能性のあるIPアドレスを許可するために，ALBのSecurity GroupのID，またはSubnetのIPアドレス範囲を設定する．

| タイプ | プロトコル | ポート    | ソース                       | 説明                        |
| ------ | ---------- | --------- | ---------------------------- | --------------------------- |
| HTTP   | TCP        | ```80```  | ALBのSecurity Group ID       | HTTP access from ALB        |
| HTTPS  | TCP        | ```443``` | 踏み台EC2のSecurity Group ID | SSH access from bastion EC2 |

#### ・踏み台EC2の例

| タイプ | プロトコル | ポート   | ソース                     | 説明                             |
| ------ | ---------- | -------- | -------------------------- | -------------------------------- |
| SSH    | TCP        | ```22``` | 社内のグローバルIPアドレス | SSH access from global ip addess |

#### ・EFSの例

EC2に割り振られる可能性のあるIPアドレスを許可するために，EC2のSecurity GroupのID，またはSubnetのIPアドレス範囲を設定する．

| タイプ | プロトコル | ポート     | ソース                                 | 説明                    |
| ------ | ---------- | ---------- | -------------------------------------- | ----------------------- |
| NFS    | TCP        | ```2049``` | アプリケーションEC2のSecurity Group ID | NFS access from app EC2 |

#### ・RDSの例

EC2に割り振られる可能性のあるIPアドレスを許可するために，EC2のSecurity GroupのID，またはSubnetのIPアドレス範囲を設定する．

| タイプ       | プロトコル | ポート     | ソース                                 | 説明                      |
| ------------ | ---------- | ---------- | -------------------------------------- | ------------------------- |
| MYSQL/Aurora | TCP        | ```3306``` | アプリケーションEC2のSecurity Group ID | MYSQL access from app EC2 |

#### ・Redisの例

EC2に割り振られる可能性のあるIPアドレスを許可するために，EC2のSecurity GroupのID，またはSubnetのIPアドレス範囲を設定する．

| タイプ      | プロトコル | ポート     | ソース                                 | 説明                    |
| ----------- | ---------- | ---------- | -------------------------------------- | ----------------------- |
| カスタムTCP | TCP        | ```6379``` | アプリケーションEC2のSecurity Group ID | TCP access from app EC2 |

#### ・ALBの例

Cloud Frontと連携する場合，Cloud Frontに割り振られる可能性のあるIPアドレスを許可するために，全てのIPアドレスを許可する．その代わりに，Cloud FrontにWAFを紐づけ，ALBの前でIPアドレスを制限するようにする．Cloud Frontとは連携しない場合，ALBのSecurity GroupでIPアドレスを制限するようにする．

| タイプ | プロトコル | ポート    | ソース          | 説明                          |      |
| ------ | ---------- | --------- | --------------- | ----------------------------- | ---- |
| HTTP   | TCP        | ```80```  | ```0.0.0.0/0``` | HTTP access from Cloud Front  |      |
| HTTPS  | TCP        | ```443``` | ```0.0.0.0/0``` | HTTPS access from Cloud Front |      |

<br>

### アウトバウンドルール

#### ・任意AWSリソースの例

| タイプ               | プロトコル | ポート | 送信先          | 説明        |
| -------------------- | ---------- | ------ | --------------- | ----------- |
| すべてのトラフィック | すべて     | すべて | ```0.0.0.0/0``` | Full access |

<br>

## 01-05. コンピューティングに付随する設定

### サービスレベル

#### ・Regionとは

物理サーバのあるデータセンターの地域名のこと．2020年時点では，以下の地点にデータセンターがある．

![AWSRegionMap](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AWSAWSRegionMap.png)

#### ・Globalとエッジロケーションとは

Regionとは別に，物理サーバが世界中にあり，これらの間ではグローバルネットワークが構築されている．そのため，Globalなサービスは，特定のRegionに依存せずに，全てのRegionと連携できる．

![EdgeLocation](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/EdgeLocation.png)

#### ・Availability Zoneとは

Regionは，さらに，各データセンターは物理的に独立したAvailability Zoneというロケーションから構成されている．例えば，東京Regionには，3つのAvailability Zoneがある．AZの中に，VPC subnetを作ることができ，そこにEC2を構築できる．

<br>

## 02. コンテナ｜ECS on Fargate

![NatGatewayを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateからECRECSへのアウトバウンド通信.png)

### ECS：Elastc Cotainer Service

#### ・ECSとは

コンテナを管理する環境．VPCの外に存在している．ECS，EKS，Fargate，EC2の対応関係は以下の通り．

| Control Plane（コンテナ管理環境） | Data Plane（コンテナ実行環境） |
| --------------------------------- | ------------------------------ |
| ECS                               | Fargate，EC2                   |
| EKS                               | Fargate，EC2                   |

#### ・クラスター

![ECSクラスター](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ECSクラスター.png)

<br>

### サービス

#### ・サービスとは

タスク数の維持管理を行う機能のこと．

| 設定項目                     | 説明                                                         | 備考                                                         |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| タスク定義                   | サービスで維持管理するタスクの定義ファミリー名とリビジョン番号を設定する． |                                                              |
| 起動タイプ                   | タスク内のコンテナの起動タイプを設定する．                   |                                                              |
| プラットフォームのバージョン | タスクの実行環境のバージョンを設定する．                     | バージョンによって，連携できるAWSリソースが異なる．          |
| サービスタイプ               |                                                              |                                                              |
| 最小ヘルス率                 |                                                              |                                                              |
| 最大率                       |                                                              |                                                              |
| ヘルスチェックの猶予期間     |                                                              |                                                              |
| タスクの最小数               | スケーリング時のタスク数の最小数を設定する．                 |                                                              |
| タスクの必要数               | 平常時のタスク数を設定する．                                 |                                                              |
| タスクの最大数               | スケーリング時のタスク数の最大数を設定する．                 |                                                              |
| ロードバランシング           | ALBでルーティングするコンテナを設定する．                    |                                                              |
| タスクの数                   | タスクの構築数をいくつに維持するかを設定する．               | タスクが何らかの原因で停止した場合，空いているAWSサービスを使用して，タスクが自動的に補填される． |
| デプロイメント               | ローリングアップデート，Blue/Greenデプロイがある．           |                                                              |

#### ・ターゲット追跡スケーリングポリシー

| 設定項目                           | 説明                                                         | 備考                                                         |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ターゲット追跡スケーリングポリシー | 監視対象のメトリクスがターゲット値を超過しているか否かに基づいて，タスク数のスケーリングが実行される． |                                                              |
| ECSサービスメトリクス              | 監視対象のメトリクスを設定する．                             | 「平均CPU」，「平均メモリ」，「タスク当たりのALBからのリクエスト数」を監視できる． |
| ターゲット値                       | タスク数のスケーリングが実行される閾値を設定する．           | ターゲット値を超過している場合に，タスク数がスケールアウトされる． |
| スケールアウトクールダウン期間     | スケールアウトを発動してから，次回のスケールアウトを発動できるまでの時間を設定する． | ターゲット値を超過する状態が断続的に続くと，スケールアウトが連続して実行されてしまうため，これを防ぐことができる． |
| スケールインクールダウン期間       | スケールインを発動してから，次回のスケールインを発動できるまでの時間を設定する． |                                                              |
| スケールインの無効化               |                                                              |                                                              |

1. 最小タスク数を2，必要タスク数を4，最大数を6，CPU平均使用率を40%に設定するとする．
2. 平常時，CPU使用率40%に維持される．
3. リクエストが増加し，CPU使用率55%に上昇する．
4. タスク数が6つにスケールアウトし，CPU使用率40%に維持される．
5. リクエスト数が減少し，CPU使用率が20%に低下する．
6. タスク数が2つにスケールインし，CPU使用率40%に維持される．

#### ・ローリングアップデート

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを構築．
3. サービスを更新．
4. ローリングアップデートによって，タスク定義を基に，新しいタスクがリリースされる．

#### ・CodeDeployを使用したBlue/Greenデプロイ

![Blue-Greenデプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Blue-Greenデプロイ.jpeg)

1. ECRのイメージを更新
2. タスク定義の新しいリビジョンを構築．
3. サービスを更新．
4. CodeDeployによって，タスク定義を基に，現行の本番環境（Prodブルー）のタスクとは別に，テスト環境（Testグリーン）が構築される．ロードバランサーの接続先を本番環境（Prodブルー）のターゲットグルーップ（Primaryターゲットグループ）から，テスト環境（Testグリーン）のターゲットグループに切り替える．テスト環境（Testグリーン）で問題なければ，これを新しい本番環境としてリリースする．

<br>

### タスク

![タスクとタスク定義](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/タスクとタスク定義.png)

#### ・タスク

グルーピングされたコンテナ群のこと

#### ・タスク定義とは

各タスクをどのような設定値に基づいて構築するかを設定できる．タスク定義は，バージョンを示す「リビジョンナンバー」で番号づけされる．タスク定義を削除するには，全てのリビジョン番号のタスク定義を登録解除する必要がある．

#### ・タスクロール

タスク内のコンテナが，他のリソースにアクセスするために必要なロールのこと．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
```

#### ・タスク実行ロール

タスク上に存在するコンテナエージェントが，他のリソースにアクセスするために必要なロールのこと．AWS管理ポリシーである「```AmazonECSTaskExecutionRolePolicy```」が付与されたロールを，タスクにアタッチする必要がある．このポリシーには，ECRへのアクセス権限の他，CloudWatch Logsにログを生成するための権限が設定されている．タスク内のコンテナに必要なタスクロールとは区別すること．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

#### ・割り当てられるプライベートIPアドレス

タスクごとに異なるプライベートIPが割り当てられる．このIPアドレスに対して，ALBはルーティングを行う．

#### ・ネットワークモードの詳細項目

| 設定項目 | 相当するDockerのネットワーク機能 | 備考                                                         |
| -------- | -------------------------------- | ------------------------------------------------------------ |
| bridge   | bridgeネットワーク               |                                                              |
| host     | hostネットワーク                 |                                                              |
| awsvpc   | awsの独自ネットワーク機能．      | タスクはElastic Network Interfaceと紐づけられ，PrimaryプライベートIPアドレスを割り当てられる． |

#### ・タスクサイズの詳細項目


| 設定項目     | 説明                                     |
| ------------ | ---------------------------------------- |
| タスクメモリ | タスク当たりのコンテナの合計メモリ使用量 |
| タスクCPU    | タスク当たりのコンテナの合計CPU使用量    |

#### ・新しいタスクを一時的に実行

現在起動中のECSタスクとは別に，新しいタスクを一時的に起動する．起動時に，```overrides```オプションを使用して，指定したタスク定義のコンテナ設定を上書きできる．正規表現で設定する必要があり，さらにJSONでは「```\```」を「```\\```」にエスケープしなければならない．コマンドが実行された後に，タスクは自動的にStopped状態になる．CI/CDツールで実行する以外に，ローカルから手動で実行する場合もある．

**＊実装例＊**

LaravelのSeederコマンドやロールバックコマンドをローカルから実行する．

```sh
#!/usr/bin/env bash

set -x

echo "Set Variables"
SERVICE_NAME="stg-ecs-service"
CLUSTER_NAME="stg-ecs-cluster"
TASK_NAME="stg-ecs-task-definition"
SUBNETS_CONFIG=$(aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} --query "services[].deployments[].networkConfiguration[].awsvpcConfiguration[].subnets[]")
SGS_CONFIG=$(aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} --query "services[].deployments[].networkConfiguration[].awsvpcConfiguration[].securityGroups[]")

echo "Run Task"
TASK_ARN=$(aws ecs run-task \
  --launch-type FARGATE \
  --cluster ${CLUSTER_NAME} \
  --platform-version "1.4.0" \
  --network-configuration "awsvpcConfiguration={subnets=${SUBNETS_CONFIG},securityGroups=${SGS_CONFIG}}" \
  --task-definition ${TASK_NAME} \
  --overrides "{\"containerOverrides\": [{\"name\": \"laravel-container\",\"command\": [\"php\", \"artisan\", \"db:seed\", \"--class=DummySeeder\", \"--force\"]}]}" \
  --query "tasks[0].taskArn" | tr -d '"')

echo "Wait until task stopped"
aws ecs wait tasks-stopped \
  --cluster ${CLUSTER_NAME} \
  --tasks ${TASK_ARN}

echo "Get task result"
RESULT=$(aws ecs describe-tasks \
  --cluster ${CLUSTER_NAME} \
  --tasks ${TASK_ARN})
echo ${RESULT}

EXIT_CODE=$(echo ${RESULT} | jq .tasks[0].containers[0].exitCode)
echo exitCode ${EXIT_CODE}
exit ${EXIT_CODE}
```

<br>

### Fargate起動タイプのコンテナ

#### ・コンテナエージェント

コンテナ内で稼働し，コンテナの操作を行うプログラムのこと．

#### ・コンテナ定義の詳細項目

タスク内のコンテナ一つに対して，環境を設定する．

参考：https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/userguide/task_definition_parameters.html

| 設定項目                         | 対応するdockerコマンドオプション             | 説明                                                         | 備考                                                         |
| -------------------------------- | -------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| cpu                              | ```--cpus```                                 | 仮想cpu数を設定する．                                        |                                                              |
| dnsServers                       | ```--dns```                                  | コンテナが名前解決に使用するDNSサーバのIPアドレスを設定する． |                                                              |
| essential                        |                                              | コンテナが必須か否かを設定する．                             | ・```true```の場合，コンテナが停止すると，タスクに含まれる全コンテナが停止する．<br>```false```の場合，コンテナが停止しても，その他のコンテナは停止しない． |
| healthCheck<br>(command)         | ```--health-cmd```                           | ホストマシンからFargateに対して，```curl```コマンドによるリクエストを送信し，レスポンス内容を確認． |                                                              |
| healthCheck<br>(interval)        | ```--health-interval```                      | ヘルスチェックの間隔を設定する．                             |                                                              |
| healthCheck<br>(retries)         | ```--health-retries```                       | ヘルスチェックを成功と見なす回数を設定する．                 |                                                              |
| hostName                         | ```--hostname```                             | コンテナにホスト名を設定する．                               |                                                              |
| image                            |                                              | ECRのURLを設定する．                                         |                                                              |
| logConfiguration<br/>(logDriver) | ```--log-driver```                           | ログドライバーを指定することにより，ログの出力先を設定する． | Dockerのログドライバーにおおよそ対応しており，Fargateであれば「awslogs，awsfirelens，splunk」に設定できる．EC2であれば「awslogs，json-file，syslog，journald，fluentd，gelf，logentries」を設定できる． |
| logConfiguration<br/>(options)   | ```--log-opt```                              | ログドライバーに応じて，詳細な設定を行う．                   |                                                              |
| portMapping                      | ```--publish```                              | ホストマシンとFargateのアプリケーションのポート番号をマッピングし，ポートフォワーディングを行う． |                                                              |
| secrets<br>(volumesFrom)         |                                              | SSMパラメータストアから参照する変数を設定する．              |                                                              |
| memory                           | ```--memory```<br>```--memory-reservation``` | プロセスが使用できるメモリの閾値を設定する．                 |                                                              |
| mountPoints                      |                                              |                                                              |                                                              |
| ulimit                           | Linuxコマンドの<br>```--ulimit```に相当      |                                                              |                                                              |

#### ・awslogsドライバー

| 設定項目                | 説明                                                         | 備考                                                         |
| ----------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| awslogs-group           | ログ送信先のCloudWatch Logsのロググループを設定する．        |                                                              |
| awslogs-datetime-format | 日時フォーマットを定義し，またこれをログの区切り単位としてログストリームに出力する． | 正規表現で設定する必要があり，さらにJSONでは「```\```」を「```\\```」にエスケープしなければならない．例えば「```\\[%Y-%m-%d %H:%M:%S\\]```」となる． |
| awslogs-region          | ログ送信先のCloudWatch Logsのリージョンを設定する．          |                                                              |
| awslogs-stream-prefix   | ログ送信先のCloudWatch Logsのログストリームのプレフィックス名を設定する． | ログストリームには，「```<プレフィックス名>/<コンテナ名>/<タスクID>```」の形式で送信される． |

<br>

### ECR

#### ・ライフサイクルポリシー

ECRのイメージの有効期間を定義できる．

| 設定項目             | 説明                                                         | 備考                                                         |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ルールの優先順位     | 順位の大きさで，ルールの優先度を設定できる．                 | 数字は連続している必要はなく，例えば，10，20，90，のように設定しても良い． |
| イメージのステータス | ルールを適用するイメージの条件として，タグの有無や文字列を設定できる． |                                                              |
| 一致条件             | イメージの有効期間として，同条件に当てはまるイメージが削除される閾値を設定できる． | 個数，プッシュされてからの期間，などを閾値として設定できる． |

#### ・タグの変性／不変性

<br>

### Tips

#### ・割り当てられるパブリックIPアドレス，FargateのIPアドレス問題

FargateにパブリックIPアドレスを持たせたい場合，Elastic IPアドレスの設定項目がなく，動的パブリックIPアドレスしか設定できない（Fargateの再構築後に変化する）．アウトバウンド通信の先にある外部サービスが，セキュリティ上で静的なIPアドレスを要求する場合，アウトバウンド通信（グローバルネットワーク向き通信）時に送信元パケットに付加されるIPアドレスが動的になり，リクエストができなくなってしまう．

![NatGatewayを介したFargateから外部サービスへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateから外部サービスへのアウトバウンド通信.png)

そこで，Fargateのアウトバウンド通信が，Elastic IPアドレスを持つNAT Gatewayを経由するようにする（Fargateは，パブリックサブネットとプライベートサブネットのどちらに置いても良い）．これによって，Nat GatewayのElastic IPアドレスが送信元パケットに付加されるため，Fargateの送信元IPアドレスを見かけ上静的に扱うことができるようになる．

#### ・VPCの外側に対するアウトバウト通信問題

タスク内のFargateは，VPCの外側にあるサービスに対して，アウトバウンド通信を送信するために，NATGatewayまたはVPCエンドポイントが必要である．料金的な観点から，VPCエンドポイントを使用した方がよい．

| VPCエンドポイントの接続先 | プライベートDNS名                                            | 説明                                               |
| ------------------------- | ------------------------------------------------------------ | -------------------------------------------------- |
| CloudWatch Logs           | ```logs.ap-northeast-1.amazonaws.com```                      | ECSコンテナのログをPOSTリクエストを送信するため．  |
| ECR                       | ```api.ecr.ap-northeast-1.amazonaws.com```<br>```*.dkr.ecr.ap-northeast-1.amazonaws.com``` | イメージのGETリクエストを送信するため．            |
| S3                        | なし                                                         | イメージのレイヤーをPOSTリクエストを送信するため   |
| SSM                       | ```ssm.ap-northeast-1.amazonaws.com```                       | SSMパラメータストアにGETリクエストを送信するため． |

例えば，FargateからECRに対するDockerイメージのプルは，VPCの外側に対するアウトバウンド通信（グローバルネットワーク向き通信）である．以下の通り，NAT Gatewayを設置したとする．この場合，ECSやECRとのアウトバウンド通信がNAT Gatewayを通過するため，高額料金を請求されてしまう．

![NatGatewayを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/NatGatewayを介したFargateからECRECSへのアウトバウンド通信.png)

そこで，ECR用のVPCエンドポイントを設け，これに対してアウトバウンド通信を行うようにするとよい．なお，NAT GatewayとVPCエンドポイントの両方を構築している場合，ルートテーブルでは，VPCエンドポイントへのアウトバウンド通信の方が優先される．

![PrivateLinkを介したFargateからECRECSへのアウトバウンド通信](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/PrivateLinkを介したFargateからECRECSへのアウトバウンド通信.png)

<br>

## 02-02. コンテナ｜ECS on EC2

### EC2起動タイプのコンテナ

#### ・タスク配置戦略

タスクをインスタンスに配置する時のアルゴリズムを選択できる．

| 戦略    | 説明                                         |
| ------- | -------------------------------------------- |
| Spread  | タスクを各場所にバランスよく配置する         |
| Binpack | タスクを一つの場所にできるだけ多く配置する． |
| Random  | タスクをランダムに配置する．                 |

<br>

## 03. ストレージ

### EBS：Elastic Block Storage

#### ・EBSとは

クラウド内蔵ストレージとして働く．

#### ・ストレージの種類とボリュームタイプ

| ストレージの種類 | ボリューム名            |
| ---------------- | ----------------------- |
| SSD              | 汎用SSD                 |
| SSD              | プロビジョンド IOPS SSD |
| HDD              | スループット最適化 HDD  |
| HDD              | Cold HDD                |

#### ・最小ボリューム

踏み台サーバを構築する時，できるだけ最小限のボリュームを選択し，ストレージ合計を抑える必要がある．

| OS           | 仮想メモリ | ボリュームサイズ |
| ------------ | ---------- | ---------------- |
| Amazon Linux | t2.micro   | 8                |
| CentOS       | t2.micro   | 10               |

<br>

### EFS：Elastic File System

![EFSのファイル共有機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/EFSのファイル共有機能.png)

#### ・EFSとは

マウントターゲットと接続されたEC2インスタンスから，ファイルを自身に転送し，これを管理する．ファイルの実体はEFSの中に存在しているため，接続を切断している間，EC2インスタンス内のファイルは無くなる．再接続すると，切断直前のファイルが再び表示されようになる．

| 設定項目                 | 説明                                                         | 備考                                                         |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ファイルシステム         | EFSに関する設定                                              |                                                              |
| ネットワークアクセス     | マウントターゲットを設置するサブネット，セキュリティグループを設定 | ・サブネットは，ファイル供給の速度の観点から，マウントターゲットにアクセスするAWSリソースと同じにする．<br>・セキュリティグループは，EC2からのNFSプロトコルアクセスを許可したものを設定する．EC2のセキュリティグループを通過したアクセスだけを許可するために，IPアドレスでは，EC2のセキュリティグループを設定する． |
| ファイルシステムポリシー | AWSリソースがEFSを利用する時のポリシーを設定する．           |                                                              |

#### ・マウントコマンド

DNS経由で，EFSマウントヘルパーを使用した場合を示す．

```sh
$ mount -t <ファイルシステムタイプ> -o tls <ファイルシステムID>:/ <マウントポイント>
```

```sh
# Amazon EFSで，マウントポイントを登録
$ mount -t efs -o tls fs-xxxxx:/ /var/www/app

# マウントポイントを解除
$ umount /var/www/app

# dfコマンドでマウントしているディレクトリを確認できる
$ df
Filesystem                                1K-blocks Used Available Use% Mounted on
fs-xxx.efs.ap-northeast-1.amazonaws.com:/ xxx       xxx  xxx       1%   /var/www/cerenavi
```

<br>

## 03-02. ストレージ｜S3

### S3：Simple Storage Service

#### ・S3とは

クラウド外付けストレージとして働く．Amazon S3に保存するCSSファイルや画像ファイルを管理できる．

| 設定項目             | 説明                       |
| -------------------- | -------------------------- |
| バケット             | バケットに関して設定する． |
| バッチオペレーション |                            |
| アクセスアナライザー |                            |

#### ・プロパティの詳細項目

| 設定項目                     | 説明 | 備考 |
| ---------------------------- | ---- | ---- |
| バージョニング               |      |      |
| サーバアクセスのログ記録     |      |      |
| 静的サイトホスティング       |      |      |
| オブジェクトレベルのログ記録 |      |      |
| デフォルト暗号化             |      |      |
| オブジェクトのロック         |      |      |
| Transfer acceleration        |      |      |
| イベント                     |      |      |
| リクエスタ支払い             |      |      |

#### ・外部／内部ネットワークからのアクセス制限の詳細項目

| 設定項目                   | 説明                                                        | 備考                                                         |
| -------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------ |
| ブロックパブリックアクセス | パブリックネットワークとVPCからのアクセスの許否を設定する． | ・パブリックアクセスを有効にすると，パブリックネットワークから「```https://<バケット名>.s3.amazonaws.com```」というようにURLを指定して，S3にアクセスできるようになる．ただし非推奨．<br>・パブリックアクセスを全て無効にすると，パブリックネットワークとVPCの全アクセスを遮断できる．ただし，アクセスロールまたはバケットポリシーを用いて，特定のAWSリソースからのアクセスを許可できる． |
| アクセスコントロールリスト |                                                             |                                                              |
| バケットポリシー           | S3へのアクセスをポリシーで管理する．                        | ポリシーを付与できない，Cloud Front，ALB，などが自身へのアクセスログを生成するために必要．EC2のアクセス権限は，EC2にS3アクセスロールを付与できるので不要． |
| CORSの設定                 |                                                             |                                                              |

#### ・レスポンスヘッダーの設定

レスポンスヘッダーに埋め込むHTTPヘッダーを，メタデータとして設定する．

| 設定可能なヘッダー              | 説明                                                         | 備考                                           |
| ------------------------------- | ------------------------------------------------------------ | ---------------------------------------------- |
| ETag                            | コンテンツの一意な識別子．ブラウザキャッシュの検証に使用される． | 全てのコンテンツにデフォルトで設定されている． |
| Cache-Control                   | Expiresと同様に，ブラウザにおけるキャッシュの有効期限を設定する． | 全てのコンテンツにデフォルトで設定されている． |
| Content-Type                    | コンテンツのMIMEタイプを設定する．                           | 全てのコンテンツにデフォルトで設定されている． |
| Expires                         | Cache-Controlと同様に，ブラウザにおけるキャッシュの有効期限を設定する．ただし，Cache-Controlの方が優先度が高い． |                                                |
| Content-Disposition             |                                                              |                                                |
| Content-Encoding                |                                                              |                                                |
| x-amz-website-redirect-location | コンテンツのリダイレクト先を設定する．                       |                                                |

#### ・AWS CLI

**＊コマンド例＊**

```sh
# 指定したバケット内のファイル名を表示
$ aws s3 ls s3://<バケット名>
```

<br>

### バケットポリシーの例

#### ・S3のARNについて

ポリシーにおいて，S3のARでは，「```arn:aws:s3:::<バケット名>/*```」のように，最後にバックスラッシュアスタリスクが必要．

#### ・ALBのアクセスログの保存を許可

パブリックアクセスが無効化されたS3に対して，ALBへのアクセスログを保存したい場合，バケットポリシーを設定する必要がある．バケットポリシーには，ALBからS3へのログ書き込み権限を実装する．「```"AWS": "arn:aws:iam::582318560864:root"```」において，```582318560864```は，ALBアカウントIDと呼ばれ，リージョンごとに値が決まっている．これは，東京リージョンのアカウントIDである．

**＊実装例＊**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::582318560864:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::<バケット名>/*"
    }
  ]
}
```

#### ・Cloud Frontのファイル読み出しを許可

パブリックアクセスが無効化されたS3に対して，Cloud Frontからのルーティングで静的ファイルを読み出したい場合，バケットポリシーを設定する必要がある．

**＊実装例＊**

```json
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity <OAIのID番号>"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<バケット名>/*"
    }
  ]
}
```

#### ・Cloud Frontのアクセスログの保存を許可

2020-10-08時点の仕様では，パブリックアクセスが無効化されたS3に対して，Cloud Frontへのアクセスログを保存することはできない．よって，危険ではあるが，パブリックアクセスを有効化する必要がある．

```json
// ポリシーは不要
```

#### ・Lambdaからのアクセスを許可

バケットポリシーは不要である．代わりに，AWS管理ポリシーの「```AWSLambdaExecute```」が付与されたロールをLambdaにアタッチする必要がある．このポリシーには，S3へのアクセス権限の他，CloudWatch Logsにログを生成するための権限が設定されている．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
```

#### ・特定のIPアドレスからのアクセスを許可

パブリックネットワーク上の特定のIPアドレスからのアクセスを許可したい場合，そのIPアドレスをポリシーに設定する必要がある．

```json
{
  "Version": "2012-10-17",
  "Id": "S3PolicyId1",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<バケット名>/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "<IPアドレス>/32"
        }
      }
    }
  ]
}
```

<br>

### CORS設定

#### ・指定したドメインからのGET送信を許可

```json
[
  {
    "AllowedHeaders": [
      "Content-*"
    ],
    "AllowedMethods": [
      "GET"
    ],
    "AllowedOrigins": [
      "https://example.jp"
    ],
    "ExposeHeaders": [],
    "MaxAgeSeconds": 3600
  }
]
```

<br>

## 04. データベース｜RDS

### RDS：Relational Database Service

#### ・RDSとは

| 設定項目                               | 説明                                                         | 備考                                                         |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| エンジンのオプション                   | データベースエンジンの種類を設定                             |                                                              |
| エディション                           | Amazon Auroraを選んだ場合の互換性を設定する．                |                                                              |
| キャパシティタイプ                     |                                                              |                                                              |
| レプリケーション機能                   |                                                              |                                                              |
| DBクラスター識別子                     | クラスター名を設定する．                                     | インスタンス名は，最初に設定できず，RDSの構築後に設定できる． |
| マスタユーザ名                         | データベースのrootユーザを設定                               |                                                              |
| マスターパスワード                     | データベースのrootユーザのパスワードを設定                   |                                                              |
| DBインスタンスサイズ                   | データベースのインスタンスのスペックを設定する．             | バースト可能クラスを選ぶこと．ちなみに，Amazon Auroraのデータベース容量は自動でスケーリングするため，設定する必要がない． |
| マルチAZ配置                           | プライマリインスタンスとは別に，リーダーレプリカをマルチAZ配置で追加するかどうかを設定する． |                                                              |
| 最初のデータベース名                   | データベースに自動的に構築されるデータベース名を設定         |                                                              |
| サブネットグループ                     | データベースにアクセスできるサブネットを設定する．           |                                                              |
| パラメータグループ                     | グローバルパラメータを設定する．                             | デフォルトを使用せずに独自定義する場合，事前に構築しておく必要がある．クラスターパラメータグループとインスタンスパラメータグループがあるが，クラスターパラメータを設定すればよい．新しく作成したクラスタパラメータグループにて以下を設定する．<br>・```time_zone=Asia/Tokyo```<br>・```character_set_client=utf8mb4```<br/>・```character_set_connection=utf8mb4```<br/>・```character_set_database=utf8mb4```<br/>・```character_set_results=utf8mb4```<br/>・```character_set_server=utf8mb4```<br>・```server_audit_logging=1```<br/>・```server_audit_logs_upload=1```<br/>・```general_log=1```<br/>・```slow_query_log=1```<br/>・```long_query_time=3``` |
| ログのエクスポート                     |                                                              | 必ず，全てのログを選択すること．                             |
| バックアップ保持期間                   | RDSがバックアップを保持する期間を設定する．                  | ７日間にしておく．                                           |
| マイナーバージョンの自動アップグレード | データベースエンジンのバージョンを自動的に更新するかを設定する． | 開発環境では有効化，本番環境とステージング環境では無効化しておく．開発環境で新しいバージョンに問題がなければ，ステージング環境と本番環境にも適用する． |

#### ・データベースエンジン，RDB，DBMSの対応関係

Amazon RDSでは，DBMS，RDBを選べる．

| DBMSの種類        | RDBの種類              |
| ----------------- | ---------------------- |
| MySQL／PostgreSQL | Amazon Aurora          |
| MariaDB           | MariaDBデータベース    |
| MySQL             | MySQLデータベース      |
| PostgreSQL        | PostgreSQLデータベース |

#### ・Amazon RDSのセキュリティグループ

コンピューティングからのインバウンド通信のみを許可するように，これらのプライベートIPアドレス（```n.n.n.n/32```）を設定する．

<br>

### データベースインスタンス

#### ・データベースインスタンスの種類

|                | 読み出し／書き込みインスタンス                               | 読み出しオンリーインスタンス                                 |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 別名           | プライマリインスタンス                                       | リードレプリカインスタンス                                   |
| CRUD制限       | 制限なし．ユーザ権限に依存する．                             | ユーザ権限の権限に関係なく，READしか実行できない．           |
| エンドポイント | 各インスタンスに，リージョンのイニシャルに合わせたエンヂポイントが割り振られる． | 各インスタンスに，リージョンのイニシャルに合わせたエンヂポイントが割り振られる． |

#### ・データベースクラスターのエンドポイント

| 種類                       | クエリの種類       | 説明                                     |
| -------------------------- | ------------------ | ---------------------------------------- |
| クラスターエンドポイント   | 書き込み／読み出し | プライマリインスタンスに接続できる．     |
| 読み出しエンドポイント     | 読み出し           | リードレプリカインスタンスに接続できる． |
| インスタンスエンドポイント |                    | 選択したインスタンスに接続できる．       |

![RDSエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/RDSエンドポイント.png)

インスタンス群に対して，以下のエンドポイントが提供される．

```
# 読み出し／書き込みインスタンス群のエンドポイント
xxxxx-cluster.cluster-abcde12345.ap-northeast-1.rds.amazonaws.com
```

```
# 読み出しオンリーインスタンス群のエンドポイント
xxxxx-cluster.cluster-ro-abcde12345.ap-northeast-1.rds.amazonaws.com
```

読み出しオンリーエンドポイントに対して，READ以外の処理を行うと，以下の通り，エラーとなる．


```sql
/* SQL Error (1290): The MySQL server is running with the --read-only option so it cannot execute this statement */
```

<br>

## 04. データベース｜ElastiCache

### ElastiCache

#### ・ElastiCacheとは

アプリケーションの代わりに，セッション，クエリCache，を管理する．RedisとMemcachedがある．

<br>

### Redis

#### ・Redisとは

![Redis](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Redis.png)

| 設定項目                         | 説明                                                         | 備考                                                         |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| クラスターエンジン               | キャッシュエンジンを設定する．Redis通常モード，Redisクラスターモードから選択する． | Redisクラスターモードと同様に，Redis通常モードもクラスター構成になる．ただ，クラスターモードとはクラスターの構成方法が異なる． |
| ロケーション                     |                                                              |                                                              |
| エンジンバージョンの互換性       | 選んだキャッシュエンジンのバージョンを設定する．             | マイナーバージョンが自動的に更新されないように，例えば「6.x」は設定しない方がよい． |
| パラメータグループ               | グローバルパラメータを設定する．                             | デフォルトを使用せずに独自定義する場合，事前に構築しておく必要がある． |
| ノードのタイプ                   |                                                              |                                                              |
| レプリケーション数               | プライマリノードとは別に，リードレプリカノードをいくつ構築するかを設定する． | マルチAZにプライマリノードとリードレプリカノードを一つずつ配置させる場合，ここでは「１個」を設定する． |
| マルチAZ                         | プライマリノードとリードレプリカを異なるAZに配置するかどうかを設定する．合わせて，自動フェールオーバーを実行できるようになる． |                                                              |
| サブネットグループ               | Redisにアクセスできるサブネットを設定する．                  |                                                              |
| セキュリティ                     | セキュリティグループを設定する．                             |                                                              |
| クラスターへのデータのインポート |                                                              |                                                              |
| バックアップ                     | バックアップの有効化，保持期間，時間を設定する．             | バックアップを取るほどでもないため，無効化しておいて問題ない． |
| メンテナンス                     | メンテナンスの時間を設定する．                               |                                                              |

#### ・Redisの操作

```sh
# Redis接続コマンド
$ /usr/local/sbin/redis-stable/src/redis-cli -c -h <Redisのホスト名> -p 6379
```

```sh
# Redis接続中の状態
# 全てのキーを表示
redis xxxxx:6379> keys *
```

```sh
# Redis接続中の状態
# キーを指定して，対応する値を表示
redis xxxxx:6379> type <キー名>
```

```sh
# Redis接続中の状態
# Redisが受け取ったコマンドをフォアグラウンドで表示
redis xxxxx:6379> monitor
```

#### ・フェールオーバー

ノードの障害を検知し，障害が発生したノードを新しいものに置き換えることができる．

| 障害の発生したノード | 挙動                                                         |
| -------------------- | ------------------------------------------------------------ |
| プライマリノード     | リードレプリカの一つがプライマリノードに昇格し，障害が起きたプライマリノードと置き換えられる． |
| リードレプリカノード | 障害が起きたリードレプリカノードが，別の新しいものに置き換えられる． |

#### ・セッション管理機能

![ElastiCacheのセッション管理機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ElastiCacheのセッション管理機能.png)

EC2インスタンスの冗長化時，これらの間で共通のセッションを使用できるように，セッションを管理する．

#### ・クエリCache管理機能

![ElastiCacheのクエリCache管理機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ElastiCacheのクエリキャッシュ管理機能.png)

1. SQLの実行結果を管理する．最初，EC2インスタンスからRDSにSQLが実行される時，SQLの実行結果を保存しておく．

```mysql
# アプリケーションがSQLを実行する
SELECT * FROM users;
```

```sh
# ElastiCacheには，SQLの実行結果がまだ保存されていない
*** no cache ***
{"id"=>"1", "name"=>"alice"}
{"id"=>"2", "name"=>"bob"}
{"id"=>"3", "name"=>"charles"}
{"id"=>"4", "name"=>"donny"}
{"id"=>"5", "name"=>"elie"}
{"id"=>"6", "name"=>"fabian"}
{"id"=>"7", "name"=>"gabriel"}
{"id"=>"8", "name"=>"harold"}
{"id"=>"9", "name"=>"Ignatius"}
{"id"=>"10", "name"=>"jonny"}
```

2. 以降，同じSQLが実行された時には，RDSの代わりにデータをアプリケーションに渡す．

```mysql
# アプリケーションが１番と同じSQLを実行する
SELECT * FROM users;
```


```sh
# ElastiCacheには，SQLの実行結果が既に保存されている
*** cache hit ***
{"id"=>"1", "name"=>"alice"}
{"id"=>"2", "name"=>"bob"}
{"id"=>"3", "name"=>"charles"}
{"id"=>"4", "name"=>"donny"}
{"id"=>"5", "name"=>"elie"}
{"id"=>"6", "name"=>"fabian"}
{"id"=>"7", "name"=>"gabriel"}
{"id"=>"8", "name"=>"harold"}
{"id"=>"9", "name"=>"Ignatius"}
{"id"=>"10", "name"=>"jonny"}
```

<br>

## 05. ネットワーキング，コンテンツ配信｜API Gateway

### API Gateway

![APIGatewayの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/APIGatewayの仕組み.png)

#### ・API Gatewayとは

API Gatewayは，メソッドリクエスト，統合リクエスト，統合レスポンス，メソッドレスポンス，から構成される．

| 設定項目                 | 説明                                                         | 備考                                                         |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| AWSリソース              | エンドポイント，HTTPメソッド，転送先，などを設定する．       | 構築したAWSリソースのパスが，API Gatewayのエンドポイントになる． |
| ステージ                 | API Gatewayをデプロイする環境を定義する．                    |                                                              |
| オーソライザー           |                                                              |                                                              |
| ゲートウェイのレスポンス |                                                              |                                                              |
| モデル                   |                                                              |                                                              |
| リソースポリシー         |                                                              |                                                              |
| ドキュメント             |                                                              |                                                              |
| ダッシュボード           |                                                              |                                                              |
| その他の設定             |                                                              |                                                              |
| 使用量プラン             |                                                              |                                                              |
| APIキー                  | APIキーによる認可を設定する．                                |                                                              |
| クライアント証明書       |                                                              |                                                              |
| CloudWatch Logsの設定    | API GatewayがCloudWatch Logsにアクセスできるよう，ロールを設定する． | 一つのAWS環境につき，一つのロールを設定すればよい．          |

<br>

### リソース

#### ・リソースの詳細項目

| 順番 | 処理               | 説明                                                         | 備考                                                         |
| ---- | ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | メソッドリクエスト | クライアントから送信されたデータのうち，実際に転送するデータのフィルタリングを行う． |                                                              |
| 2    | 統合リクエスト     | メソッドリクエストから転送された各データを，マッピングテンプレートのJSONに紐づける． |                                                              |
| 3    | 統合レスポンス     |                                                              | 統合リクエストでプロキシ統合を使用する場合，統合レスポンスを使用できなくなる． |
| 4    | メソッドレスポンス | レスポンスが成功した場合，クライアントに送信するステータスコードを設定する． |                                                              |

#### ・メソッドリクエストの詳細項目

| 設定項目                  | 説明 | 備考 |
| ------------------------- | ---- | ---- |
| 認可                      |      |      |
| リクエストの検証          |      |      |
| APIキーの必要性           |      |      |
| URLクエリ文字列パラメータ |      |      |
| HTTPリクエストヘッダー    |      |      |
| リクエスト本文            |      |      |
| SDK設定                   |      |      |

#### ・統合リクエストの詳細項目

| 設定項目                  | 説明                                                         |
| ------------------------- | ------------------------------------------------------------ |
| 統合タイプ                | リクエストの転送先を設定する．                               |
| URLパスパラメータ         | メソッドリクエストから転送された各データを，パスパラメータに紐づける． |
| URLクエリ文字列パラメータ | メソッドリクエストから転送された各データを，クエリ文字列パラメータに紐づける． |
| HTTPヘッダー              |                                                              |

#### ・テスト

| 設定項目       | 設定例              | 備考                                               |
| -------------- | ------------------- | -------------------------------------------------- |
| クエリ文字     |                     |                                                    |
| ヘッダー       | X-API-Token: test   | 波括弧，スペース，クオーテーションは不要．         |
| リクエスト本文 | ```{test:"test"}``` | 改行タグやスペースが入り込まないよう，整形しない． |

<br>

### プライベート統合

#### ・プライベート統合とは

API GatewayとVPCリンクの間で，リクエストまたはレスポンスのJSONデータを自動的にマッピングする機能のこと．

| 設定項目                     | 説明                                                  | 備考                                                 |
| ---------------------------- | ----------------------------------------------------- | ---------------------------------------------------- |
| 統合タイプ                   | VPCリンクを選択する．                                 |                                                      |
| プロキシ統合の使用           | VPCリンクとのプロキシ統合を有効化する．               | 有効化しておかないと，パスパラメータを転送できない． |
| メソッド                     | HTTPメソッドを設定する．                              |                                                      |
| VPCリンク                    | VPCリンク名を設定する．                               |                                                      |
| エンドポイントURL            | NLBのDNS名をドメイン名として，転送先のURLを設定する． |                                                      |
| デフォルトタイムアウトの使用 |                                                       |                                                      |

#### ・メソッドリクエストと統合リクエストのマッピング

<br>

### Lambdaプロキシ統合

#### ・Lambdaプロキシ統合とは

API GatewayとLambdaの間で，リクエストまたはレスポンスのJSONデータを自動的にマッピングする機能のこと．プロキシ統合を使用すると，Lambdaに送信されたリクエストはハンドラ関数のeventオブジェクトに格納される．プロキシ統合を使用しない場合，LambdaとAPI Gatewayの間のマッピングを手動で行う必要がある．

| 設定項目                     | 説明                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| 統合タイプ                   | Lambda関数を選択する．                                       |
| Lambdaプロキシ統合の使用     | Lambdaとのプロキシ統合を有効化する．                         |
| Lambdaリージョン             | 実行したLambda関数のリージョンを設定する．                   |
| Lambda関数                   | 実行したLambda関数の名前を設定する．                         |
| 実行ロール                   | 実行したいLambda関数へのアクセス権限が付与されたロールのARNを設定する． |
| 認証情報のキャッシュ         |                                                              |
| デフォルトタイムアウトの使用 |                                                              |

#### ・リクエスト時のマッピング

API Gateway側でプロキシ統合を有効化すると，API Gatewayを経由したクライアントからのリクエストは，ハンドラ関数のeventオブジェクトのJSONデータにマッピングされる．

```json
{
  "resource": "Resource path",
  "path": "Path parameter",
  "httpMethod": "Incoming request's method name",
  "headers": {String containing incoming request headers},
  "multiValueHeaders": {List of strings containing incoming request headers},
  "queryStringParameters": {query string parameters },
  "multiValueQueryStringParameters": {List of query string parameters},
  "pathParameters":  {path parameters},
  "stageVariables": {Applicable stage variables},
  "requestContext": {Request context, including authorizer-returned key-value pairs},
  "body": "A JSON string of the request payload.",
  "isBase64Encoded": "A boolean flag to indicate if the applicable request payload is Base64-encoded"
}

```

#### ・レスポンス時のマッピング

API Gatewayは，Lambdaからのレスポンスを，以下のJSONデータにマッピングする．これ以外の構造のJSONデータを送信すると，API Gatewayで「```Internal Server Error```」のエラーが起こる．

```json
{
  "isBase64Encoded": true|false,
  "statusCode": httpStatusCode,
  "headers": { "headerName": "headerValue", ... },
  "multiValueHeaders": { "headerName": ["headerValue", "headerValue2", ...], ... },
  "body": "Hello Lambda"
}
```

API Gatewayは上記のJSONデータを受信した後，```body```のみ値をレスポンスのメッセージボディに格納し，クライアントに送信する．

```
"Hello Lambda"
```

<br>

### ステージ

#### ・設定

| 設定項目                           | 説明                      |
| ---------------------------------- | ------------------------- |
| キャッシュ設定                     |                           |
| デフォルトのメソッドスロットリング |                           |
| WAF                                |                           |
| クライアント証明書                 | 関連付けるWAFを設定する． |

#### ・ログ／トレース

| 設定項目                   | 説明                                                        |
| -------------------------- | ----------------------------------------------------------- |
| CloudWatch設定             | CloudWatch Logsにアクセスログを送信するかどうかを設定する． |
| カスタムアクセスのログ記録 |                                                             |
| X-Rayトレース              |                                                             |

#### ・ステージ変数

デプロイされるステージ固有の環境変数を設定できる．Lambda関数名，エンドポイントURL，パラメータマッピング，マッピングテンプレートで値を出力できる．

参照：https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/aws-api-gateway-stage-variables-reference.html

#### ・SDKの生成

#### ・Canary

| 設定項目                                   | 説明 |
| ------------------------------------------ | ---- |
| ステージのリクエストディストリビューション |      |
| Canaryのデプロイ                           |      |
| Canaryステージ変数                         |      |
| キャッシュ                                 |      |

<br>

## 05-02. ネットワーキング，コンテンツ配信｜Route53

### Route53

#### ・Route53とは

クラウドDNSサーバーとして働く．リクエストされた完全修飾ドメイン名とEC2のグローバルIPアドレスをマッピングしている．

| 設定項目       | 説明                                                         |
| -------------- | ------------------------------------------------------------ |
| ホストゾーン   | ドメイン名を設定する．                                       |
| レコードセット | 名前解決時のルーティング方法を設定する．サブドメイン名を扱うことも可能． |

<br>

### ホストゾーン

#### ・レコードタイプの設定値の違い

| レコードタイプ |                                                              | 備考                                                         |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| NS             | IPアドレスの問い合わせに応えられる権威DNSサーバの名前が定義されている． | 詳しくは，以降の，Route53を含む多数のDNSサーバによって名前解決される仕組みを参照せよ． |
| A              | リクエストを転送したいAWSリソースの，IPv4アドレスまたはDNS名を設定する． |                                                              |
| AAAA           | リクエストを転送したいAWSリソースの，IPv6アドレスまたはDNS名を設定する． |                                                              |
| CNAME          | リクエストを転送したい任意のサーバのドメイン名を設定する．   | 転送先はAWSリソースでなくともよい．                          |
| MX             | リクエストを転送したいメールサーバのドメイン名を設定する．   |                                                              |
| TXT            | リクエストを転送したいサーバのドメイン名に関連付けられた文字列を設定する． |                                                              |

#### ・リソースのDNS名，ドメイン名，エンドポイント名

リソースのDNS名は，以下の様に決定される．

| 種別             | リソース    | 例                                                           |
| ---------------- | ----------- | ------------------------------------------------------------ |
| DNS名            | ALB         | ```<ALB名>-<ランダムな文字列>.<リージョン>.elb.amazonaws.com``` |
|                  | EC2         | ```ec2-<パブリックIPをハイフン区切りにしたもの>.<リージョン>.compute.amazonaws.com``` |
| ドメイン名       | Cloud Front | ```<ランダムな文字列>.cloudfront.net```                      |
| エンドポイント名 | S3          | ```<バケット名>.<リージョン>.amazonaws.com```                |

#### ・レコードタイプの名前解決方法の違い

![URLと電子メールの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/URLと電子メールの構造.png)

| レコードタイプ | 名前解決方法（1）  |      |      （2）       |      |     （3）      |
| -------------- | :----------------: | :--: | :--------------: | :--: | :------------: |
| A              | 完全修飾ドメイン名 |  →   |  パブリックIPv4  |  →   |       -        |
| AAAA           | 完全修飾ドメイン名 |  →   |  パブリックIPv6  |  →   |       -        |
| CNAME          | 完全修飾ドメイン名 |  →   | （リダイレクト） |  →   | パブリックIPv4 |

#### ・Cloud Frontへのルーティング

Cloud Frontにルーティングする場合，Cloud FrontのCNAMEをレコード名とすると，Cloud Frontのデフォルトドメイン名（```xxxxx.cloudfront.net.```）が，入力フォームに表示されるようになる．

#### ・Route53を含む多数のDNSサーバによって名前解決される仕組み

![Route53を含む名前解決の仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Route53を含む名前解決の仕組み.png)

=== （1）完全修飾ドメイン名に対応するIPアドレスのレスポンス ===

1. クライアントPCは，自身に保存される```www.example.jp```（完全修飾ドメイン名）のキャッシュを検索する．
2. キャッシュが無ければ，クライアントPCは```www.example.jp```を，フォワードプロキシサーバ（キャッシュDNSサーバ）にリクエスト．
3. フォワードプロキシサーバは，DNSキャッシュを検索する．
4. フォワードプロキシサーバは，ルートDNSサーバに```www.example.jp```のIPアドレスを問い合わせる．
5. ルートDNSサーバは，NSレコードとして定義された権威DNSサーバ名をレスポンス．
6. フォワードプロキシサーバは，```www.example.jp```を，リバースプロキシサーバに代理リクエスト．次いで，リバースプロキシサーバは，DNSサーバ（ネームサーバ）に```www.example.jp```のIPアドレスを問い合わせる．
7. DNSサーバは，NSレコードとして定義された権威DNSサーバ名をレスポンス．
8. フォワードプロキシサーバは，```www.example.jp```を，リバースプロキシサーバに代理リクエスト．次いで，リバースプロキシサーバは，グローバルリージョンRoute53に```www.example.jp```のIPアドレスを問い合わせる．
9. グローバルリージョンRoute53はDNSサーバとして機能し，リバースプロキシサーバに東京リージョンALBのIPアドレスをレスポンス．次いで，リバースプロキシサーバは，東京リージョンALBのIPアドレスを，フォワードプロキシサーバに代理レスポンス．（※ NATによるIPアドレスのネットワーク間変換が起こる）


|      完全修飾ドメイン名      | Route53 |     IPv4アドレス      |
| :--------------------------: | :-----: | :-------------------: |
| ```http://www.example.com``` |    ⇄    | ```203.142.205.139``` |

10. フォワードプロキシサーバは，東京リージョンALBのIPアドレスを，クライアントPCに代理レスポンス．
11. クライアントPCは東京リージョンALBのIPアドレスにリクエストを送信する．

=== （2）東京リージョンALBのIPアドレスに対応するWebページのレスポンス ===

1. クライアントPCは，レスポンスされた東京リージョンALBのIPアドレスを基に，Webページを，リバースプロキシサーバにリクエスト．
2. リバースプロキシサーバは，Webページを，東京リージョンALBに代理リクエスト．
3. 東京リージョンALBは，EC2やFargateにリクエストを転送する．
4. EC2やFargateは，Webページをリバースプロキシサーバにレスポンス．
5. リバースプロキシサーバは，WebページをクライアントPCに代理レスポンス．

#### ・AWS以外でドメインを購入した場合

DNSサーバによる名前解決は，ドメインを購入したドメインレジストラで行われる．そのため，AWS以外でドメインを購入した場合，Route53のNSレコード値を，ドメインレジストラに登録する必要がある．これにより，ドメインレジストラに対してIPアドレスの問い合わせがあった場合は，Route53のNSレコード値がレスポンスされるようになる．

#### ・Route53におけるDNSキャッシュ

ルートサーバは世界に13機しか存在しておらず，世界中の名前解決のリクエストを全て処理することは現実的に不可能である．そこで，IPアドレスとドメイン名の関係をキャッシュするプロキシサーバ（キャッシュDNSサーバ）が使用されている．基本的には，プロキシサーバとDNSサーバは区別されるが，Route53はプロキシサーバとDNSサーバの機能を両立している．

<br>

### リゾルバー

#### ・リゾルバーとは

要勉強．

<br>

## 05-03. ネットワーキング，コンテンツ配信｜Cloud Front

### Cloud Front

![AWSのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudFrontによるリクエストの振り分け.png)

#### ・Cloud Frontとは

クラウドリバースプロキシサーバとして働く．VPCの外側（パブリックネットワーク）に設置されている．オリジンサーバ（コンテンツ提供元）をS3とした場合，動的コンテンツへのリクエストをEC2に振り分ける．また，静的コンテンツへのリクエストをCacheし，その上でAmazon S3へ振り分ける．次回以降の静的コンテンツのリンクエストは，Cloud Frontがレンスポンスを行う．

| 設定項目            | 説明 |
| ------------------- | ---- |
| Distributions       |      |
| Reports & analytics |      |

#### ・全てのエッジサーバのIPアドレス

Cloud Frontには，エッジロケーションの数だけエッジサーバがあり，各サーバにIPアドレスが割り当てられている．以下のコマンドで，全てのエッジサーバのIPアドレスを確認できる．

```sh
$ curl https://ip-ranges.amazonaws.com/ip-ranges.json |
jq  '.prefixes[] | select(.service=="CLOUDFRONT") | .ip_prefix'
```

もしくは，以下のリンクを直接参照し，「```"service": "CLOUDFRONT"```」となっている部分を探す．

参照リンク：https://ip-ranges.amazonaws.com/ip-ranges.json

#### ・エッジロケーションの使用中サーバのIPアドレス

Cloud Frontには，エッジロケーションがあり，各ロケーションにサーバがある．以下のコマンドで，エッジロケーションにある使用中サーバのIPアドレスを確認できる．

```sh
$ nslookup <割り当てられた文字列>.cloudfront.net
```

<br>

### Distributions

#### ・Distributionsの詳細項目

[参考になったサイト](https://www.geekfeed.co.jp/geekblog/wordpress%E3%81%A7%E6%A7%8B%E7%AF%89%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%82%A6%E3%82%A7%E3%83%96%E3%82%B5%E3%82%A4%E3%83%88%E3%81%ABcloudfront%E3%82%92%E7%AB%8B%E3%81%A6%E3%81%A6%E9%AB%98/)

| 設定項目                 | 説明                                                      |
| ------------------------ | --------------------------------------------------------- |
| General                  |                                                           |
| Origin and Origin Groups | コンテンツを提供するAWSリソースを設定                     |
| Behavior                 | オリジンにリクエストが行われた時のCloud Frontの挙動を設定 |
| ErrorPage                |                                                           |
| Restriction              |                                                           |
| Invalidation             | Cloud Frontに保存されているCacheを削除できる．            |

#### ・Generalの詳細項目

| 設定項目            | 説明                                                         | 備考                                                         |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Price Class         | 使用するエッジロケーションを設定する．                       | Asiaが含まれているものを選択．                               |
| AWS WAF             | Cloud Frontに紐づけるWAFを設定する．                         |                                                              |
| CNAME               | Cloud Frontのデフォルトドメイン名（```xxxxx.cloudfront.net.```）に紐づけるRoute53レコード名を設定する． | ・Route53からルーティングする場合は必須．<br>・複数のレコード名を設定できる． |
| SSL Certificate     | HTTPSプロトコルでオリジンに転送する場合に設定する．          | 上述のCNAMEを設定した場合，SSL証明書が別途必要になる．また，Certificate Managerを使用する場合，この証明書は『バージニア北部』で申請する必要がある． |
| Default Root Object | オリジンのドキュメントルートを設定する．                     | 例えば，index.htmlを設定すると，「```/```」でリクエストした時に，index,htmlが自動で省略される． |
| Standard Logging    | Cloud FrontのアクセスログをS3に生成するかどうかを設定する．  |                                                              |

#### ・Origin and Origin Groupsの詳細項目

| 設定項目               | 説明                                                         | 備考                                                         |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Origin Domain Name     | Cloud Frontを経由してコンテンツを提供するAWSリソースのエンドポイントやDNS名を設定する． | ・例えば，S3のエンドポイント，ALBのDNS名を設定する．<br>・別アカウントのAWSリソースのDNS名であってもよい． |
| Origin Path            | オリジンのルートディレクトリを設定する．                     | デフォルトは「```/```」で，その後にBehaviorのパスが追加される．例えば，「```/var/www/app```」とすると，Behaviorで設定したパスが「```/var/www/app/xxxxx```」のように追加される． |
| Origin Access Identity | リクエストの転送先となるAWSリソースでアクセス権限の付与が必要な場合に設定する．転送先のAWSリソースでは，アクセスポリシーを付与する． | Cloud FrontがS3に対して読み出しを行うために必要．            |
| Origin Protocol Policy | リクエストの転送先となるAWSリソースに対して，HTTPとHTTPSのいずれのプロトコルで転送するかを設定する． | ・ALBで必要．ALBのリスナーのプロトコルに合わせて設定する．<br>・```HTTP Only```：HTTPで転送<br/>・```HTTPS Only```：HTTPSで転送<br/>・```Match Viewer```：両方で転送 |
| HTTPポート             | 転送時に指定するオリジンのHTTPのポート番号                   |                                                              |
| HTTPSポート            | 転送時に指定するオリジンのHTTPSのポート番号                  |                                                              |

#### ・Behaviorの詳細項目

何に基づいたCacheを行うかについては，★マークの項目で制御できる．★マークで，各項目の全て値が，過去のリクエストに合致した時のみ，そのリクエストと過去のものが同一であると見なす仕組みになっている．キャッシュ判定時のパターンを減らし，HIT率を改善するために，★マークで可能な限り「None」を選択した方が良い．その他の改善方法は，以下リンクを参照せよ．

参考：https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/cache-hit-ratio.html#cache-hit-ratio-query-string-parameters

| 設定項目                                                     | 説明                                                         | 備考                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Precedence                                                   | 処理の優先順位．                                             | 最初に構築したBehaviorが「```Default (*)```」となり，これは後から変更できないため，主要なBehaviorをまず最初に設定する． |
| Path Pattern                                                 | Behaviorを行うファイルパスを設定する．                       |                                                              |
| Origin or Origin Group                                       | Behaviorを行うオリジンを設定する．                           |                                                              |
| Viewer Protocol Policy                                       | HTTP／HTTPSのどちらを受信するか，またどのように変換して転送するかを設定 | ・```HTTP and HTTPS```：両方受信し，そのまま転送<br/>・```Redirect HTTP to HTTPS```：両方受信し，HTTPSで転送<br/>・```HTTPS Only```：HTTPSのみ受信し，HTTPSで転送 |
| Allowed HTTP Methods                                         | リクエストのHTTPメソッドのうち，オリジンへの転送を許可するものを設定 | ・パスパターンが静的ファイルへのリクエストの場合，GETのみ許可．<br>・パスパターンが動的ファイルへのリクエストの場合，全てのメソッドを許可． |
| ★Cache Based on Selected Request Headers<br>（★については表上部参照） | リクエストヘッダーのうち，オリジンへの転送を許可し，またCacheの対象とするものを設定する． | ・各ヘッダー転送の全拒否，一部許可，全許可を設定できる．<br>・全拒否：全てのヘッダーの転送を拒否し，Cacheの対象としない．動的になりやすい値をもつヘッダー（Accept-Datetimeなど）を一切使用せずに，それ以外のクエリ文字やCookieでCacheを判定するようになるため，同一と見なすリクエストが増え，HIT率改善につながる．<br>・一部転送：指定したヘッダーのみ転送を許可し，Cacheの対象とする．<br>・全許可：全てのヘッダーがCacheの対象となる．しかし，日付に関するヘッダーなどの動的な値をCacheの対象としてしまうと．同一と見なすリクエストがほとんどなくなり，HITしなくなる．そのため，この設定でCacheは実質無効となり，「対象としない」に等しい． |
| Whitelist Header                                             | Cache Based on Selected Request Headers を参照せよ．         | ・```Accept-xxxxx```：アプリケーションにレスポンスして欲しいデータの種類（データ型など）を指定．<br/>・ ```CloudFront-Is-xxxxx-Viewer```：デバイスタイプのBool値が格納されている．<br>・レスポンスのヘッダーに含まれる「```X-Cache:```」が「```Hit from cloudfront```」，「```Miss from cloudfront```」のどちらで，Cacheの使用の有無を判断できる．<br/> |
| Object Caching                                               | Cloud FrontにコンテンツのCacheを保存しておく秒数を設定する． | ・Origin Cache ヘッダーを選択した場合，アプリケーションからのレスポンスヘッダーのCache-Controlの値が適用される．<br>・カスタマイズを選択した場合，ブラウザのTTLとは別に設定できる． |
| TTL                                                          | Cloud FrontにCacheを保存しておく秒数を詳細に設定する．       | ・Min，Max，Default，の全てを0秒とすると，Cacheを無効化できる．<br>・「Cache Based on Selected Request Headers = All」としている場合，Cacheが実質無効となるため，最小TTLはゼロでなければならない． |
| ★Farward Cookies<br/>（★については表上部参照）               | Cookie情報のキー名のうち，オリジンへの転送を許可し，Cacheの対象とするものを設定する． | ・Cookie情報キー名転送の全拒否，一部許可，全許可を設定できる．<br>・全拒否：全てのCookieの転送を拒否し，Cacheの対象としない．Cookieはユーザごとに一意になることが多く，動的であるが，それ以外のヘッダーやクエリ文字でCacheを判定するようになるため，同一と見なすリクエストが増え，HIT率改善につながる．<br/>・リクエストのヘッダーに含まれるCookie情報（キー名／値）が変動していると，Cloud Frontに保存されたCacheがHITしない．Cloud Frontはキー名／値を保持するため，変化しやすいキー名／値は，オリジンに転送しないように設定する．例えば，GoogleAnalyticsのキー名（```_ga```）の値は，ブラウザによって異なるため，１ユーザがブラウザを変えるたびに，異なるCacheが生成されることになる．そのため，ユーザを一意に判定することが難しくなってしまう．<br>・セッションIDはCookieヘッダーに設定されているため，フォーム送信に関わるパスパターンでは，セッションIDのキー名を許可する必要がある． |
| ★Query String Forwarding and Caching<br/>（★については表上部参照） | クエリストリングのうち，オリジンへの転送を許可し，Cacheの対象とするものを設定する． | ・クエリストリング転送とCacheの，全拒否，一部許可，全許可を選択できる．全拒否にすると，Webサイトにクエリストリングをリクエストできなくなるので注意．<br>・異なるクエリパラメータを，別々のCacheとして保存するかどうかを設定できる． |
| Restrict Viewer Access                                       | リクエストの送信元を制限するかどうかを設定できる．           | セキュリティグループで制御できるため，ここでは設定しなくてよい． |
| Compress Objects Automatically                               | レスポンス時にgzipを圧縮するかどうかを設定                   | ・クライアントからのリクエストヘッダーのAccept-Encodingにgzipが設定されている場合，レスポンス時に，gzip形式で圧縮して送信するかどうかを設定する．設定しない場合，圧縮せずにレスポンスを送信する．<br>・クライアント側のダウンロード速度向上のため，基本的には有効化する． |

#### ・Invalidation

Cloud Frontに保存してあるCacheを削除できる．全てのファイルのCacheを削除したい場合は「```/*```」，特定のファイルのCacheを削除したい場合は「```/<ファイルへのパス>```」，を指定する．Cloud Frontに関するエラーページが表示された場合，不具合を修正した後でもCacheが残っていると，エラーページが表示されてしまうため，作業後には必ずCacheを削除する．

#### ・オリジンに対するリクエストメッセージの構造

Cloud Frontからオリジンに送信されるリクエストメッセージの構造例を以下に示す．

```http
GET /example/
# リクエストされたドメイン名
Host: stg.osohshiki.jp
User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1
Authorization: Bearer <Bearerトークン>
X-Amz-Cf-Id: XXXXX
Via: 2.0 77c20654dd474081d033f27ad1b56e1e.cloudfront.net (Cloud Front)
# 各Cookieの値（二回目のリクエスト時に設定される）
Cookie: PHPSESSID=<セッションID>; __ulfpc=<GoogleAnalytics値>; _ga=<GoogleAnalytics値>; _gid=<GoogleAnalytics値>
# 送信元IPアドレス
# ※プロキシサーバ（ALBやCloud Frontなども含む）を経由している場合に，それら全てのIPアドレスも順に設定される
X-Forwarded-For: <client>, <proxy1>, <proxy2>
Accept-Language: ja,en;q=0.9
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate, br
pragma: no-cache
cache-control: no-cache
upgrade-insecure-requests: 1
sec-fetch-site: none
sec-fetch-mode: navigate
sec-fetch-user: ?1
sec-fetch-dest: document
# デバイスタイプ
CloudFront-Is-Mobile-Viewer: true
CloudFront-Is-Tablet-Viewer: false
CloudFront-Is-SmartTV-Viewer: false
CloudFront-Is-Desktop-Viewer: false
# リクエストの送信元の国名
CloudFront-Viewer-Country: JP
# リクエストのプロトコル
CloudFront-Forwarded-Proto: https
```

#### ・キャッシュの時間の決まり方

キャッシュの時間は，リクエストヘッダー（```Cache-Control```，```Expires```）の値とCloud Frontの設定（最大最小デフォルトTTL）の組み合わせによって決まる．ちなみに，Cloud Frontの最大最小デフォルトTTLを全て０秒にすると，キャッシュを完全に無効化できる．

参照：https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/Expiration.html#ExpirationDownloadDist

<br>

### Reports & analytics

#### ・Cache statistics

リクエストに関連する様々なデータを，日付別に集計したものを確認できる．

#### ・Popular objects

リクエストに関連する様々なデータを，オブジェクト別に集計したものを確認できる．

<br>

## 05-04. ネットワーキング，コンテンツ配信｜ALB

### ALB：Application Load Balancing

![ALBの機能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ALBの機能.png)

#### ・ALBとは

クラウドリバースプロキシサーバ，かつクラウドロードバランサーとして働く．リクエストを代理で受信し，インスタンスへのアクセスをバランスよく分配することによって，サーバへの負荷を緩和する．

| 設定項目           | 説明                                                         | 備考                                                         |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| リスナー           | ALBに割り振るポート番号お，受信するプロトコルを設定する．リバースプロキシかつロードバランサ－として，これらの通信をターゲットグループにルーティングする． |                                                              |
| ルール             | リクエストのルーティングのロジックを設定する．               |                                                              |
| ターゲットグループ | ルーティング時に使用するプロトコルと，ルーティング先のアプリケーションに割り当てられたポート番号を指定する． | ターゲットグループ内のターゲットのうち，トラフィックはヘルスチェックがOKになっているターゲットにルーティングされる． |
| ヘルスチェック     | ターゲットグループに属するプロトコルとアプリケーションのポート番号を指定して，定期的にリクエストを送信する． |                                                              |

#### ・ルールの設定例

| ユースケース                                                 | ポート    | IF                                             | THEN                                                         |
| ------------------------------------------------------------ | --------- | ---------------------------------------------- | ------------------------------------------------------------ |
| リクエストがポート```80```を指定した時に，```443```にリダイレクトしたい． | ```80```  | それ以外の場合はルーティングされないリクエスト | リダイレクト先：```https://#{host}:443/#{path}?#{query}```<br>ステータスコード：```HTTP_301``` |
| リクエストがポート```443```を指定した時に，ターゲットグループに転送したい． | ```443``` | それ以外の場合はルーティングされないリクエスト | 特定のターゲットグループ                                     |

#### ・ターゲットの指定方法

| ターゲットの指定方法 | 備考                                                         |
| -------------------- | ------------------------------------------------------------ |
| インスタンス         | ターゲットが，EC2でなければならない．                        |
| IPアドレス           | ターゲットのパブリックIPアドレスが，静的でなければならない． |
| Lambda               | ターゲットが，Lambdaでなければならない．                     |

<br>

### Webサーバ，アプリケーションにおける対応

#### ・問題

ALBからEC2へのルーティングをHTTPプロトコルとした場合，アプリケーション側で，HTTPSプロトコルを用いた処理ができなくなる．そこで，クライアントからALBに対するリクエストのプロトコルがHTTPSだった場合に，Webサーバまたはアプリケーションにおいて，ルーティングのプロトコルをHTTPSと見なすように対処する．

![ALBからEC2へのリクエストのプロトコルをHTTPSと見なす](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ALBからEC2へのリクエストのプロトコルをHTTPSと見なす.png)

#### ・Webサーバにおける対処方法

ALBを経由したリクエストの場合，リクエストヘッダーに```X-Forwarded-Proto```ヘッダーが付与される．これには，ALBに対するリクエストのプロトコルの種類が，文字列で格納されている．これが「HTTPS」だった場合に，WebサーバへのリクエストをHTTPSであるとみなすように対処する．これにより，アプリケーションへのリクエストのプロトコルがHTTPSとなる（こちらを行った場合は，以降のアプリケーション側の対応不要）．

**＊実装例＊**

```apacheconf
SetEnvIf X-Forwarded-Proto https HTTPS=on
```

#### ・アプリケーションにおける対処方法

ALBを経由したリクエストの場合，リクエストヘッダーに```HTTP_X_FORWARDED_PROTO```ヘッダーが付与される．これには，ALBに対するリクエストのプロトコルの種類が．文字列で格納されている．これが「HTTPS」だった場合に，アプリケーションへのリクエストをHTTPSであるとみなすように，```index.php```に追加実装を行う．

**＊実装例＊**


```php
<?php
// index.php
if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"])
    && $_SERVER["HTTP_X_FORWARDED_PROTO"] == 'https') {
    $_SERVER["HTTPS"] = 'on';
}
```

<br>

### その他の留意事項

#### ・割り当てられるプライベートIPアドレス範囲

ALBに割り当てられるIPアドレス範囲には，VPCのものが適用される．そのため，EC2のSecurity Groupでは，VPCのIPアドレス範囲を許可するように設定する必要がある．

#### ・ALBのセキュリティグループ

Route53から転送されるパブリックIPアドレスを受信できるようにしておく必要がある．パブリックネットワークに公開するWebサイトであれば，IPアドレスは全ての範囲（```0.0.0.0/0```と``` ::/0```）にする．社内向けのWebサイトであれば，社内のプライベートIPアドレスのみ（```n.n.n.n/32```）を許可するようにする．

<br>

## 05-05. ネットワーキング，コンテンツ配信｜Global Accelerator

### Global Accelerator

![GlobalAccelerator](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/GlobalAccelerator.png)

#### ・Global Acceleratorとは

最初，クライアントPCからのリクエストはエッジロケーションで受信される．プライベートネットワーク内のエッジロケーションを経由して，ルーティング先のリージョンまで届く．パブリックネットワークを使用しないため，小さなレイテシーでトラフィックをルーティングできる．

![GlobalAccelerator導入後](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/GlobalAccelerator導入後.png)

Global Acceleratorを使用しない場合，クライアントPCのリージョンから指定したリージョンに至るまで，いくつもパブリックネットワークを経由する必要があり，時間がかかってしまう．

![GlobalAccelerator導入前](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/GlobalAccelerator導入前.png)

以下のサイトで，Global Acceleratorを使用した場合としなかった場合のレスポンス速度を比較できる．

速度比較：https://speedtest.globalaccelerator.aws/#/

<br>

### Accelerators

#### ・基本的な設定の詳細項目

| 設定項目           | 説明                                                         | 備考                                                         |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Accelerator タイプ | エンドポイントグループへのルーティング時のアルゴリズムを設定する． | 「Standard」の場合，ユーザに最も近いリージョンにあるエンドポイントグループに，リクエストがルーティングされる． |
| IPアドレスプール   | Global Acceleratorに割り当てる静的IPアドレスを設定する．     |                                                              |

#### ・リスナーの詳細項目

| 設定項目        | 説明                                               | 備考                                                         |
| --------------- | -------------------------------------------------- | ------------------------------------------------------------ |
| ポート          | ルーティング先のポート番号を設定する．             |                                                              |
| プロトコル      | ルーティング先のプロトコルを設定する．             |                                                              |
| Client affinity | ユーザごとにルーティング先を固定するかを設定する． | ・「None」の場合，複数のルーティング先があった場合に，各ユーザの毎リクエスト時のルーティング先は固定されない．<br>・「Source IP」の場合，複数のルーティング先があったとしても，各ユーザの毎リクエスト時のルーティング先を固定できるようになる． |

#### ・エンドポイントグループの詳細項目

| 設定項目               | 説明                                                         | 備考                                                         |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| エンドポイントグループ | 特定のリージョンに関連付くエンドポイントのグループを設定する． | トラフィックダイヤルにて，各エンドポイントグループの重みを設定できる． |
| トラフィックダイヤル   | 複数のエンドポイントグループがある場合に，それぞれの重み（%）を設定する． | ・例えば，カナリアリリースのために，新アプリと旧アプリへのルーティングに重みを付ける場合に役立つ． |
| ヘルスチェック         | ルーティング先に対するヘルスチェックを設定する．             |                                                              |

#### ・エンドポイントの詳細項目

| 設定項目                     | 説明                                                         | 備考                                                         |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| エンドポイントタイプ         | ルーティング先のAWSリソースを設定する．                      | ALB，NLB，EC2，Elastic IPを選択できる．                      |
| 重み                         | 複数のエンドポイントがある場合に，それぞれの重みを設定する． | 各エンドポイントの重みの合計値を256とし，1～255で相対値を設定する． |
| クライアントIPアドレスの保持 | ```X-Forwarded-For```ヘッダーにクライアントIPアドレスを含めて転送するかどうかを設定する． |                                                              |

<br>

## 05-06. ネットワーキング，コンテンツ配信｜VPC

### VPC：Virtual Private Cloud（＝プライベートネットワーク）

#### ・VPCとは

クラウドプライベートネットワークとして働く．プライベートIPアドレスが割り当てられた，VPCと呼ばれるプライベートネットワークを仮想的に構築することができる．異なるAvailability Zoneに渡ってEC2を立ち上げることによって，クラウドサーバをデュアル化することできる．

![VPCが提供できるネットワークの範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCが提供できるネットワークの範囲.png)

<br>

### IPアドレスの割り当て

#### ・自動割り当てパブリックIPアドレス（動的IPアドレス）

動的なIPアドレスで，EC2の再構築後に変化する．

#### ・Elastic IP（静的IPアドレス）

静的なIPアドレスで，再構築後も保持される．

<br>

### Internet Gateway，NAT Gateway

![InternetGatewayとNATGateway](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/InternetGatewayとNATGateway.png)

#### ・Internet Gatewayとは

VPCの出入り口に設置され，グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT）の機能を持つ．一つのパブリックIPに対して，一つのEC2のプライベートIPを紐づけられる．詳しくは，別ノートのNAT（静的NAT）を参照せよ．

#### ・NAT Gatewayとは

NAPT（動的NAT）の機能を持つ．一つのパブリックIPに対して，複数のEC2のプライベートIPを紐づけられる．パブリックsubnetに置き，プライベートSubnetのEC2からのレスポンスを受け付ける．詳しくは，別ノートのNAPT（動的NAT）を参照せよ．

#### ・比較表


|              | Internet Gateway                                             | NAT Gateway        |
| :----------- | :----------------------------------------------------------- | :----------------- |
| **機能**     | グローバルネットワークとプライベートネットワーク間（ここではVPC）におけるNAT（静的NAT） | NAPT（動的NAT）    |
| **設置場所** | VPC上                                                        | パブリックsubnet内 |

<br>

### Route Table（= マッピングテーブル）

![ルートテーブル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ルートテーブル.png)

#### ・ルートテーブルとは

クラウドルータのマッピングテーブルとして働く．ルータについては，別ノートのNATとNAPTを参照せよ．

| Destination（プライベートIPの範囲） |                Target                 |
| :---------------------------------: | :-----------------------------------: |
|          ```xx.x.x.x/xx```          | Destinationの範囲内だった場合の送信先 |

#### ・ルートテーブルの種類

| 種類                   | 説明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| メインルートテーブル   | VPCの構築時に自動で構築される．どのルートテーブルにも関連付けられていないサブネットのルーティングを設定する． |
| カスタムルートテーブル | 特定のサブネットのルーティングを設定する．                   |

#### ・具体例1

上の図中で，サブネット2にはルートテーブル1が関連づけられている．サブネット2内のEC2の送信先のプライベートIPアドレスが，```10.0.0.0/16```の範囲内にあれば，インバウンド通信と見なし，local（VPC内の他サブネット）を送信先に選び，範囲外にあれば通信を破棄する．

| Destination（プライベートIPアドレス範囲） |  Target  |
| :---------------------------------------: | :------: |
|             ```10.0.0.0/16```             |  local   |
|            指定範囲以外の場合             | 通信破棄 |

#### ・具体例2

上の図中で，サブネット3にはルートテーブル2が関連づけられている．サブネット3内のEC2の送信先のプライベートIPアドレスが，```10.0.0.0/16```の範囲内にあれば，インバウンド通信と見なし，local（VPC内の他サブネット）を送信先に選び，```0.0.0.0/0```（local以外の全IPアドレス）の範囲内にあれば，アウトバウンド通信と見なし，インターネットゲートウェイを送信先に選ぶ．

| Destination（プライベートIPアドレス範囲） |      Target      |
| :---------------------------------------: | :--------------: |
|             ```10.0.0.0/16```             |      local       |
|              ```0.0.0.0/0```              | Internet Gateway |

<br>

### Network ACL：Network Access  Control List

![ネットワークACL](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ネットワークACL.png)

#### ・Network ACLとは

サブネットのクラウドパケットフィルタリング型ファイアウォールとして働く．ルートテーブルとサブネットの間に設置され，双方向のインバウンドルールとアウトバウンドルールを決定する．

#### ・ACLルール

ルールは上から順に適用される．例えば，インバウンドルールが以下だった場合，ルール100が最初に適用され，サブネットに対する，全IPアドレス（```0.0.0.0/0```）からのインバウンド通信を許可していることになる．

| ルール # | タイプ                | プロトコル | ポート範囲 / ICMP タイプ | ソース    | 許可 / 拒否 |
| -------- | --------------------- | ---------- | ------------------------ | --------- | ----------- |
| 100      | すべての トラフィック | すべて     | すべて                   | 0.0.0.0/0 | ALLOW       |
| *        | すべての トラフィック | すべて     | すべて                   | 0.0.0.0/0 | DENY        |

<br>

### VPC subnet

クラウドプライベートネットワークにおけるセグメントとして働く．

#### ・パブリックsubnetとは

非武装地帯に相当する．攻撃の影響が内部ネットワークに広がる可能性を防ぐために，外部から直接リクエストを受ける，

#### ・プライベートsubnetとは

内部ネットワークに相当する．外部から直接リクエストを受けずにレスポンスを返せるように，内のNATを経由させる必要がある．

![パブリックサブネットとプライベートサブネットの設計](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/パブリックサブネットとプライベートサブネットの設計.png)

#### ・同一VPC内の各AWSリソースに割り当てる最低限のIPアドレス数

一つのVPC内には複数のSubnetが入る．そのため，SubnetのIPアドレス範囲は，Subnetの個数だけ狭めなければならない．また，VPCがもつIPアドレス範囲から，VPC内の各AWSリソースにIPアドレスを割り当てていかなければならない．VPC内でIPアドレスが枯渇しないように，　以下の手順で，割り当てを考える．

1. rfc1918 に準拠し，VPCに以下の範囲内でIPアドレスを割り当てる．

| IPアドレス                                | サブネットマスク（CIDR形式） | 範囲                 |
| ----------------------------------------- | ---------------------------- | -------------------- |
| ```10.0.0.0```  ~ ```10.255.255.255```    | ```/8```                     | ```10.0.0.0/8```     |
| ```172.16.0.0``` ~ ```172.31.255.255```   | ```/12```                    | ```172.16.0.0/12```  |
| ```192.168.0.0``` ~ ```192.168.255.255``` | ```/16```                    | ```192.168.0.0/16``` |

2. VPC内の各AWSリソースにIPアドレス範囲を割り当てる．

| AWSサービスの種類  | 最低限のIPアドレス数                    |
| ------------------ | --------------------------------------- |
| ALB                | ALB1つ当たり，8個                       |
| オートスケーリング | 水平スケーリング時のEC2最大数と同じ個数 |
| VPCエンドポイント  | VPCエンドポイント1つ当たり，1個         |
| ECS                | Elastic Network Interface 数と同じ個数  |
| Lambda             | Elastic Network Interface 数と同じ個数  |

#### ・Subnetの種類

Subnetには，役割ごとにいくつか種類がある．

| 名前                            | 役割                                    |
| ------------------------------- | --------------------------------------- |
| Public subnet (Frontend Subnet) | NATGatewayを配置する．                  |
| Private app subnet              | アプリケーション，Nginxなどを配置する． |
| Private datastore subnet        | RDS，Redisなどを配置する                |

![Subnetの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Subnetの種類.png)

<br>

### VPCエンドポイント

![VPCエンドポイント](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCエンドポイント.png)

#### ・VPCエンドポイントとは

VPCのプライベートサブネット内のリソースが，VPC外のリソースに対して，アウトバウンド通信を実行できるようにする．Gateway型とInterface型がある．VPCエンドポイントを使用しない場合，プライベートサブネット内からのアウトバウンド通信には，インターネットゲートウェイとNAT Gatewayを使用する必要がある．

#### ・メリット

インターネットゲートウェイとNAT Gatewayの代わりに，VPCエンドポイントを使用すると，料金が少しだけ安くなり，また，VPC外のリソースとの通信がより安全になる．

#### ・タイプ

| タイプ      | 説明                                                         | リソース例                       |
| ----------- | ------------------------------------------------------------ | -------------------------------- |
| Gateway型   | ルートテーブルにおける定義に則って，VPCエンドポイントに対してアウトバウンド通信を行う． | S3，DynamoDBのみ                 |
| Interface型 | プライベートリンクともいう．プライベートIPアドレスを持つENIに対して，アウトバウンド通信を行う． | S3，DynamoDB以外の全てのリソース |

#### ・VPCエンドポイントサービス

VPCエンドポイントとは異なる機能なので注意．Interface型のVPCエンドポイントとNLBを組み合わせることにより，異なるVPC間で通信できるようにする．エンドポイントのサービス名は，「``` com.amazonaws.vpce.ap-northeast-1.vpce-svc-xxxxx```」になる．

![VPCエンドポイントサービス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCエンドポイントサービス.png)

<br>

### VPCピアリング接続

![VPCピアリング接続](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続.png)

#### ・VPCピアリング接続とは

異なるVPCにあるAWSリソースの間で，相互にデータ通信を行うことができる．

#### ・VPCピアリング接続ができない場合

| アカウント   | VPCのあるリージョン | VPC内のCIDRブロック    | 接続の可否 |
| ------------ | ------------------- | ---------------------- | ---------- |
| 同じ／異なる | 同じ／異なる        | 全て異なる             | **〇**     |
|              |                     | 同じものが一つでもある | ✕          |

VPC に複数の IPv4 CIDR ブロックがあり，一つでも 同じCIDR ブロックがある場合は、VPC ピアリング接続はできない．

![VPCピアリング接続不可の場合-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-1.png)

たとえ，IPv6が異なっていても，同様である．

![VPCピアリング接続不可の場合-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VPCピアリング接続不可の場合-2.png)

#### ・VPCエンドポイントサービスとの比較

| 機能                       | VPCピアリング                                     | VPCエンドポイントサービス           |
| -------------------------- | ------------------------------------------------- | ----------------------------------- |
| 接続可能なVPC数            | 一対一のみ                                        | 一対多                              |
| 接続可能なIPアドレスの種類 | IPv4，IPv6                                        | IPv4                                |
| 接続可能なCIDRブロック     | 両VPCのCIDRブロックが重複していると接続できない． | 重複していても接続できる．          |
| 接続可能なリソース         | 制限なし                                          | NLBでルーティングできるリソースのみ |
| クロスアカウント           | 可能                                              | 可能                                |
| クロスリージョン           | 可能                                              | 不可能                              |

<br>

## 06. アプリケーションインテグレーション

### SQS：Simple Queue Service

![AmazonSQSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AmazonSQSとは.jpeg)

#### ・SQSとは

クラウドメッセージキューとして働く．異なるVPC間でも，メッセージキューを同期できる．クラウドサーバで生成されたメッセージは，一旦SQSに追加される．コマンドによってバッチが実行され，メッセージが取り出される．その後，例えば，バッチ処理によってメッセージからデータが取り出されてファイルが生成され，S3に保存されるような処理が続く．

#### ・SQSの種類

| 設定項目         | 説明 |
| ---------------- | ---- |
| スタンダード方式 |      |
| FIFO方式         |      |

<br>

### SNS：Simple Notification Service

![SNSとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SNSとは.png)

#### ・SNSとは

パブリッシャーから発信されたメッセージをエンドポイントで受信し，サブスクライバーに転送するAWSリソース．

| 設定項目           | 説明                                                 |
| ------------------ | ---------------------------------------------------- |
| トピック           | 複数のサブスクリプションをグループ化したもの．       |
| サブスクリプション | エンドポイントで受信するメッセージの種類を設定する． |

#### ・サブスクリプション

| メッセージの種類 | 転送先               | 備考                                                         |
| ---------------- | -------------------- | ------------------------------------------------------------ |
| HTTPS            | 任意のドメイン名     | Chatbotのドメイン名は「```https://global.sns-api.chatbot.amazonaws.com```」 |
| Eメール          | 任意のメールアドレス |                                                              |
| JSON形式のメール | 任意のメールアドレス |                                                              |
| SQS              | SQS                  |                                                              |
| Lambda           | Lambda               |                                                              |
| SMS              | SMS                  |                                                              |

<br>

## 07. 管理，ガバナンス

### オートスケーリング

#### ・オートスケーリングとは

AWSリソースの自動水平スケーリングを自動的に実行する．

![Auto-scaling](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Auto-scaling.png)

#### ・起動設定

スケーリングの対象となるAWSリソースを定義する．

#### ・スケーリンググループ

スケーリングのグループ構成を定義する．各グループで最大最小必要数を設定できる．

#### ・スケーリングポリシー

スケーリングの方法を定義する．

| 種類                       | 説明                                                         | 備考                                                         |
| -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| シンプルスケーリング       | 特定のメトリクスに単一の閾値を設定し，それに応じてスケーリングを行う． |                                                              |
| ステップスケーリング       | 特定のメトリクスに段階的な閾値を設定し，それに応じて段階的にスケーリングを実行する． | （例）CPU平均使用率に段階的な閾値を設定する．<br>・40%の時にインスタンスが１つスケールアウト<br>・70%の時にインスタンスを２つスケールアウト<br>・90%の時にインスタンスを３つスケールアウト |
| ターゲット追跡スケーリング | 特定のメトリクス（CPU平均使用率やMemory平均使用率）にターゲット値を設定し，それに収束するように自動的にスケールインとスケールアウトを実行する． | ターゲット値を設定できるリソースの例<br>・ECSサービスのタスク数<br>・RDSクラスターのAuroraのリードレプリカ数<br>・Lambdaのスクリプト同時実行数 |

<br>

### Chatbot

#### ・Chatbotとは

![ChatbotとSNSの連携](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ChatbotとSNSの連携.png)

SNSを経由して，CloudWatchからの通知をチャットアプリに転送するAWSリソース．クライアントをSlackとした場合の設定を以下に示す．

| 設定項目        | 説明                                                         |
| --------------- | ------------------------------------------------------------ |
| Slackチャンネル | 通知の転送先のSlackチャンネルを設定する．                    |
| アクセス許可    | SNSを介して，CloudWatchにアクセスするためのロールを設定する． |
| SNSトピック     | CloudWatchへのアクセス時経由する，SNSトピックを設定する．    |

<br>

### CloudTrail

#### ・CloudTrailとは

IAMユーザによる操作や，ロールのアタッチの履歴を記録し，ログファイルとしてS3に転送する．CloudWatchと連携することもできる．

![CloudTrailとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CloudTrailとは.jpeg)

<br>

## 07-02. 管理，ガバナンス｜CloudWatch


### CloudWatch

#### ・AWS CLI

**＊コマンド例＊**

```sh
# CloudWatchのアラームの状態を変更する．
aws cloudwatch set-alarm-state --alarm-name "Alarm名" --state-value ALARM --state-reason "アラーム文言"
```

<br>

### CloudWatchエージェント

#### ・CloudWatchエージェントとは

EC2インスタンス内で発生したデータを収集し，CloudWatchに対してプッシュする常駐システムのこと．

#### ・CloudWatchエージェントの設定

CloudWatchエージェントは，```/opt/aws/amazon-cloudwatch-agent/bin/config.json```ファイルの定義を元に，実行される．設定ファイルは，分割できる．

| セクションの種類        | 説明                                   | 備考                                                         |
| ----------------------- | -------------------------------------- | ------------------------------------------------------------ |
| ```agent```セクション   | CloudWatchエージェント全体を設定する． | ・ウィザードを使用した場合，このセクションの設定はスキップされる．<br>・実装しなかった場合，デフォルト値が適用される． |
| ```metrics```セクション |                                        | ・ウィザードを使用した場合，このセクションの設定はスキップされる．<br>・実装しなかった場合，何も設定されない． |
| ```logs```セクション    |                                        |                                                              |

設定後，```amazon-cloudwatch-agent-ctl```コマンドで設定ファイルを読み込ませる．

**＊コマンド例＊**

```sh
# EC2内にある設定ファイルを，CloudWatchエージェントに読み込ませる（再起動を含む）
$ /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

# プロセスのステータスを確認
$ /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

```sh
# 設定ファイルが読み込まれたかを確認

### CloudWatchエージェントのプロセスのログファイル
$ tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log

### 設定ファイルの構文チェックのログファイル
$ tail -f /opt/aws/amazon-cloudwatch-agent/logs/configuration-validation.log

### OS起動時にデーモンが稼働するように設定されているかを確認
$ systemctl list-unit-files --type=service
```

#### ・logセクションのみの場合

CloudWatchエージェントを使用して，CloudWatchにログファイルをプッシュするだけであれば，設定ファイル（```/opt/aws/amazon-cloudwatch-agent/bin/config.json```）には```log```セッションのみの実装で良い．```run_as_user```には，プロセスのユーザ名（例：```cwagent```）を設定する．

**＊実装例＊**

```json
{
  "agent": {
    "run_as_user": "cwagent"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "/example-www/var/log/nginx/error_log",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/php-fpm/error.log",
            "log_group_name": "/example-www/var/log/php-fpm/error_log",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
```

<br>

### CloudWatch Logs

####  ・CloudWatch Logsとは

クラウドログサーバとして働く．様々なAWSリソースで生成されたログファイルを収集できる．

| 設定項目                     | 説明                                                       | 備考                                                         |
| ---------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| ロググループ                 | ログストリームをグループ化して収集するかどうかを設定する． | 基本的に，ログファイルはグループ化せずに，一つのロググループには一つのログストリームしか含まれないようにする．ただし，EC2インスタンスを冗長化しあばあ |
| メトリクスフィルター         | 紐づくロググループで，出現を監視する文字列を設定する．     |                                                              |
| サブスクリプションフィルター |                                                            |                                                              |
| Logs Insights                | クエリを使用してログを抽出できる．                         |                                                              |

#### ・メトリクスフィルターの詳細項目

| 設定項目           | 説明                                                         | 備考                                                       |
| ------------------ | ------------------------------------------------------------ | ---------------------------------------------------------- |
| フィルターパターン | 紐づくロググループで，メトリクス値増加のトリガーとする文字列を設定する． | 大文字と小文字を区別するため，網羅的に設定する必要がある． |
| 名前空間           | 紐づくロググループが属する名前空間を設定する．CloudWatch Logsが，設定した名前空間に対して，値を発行する． |                                                            |
| メトリクス         | 紐づくロググループが属する名前空間内のメトリクスを設定する．CloudWatch Logsが，設定したメトリクスに対して，値を発行する． |                                                            |
| メトリクス値       | フィルターパターンで文字列が検出された時に，メトリクスに対して発行する値のこと． | 例えば「検出数」を発行する場合は，「１」を設定する．       |

#### ・フィルターパターンのテンプレート

```
# OR条件で大文字小文字を考慮し，「XXXXX:」を検出
?"WARNING:" ?"Warning:" ?"ERROR:" ?"Error:" ?"CRITICAL:" ?"Critical:" ?"EMERGENCY:" ?"Emergency:" ?"ALERT:" ?"Alert:"
```

```
# OR条件で大文字小文字を考慮し，「XXXXX message」を検出
?"WARNING message" ?"Warning message" ?"ERROR message" ?"Error message" ?"CRITICAL message" ?"Critical message" ?"EMERGENCY message" ?"Emergency message" ?"ALERT message" ?"Alert message"
```

#### ・名前空間，メトリクス，ディメンションとは

![名前空間，メトリクス，ディメンション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/名前空間，メトリクス，ディメンション.png)

#### ・CloudWatch Logsエージェントの設定（非推奨）

2020/10/05現在は非推奨で，CloudWatchエージェントへの設定の移行が推奨されている．

**＊実装例＊**

confファイルを，EC2内の```etc```ディレクトリ下に設置する．

```
#############################
# /var/awslogs/awscli.conf
#############################

[plugins]
cwlogs = cwlogs
[default]
region = ap-northeast-1
```

OS，ミドルウェア，アプリケーション，の各層でログを収集するのがよい．

**＊実装例＊**

```
#############################
# /var/awslogs/awslogs.conf
#############################

# ------------------------------------------
# CentOS CloudWatch Logs
# ------------------------------------------
[/var/log/messages]

# タイムスタンプ
#（例）Jan 1 00:00:00
datetime_format = %b %d %H:%M:%S
#（例）2020-01-01 00:00:00
# datetime_format = %Y-%m-%d %H:%M:%S

# 収集したいログファイル．ここでは，CentOSのログを指定．
file = /var/log/messages

# 要勉強
buffer_duration = 5000
initial_position = start_of_file

# インスタンスID
log_stream_name = {instance_id}

# AWS上で管理するロググループ名
log_group_name = /var/log/messages

# ------------------------------------------
# Nginx CloudWatch Logs
# ------------------------------------------
[/var/log/nginx/error.log]
file             = /var/log/nginx/error.log
buffer_duration  = 5000
log_stream_name  = {instance_id}
initial_position = start_of_file
log_group_name   = /var/log/nginx/error_log.production

# ------------------------------------------
# Application CloudWatch Logs
# ------------------------------------------
[/var/www/project/app/storage/logs/laravel.log]
file             = /var/www/project/app/storage/logs/laravel.log
buffer_duration  = 5000
log_stream_name  = {instance_id}
initial_position = start_of_file
log_group_name   = /var/www/project/app/storage/logs/laravel_log.production
```

設定後，```awslogs```コマンドでプロセスを起動する．

**＊コマンド例＊**

```sh
# CloudWatchエージェントの再起動
# 注意: restartだとCloudWatchに反映されない時がある．
$ service awslogs restart

# もしくは
$ service awslogs stop
$ service awslogs start

# ログが新しく生成されないと変更が適用されないことがあるため，ログファイルに適当な文字列行を増やしてみる．
```

<br>

### CloudWatch Events

#### ・CloudWatch Eventsとは

イベントを検知し，指定したアクションを行う．

| イベント例                        |      | アクション例                               |
| --------------------------------- | ---- | ------------------------------------------ |
| ECSタスクスケジュール機能の有効化 | ⇒    | 決められた時間にスケジューリング機能を発火 |
| APIのコール                       | ⇒    | Lambdaによる関数の実行                     |
| AWSコンソールへのログイン         | ⇒    | SQSによるメッセージの格納                  |
| インスタンスの状態変化            | ⇒    | SNSによるメール通知                        |
| ...                               | ⇒    | ...                                        |

<br>

### CloudWatch Alarm

<br>

## 08. 開発者用ツール

### CodeDeploy

#### ・CodeDeployとは

#### ・appspecファイル

デプロイの設定を行う．

```yaml
version: 0.0

Resources:
  - TargetService:
      # 使用するAWSリソース
      Type: AWS::ECS::Service
      Properties:
        # 使用するタスク定義．<TASK_DEFINITION> とすると，自動補完してくれる．
        TaskDefinition: "<TASK_DEFINITION>"
        # 使用するロードバランサー
        LoadBalancerInfo:
          ContainerName: "xxx-container"
          ContainerPort: "80"
```

#### ・ライフサイクルイベント

<br>


## 09. カスタマーエンゲージメント｜SES

### SES：Simple Email Service

![SESとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/SESとは.png)

#### ・SESとは

クラウドメールサーバとして働く．メール受信をトリガーとして，アクションを実行できる．

| 設定項目           | 説明                                                         | 備考                                                         |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Domain             | SESのドメイン名を設定する．                                  | 設定したドメイン名には，「```10 inbound-smtp.us-east-1.amazonaws.com```」というMXレコードタイプの値が紐づく． |
| Email Addresses    | 送信先として認証するメールアドレスを設定する．設定するとAWSからメールが届くので，指定されたリンクをクリックする． | Sandboxモードの時だけ機能する．                              |
| Sending Statistics | SESで収集されたデータをメトリクスで確認できる．              | ```Request Increased Sending Limits```のリンクにて，Sandboxモードの解除を申請できる． |
| SMTP Settings      | SMTP-AUTHの接続情報を確認できる．                            | アプリケーションの25番ポートは送信制限があるため，465番を使用する．これに合わせて，SESも受信で465番ポートを使用するようにする． |
| Rule Sets          | メールの受信したトリガーとして実行するアクションを設定できる． |                                                              |
| IP Address Filters |                                                              |                                                              |

#### ・Rule Sets

| 設定項目 | 説明                                                         |
| -------- | ------------------------------------------------------------ |
| Recipiet | 受信したメールアドレスで，何の宛先の時にこれを許可するかを設定する． |
| Actions  | 受信を許可した後に，これをトリガーとして実行するアクションを設定する． |

<br>

### 仕様上の制約

#### ・構築リージョンの制約

SESは連携するAWSリソースと同じリージョンに構築しなければならない．

#### ・Sandboxモードの解除

SESはデフォルトではSandboxモードになっている．Sandboxモードでは以下の制限がかかっており．サポートセンターに解除申請が必要である．

| 制限     | 説明                                          |
| -------- | --------------------------------------------- |
| 送信制限 | SESで認証したメールアドレスのみに送信できる． |
| 受信制限 | 1日に200メールのみ受信できる．                |

<br>

### SMTP-AUTH

#### ・AWSにおけるSMTP-AUTHの仕組み

一般的なSMTP-AUTHでは，クライアントユーザの認証が必要である．同様にして，AWSにおいてもこれが必要であり，IAMユーザを用いてこれを実現する．送信元となるアプリケーションにIAMユーザを紐付け，アプリケーションがSESを介してメールを送信する時，IAMユーザがもつユーザ名とパスワードを認証に用いる．ユーザ名とパスワードは後から確認できないため，メモしておくこと．SMTP-AUTHの仕組みについては，別ノートを参照せよ．

<br>

## 10. ビジネスアプリケーション

### WorkMail

#### ・WorkMailとは

AWSから提供されている．Gmail，サンダーバード，Yahooメールなどと同類のアプリケーション．

| 設定項目              | 説明                                                     | 備考                                                         |
| --------------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| Users                 | WorkMailで管理するユーザを設定する．                     |                                                              |
| Domains               | ユーザに割り当てるメールアドレスのドメイン名を設定する． | ```@{組織名}.awsapps.com```をドメイン名としてもらえる．ドメイン名の検証が完了した独自ドメイン名を設定することもできる． |
| Access Controle rules | 受信するメール，受信を遮断するメール，の条件を設定する． |                                                              |

<br>

## 11. 暗号化とPKI｜Certificate Manager

### Certificate Manager

#### ・Certificate Managerとは

認証局であるATSによって認証されたSSLサーバ証明書を管理できるAWSリソース．

| 自社の中間認証局名         | ルート認証局名 |
| -------------------------- | -------------- |
| ATS：Amazon Trust Services | Starfield社    |

| 設定項目   | 説明                                       |
| ---------- | ------------------------------------------ |
| ドメイン名 | 認証をリクエストするドメイン名を設定する． |
| 検証の方法 | DNS検証かEmail検証かを設定する．           |

<br>

### ドメインの承認方法

#### ・DNS検証

CNAMEレコードランダムトークンを用いて，ドメイン名の所有者であることを証明する方法．ACMによって生成されたCNAMEレコードランダムトークンが提供されるので，これをRoute53に設定しておけば，ACMがこれを検証し，証明書を発行してくれる．

<br>

### 証明書

#### ・セキュリティポリシー

許可するプロトコルを定義したルールこと．SSL/TLSプロトコルを許可しており，対応できるバージョンが異なるため，ブラウザがそのバージョンのSSL/TLSプロトコルを使用できるかを認識しておく必要がある．

|                      | Policy-2016-08 | Policy-TLS-1-1 | Policy-TLS-1-2 |
| -------------------- | :------------: | :------------: | :------------: |
| **Protocol-TLSv1**   |       〇       |       ✕        |       ✕        |
| **Protocol-TLSv1.1** |       〇       |       〇       |       ✕        |
| **Protocol-TLSv1.2** |       〇       |       〇       |       〇       |

#### ・SSLサーバ証明書の種類

DNS検証またはEメール検証によって，ドメイン名の所有者であることが証明されると，発行される．証明書は，PKIによる公開鍵検証に用いられる．

| 証明書の種類         | 説明                                             |
| -------------------- | ------------------------------------------------ |
| ワイルドカード証明書 | 証明するドメイン名にワイルドカードを用いたもの． |

#### ・SSLサーバ証明書の設置場所パターン

AWSの使用上，ACM証明書を設置できないAWSリソースに対しては，外部の証明書を手に入れて設置する．HTTPSによるSSLプロトコルを受け付けるネットワークの最終地点のことを，SSLターミネーションという．

| パターン<br>（Route53には必ず設置）                       | SSLターミネーション<br>（HTTPSの最終地点） | 備考                                                         |
| --------------------------------------------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| Route53 → ALB(+ACM証明書) → EC2                           | ALB                                        |                                                              |
| Route53 → Cloud Front(+ACM証明書) → ALB(+ACM証明書) → EC2 | ALB                                        | Cloud Frontはバージニア北部で，またALBは東京リージョンで，証明書を構築する必要がある．Cloud Frontに送信されたHTTPSリクエストをALBにルーティングするために，両方に関連付ける証明書で承認するドメインは，一致させる必要がある． |
| Route53 → Cloud Front(+ACM証明書) → EC2                   | Cloud Front                                |                                                              |
| Route53 → Cloud Front(+ACM証明書) → S3                    | Cloud Front                                |                                                              |
| Route53 → ALB(+ACM証明書) → EC2(+外部証明書)              | EC2                                        |                                                              |
| Route53 → NLB → EC2(+外部証明書)                          | EC2                                        |                                                              |
| Route53 → EC2(+外部証明書)                                | EC2                                        |                                                              |
| Route53 → Lightsail(+ACM証明書)                           | Lightsail                                  |                                                              |

<br>

## 12. セキュリティ｜WAF

### AWSリソース vs. サイバー攻撃

| サイバー攻撃の種類 | 対抗するAWSリソースの種類                                    |
| ------------------ | ------------------------------------------------------------ |
| マルウェア         | なし                                                         |
| 傍受，盗聴         | VPC内の特にプライベートサブネット間のピアリング接続．VPC外を介さずにデータを送受信できる． |
| ポートスキャン     | セキュリティグループ                                         |
| DDoS               | Shield                                                       |
| ゼロディ           | WAF                                                          |
| インジェクション   | WAF                                                          |
| XSS                | WAF                                                          |
| データ漏洩         | KMS，CloudHSM                                                |
| 組織内部での裏切り | IAM                                                          |

<br>

### WAF：Web Applicarion Firewall

#### ・WAFとは

| 設定項目                          | 説明                                                         | 備考                                                         |
| --------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Web ACLs：Web Access Control List | 各トリガーと許可／拒否アクションの関連付けを「ルール」とし，これをセットで設定する． | アタッチするAWSリソースに合わせて，リージョンが異なる．      |
| IP sets                           | アクション実行のトリガーとなるIPアドレス                     | ・許可するIPアドレスは，意味合いに沿って異なるセットとして構築するべき．例えば，社内IPアドレスセット，協力会社IPアドレスセット，など<br>・拒否するIPアドレスはひとまとめにしてもよい． |
| Regex pattern sets                | アクション実行のトリガーとなるURLパスの文字列                | ・許可／拒否する文字列は，意味合いに沿って異なる文字列セットとして構築するべき．例えば，ユーザエージェントセット，リクエストパスセット，など |
| Rule groups                       |                                                              |                                                              |
| AWS Markets                       |                                                              |                                                              |

<br>

### Web ACLs

#### ・Web ACLsの詳細項目

| 設定項目                 | 説明                                                         | 備考                                   |
| ------------------------ | ------------------------------------------------------------ | -------------------------------------- |
| Overview                 | WAFによって許可／拒否されたリクエストのアクセスログを確認できる． |                                        |
| Rules                    | 順番にルールを判定し，一致するルールがあればアクションを実行する．この時，一致するルールの後にあるルールは．判定されない． | ルールの設定を参照せよ．               |
| Associated AWS resources | WAFをアタッチするAWSリソースを設定する．                     | Cloud Front，ALBなどにアタッチできる． |
| Logging and metrics      | アクセスログをKinesis Data Firehoseに出力するように設定する． |                                        |

#### ・OverviewにおけるSampled requestsの見方

「全てのルール」または「個別のルール」におけるアクセス許可／拒否の履歴を確認できる．ALBやCloud Frontのアクセスログよりも解りやすく，様々なデバッグに役立つ．ただし，３時間分しか残らない．一例として，Cloud FrontにアタッチしたWAFで取得できるログを以下に示す．

```http
GET /example/
# ホスト
Host: example.jp
Upgrade-Insecure-Requests: 1
# ユーザエージェント
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
# CORSであるか否か
Sec-Fetch-Site: same-origin
Accept-Encoding: gzip, deflate, br
Accept-Language: ja,en;q=0.9
# Cookieヘッダー
Cookie: PHPSESSID=<セッションID>; _gid=<GoogleAnalytics値>; __ulfpc=<GoogleAnalytics値>; _ga=<GoogleAnalytics値>
```

<br>

### Rulesの例

#### ・ルールの粒度

わかりやすさの観点から，可能な限り設定するステートメントを少なくし，一つのルールに一つの意味合いだけを持たせるように命名する．

#### ・ユーザエージェント拒否

**＊具体例＊**

悪意のあるユーザエージェントを拒否する．

ルール：block-user-agents

| Statementの順番 | If a request | Inspect  | Match type                             | Regex pattern set | Then  | 挙動                                                         |
| --------------- | ------------ | -------- | -------------------------------------- | ----------------- | ----- | ------------------------------------------------------------ |
| 0               | matches      | URI path | Matches pattern from regex pattern set | 文字列セット      | Block | 指定した文字列を含むユーザエージェントの場合に，アクセスすることを拒否する． |

| Default Action | 説明                                                         |
| -------------- | ------------------------------------------------------------ |
| Allow          | 指定したユーザエージェントでない場合に，全てのファイルパスにアクセスすることを許可する． |

#### ・CI/CDツールのアクセスを許可

**＊具体例＊**

社内の送信元IPアドレスのみ許可した状態で，CircleCIなどのサービスが社内サービスにアクセスできるようにする．

ルール：allow-request-including-access-token

| Statementの順番 | If a request | Inspect | Header field name | Match type              | String to match                                     | Then  | 挙動                                                         |
| --------------- | ------------ | ------- | ----------------- | ----------------------- | --------------------------------------------------- | ----- | ------------------------------------------------------------ |
| 0               | matches      | Header  | authorization     | Exactly matched  string | 「```Bearer <トークン文字列>```」で文字列を設定する | Allow | authorizationヘッダーに指定した文字列を含むリクエストの場合に，アクセスすることを拒否する． |

| Default Action | 説明                                                         |
| -------------- | ------------------------------------------------------------ |
| Block          | 正しいトークンを持たないアクセスの場合に，全てのファイルパスにアクセスすることを拒否する． |

#### ・特定のパスを社内アクセスに限定

**＊具体例＊**

アプリケーションにおいて，特定のURLパスにアクセスできる送信元IPアドレスを，社内だけに制限する．二つのルールを構築する必要がある．

ルール：allow-access--to-url-path

| Statementの順番 | If a request  | Inspect                          | IP set       | Match type                             | Regex pattern set | Then  | 挙動                                                         |
| --------------- | ------------- | -------------------------------- | ------------ | -------------------------------------- | ----------------- | ----- | ------------------------------------------------------------ |
| 0               | matches (AND) | Originates from an IP address in | 社内IPセット | -                                      | -                 | -     | 社内の送信元IPアドレスの場合に，指定したファイルパスにアクセスすることを許可する． |
| 1               | matches       | URI path                         | -            | Matches pattern from regex pattern set | 文字列セット      | Allow | 0番目かつ，指定した文字列を含むURLパスアクセスの場合に，アクセスすることを許可する． |

ルール：block-access-to-url-path

| Statementの順番 | If a request | Inspect  | Match type                             | Regex pattern set | Then  | 挙動                                                         |
| --------------- | ------------ | -------- | -------------------------------------- | ----------------- | ----- | ------------------------------------------------------------ |
| 0               | matches      | URI path | Matches pattern from regex pattern set | 文字列セット      | Block | 指定した文字列を含むURLパスアクセスの場合に，アクセスすることを拒否する． |

| Default Action | 説明                                                         |
| -------------- | ------------------------------------------------------------ |
| Allow          | 指定したURLパス以外のアクセスの場合に，そのパスにアクセスすることを許可する． |

#### ・社内アクセスに限定

**＊具体例＊**

アプリケーション全体にアクセスできる送信元IPアドレスを，特定のIPアドレスだけに制限する．

ルール：allow-global-ip-addresses

| Statementの順番 | If a request  | Inspect                          | IP set           | Originating address | Then  | 挙動                                                         |
| --------------- | ------------- | -------------------------------- | ---------------- | ------------------- | ----- | ------------------------------------------------------------ |
| 0               | matches  (OR) | Originates from an IP address in | 社内IPセット     | Source IP address   | -     | 社内の送信元IPアドレスの場合に，全てのファイルパスにアクセスすることを許可する． |
| 1               | matches       | Originates from an IP address in | 協力会社IPセット | Source IP address   | Allow | 0番目あるいは，協力会社の送信元IPアドレスの場合に，全てのファイルパスにアクセスすることを許可する． |

| Default Action | 説明                                                         |
| -------------- | ------------------------------------------------------------ |
| Block          | 指定した送信元IPアドレス以外の場合に，全てのファイルパスにアクセスすることを拒否する． |

<br>

## 12-02. セキュリティ｜IAM

### IAMポリシー，IAMステートメント：Identify and Access Management

#### ・IAMポリシーとは

実行権限のあるアクションが定義されたIAMステートメントのセットを持つ，JSONデータのこと．

#### ・IAMポリシーの種類

| IAMポリシーの種類                  | 説明                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| アイデンティティベースのポリシー   | IAMユーザ，IAMグループ，IAMロール，に付与するためのポリシーのこと． |
| リソースベースのインラインポリシー | 単一のAWSリソースにインポリシーのこと．                      |
| アクセスコントロールポリシー       | json形式で定義する必要が無いポリシーのこと．                 |

**＊具体例＊**

以下に，EC2の読み出しのみ権限（```AmazonEC2ReadOnlyAccess```）を付与できるポリシーを示す．このIAMポリシーには，他のAWSリソースに対する権限も含まれている．

```yaml
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

実行権限のあるアクションを定義した，JSONデータのこと．

**＊具体例＊**

以下のポリシーを付与されたAWSリソースは，任意のSSMパラメータを取得できるようになる．

```yaml
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}

```

| Statementの項目 | 説明                                             |
| --------------- | ------------------------------------------------ |
| Sid             | 任意の一意な文字列を設定する．空文字でもよい．   |
| Effect          | 許可または拒否を設定する．                       |
| Action          | リソースに対して実行できるアクションを設定する． |
| Resource        | アクションの実行対象に選べるリソースを設定する． |


以下に主要なアクションを示す．

| アクション名 | 説明                   |
| ------------ | ---------------------- |
| Create       | リソースを構築する．   |
| Describe     | リソースを表示する．   |
| Delete       | リソースを削除する．   |
| Get          | リソースを取得する．   |
| Put          | リソースを上書きする． |

<br>

### アイデンティティベースのポリシー

#### ・アイデンティティベースのポリシーとは

IAMユーザ，IAMグループ，IAMロール，に付与するためのポリシーのこと．

#### ・AWS管理ポリシー

AWSが提供しているポリシーのこと．アタッチ式のポリシーのため，すでにアタッチされていても，他のものにもアタッチできる．

#### ・カスタマー管理ポリシー

ユーザが独自に構築したポリシーのこと．すでにアタッチされていても，他のものにもアタッチできる．

#### ・インラインポリシー

単一のアイデンティティに付与するためのポリシーのこと．組み込み式のポリシーのため，アイデンティティ間で共有してアタッチすることはできない．

**＊実装例＊**

IAMユーザ，IAMグループ，IAMロールは，ユーザーアカウントのすべての ACM 証明書を一覧表示できるようになる．

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":"acm:ListCertificates",
      "Resource":"*"
    }
  ]
}
```

**＊実装例＊**

IAMユーザ，IAMグループ，IAMロールは，全てのAWSリソースに，任意のアクションを実行できる．

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":"*",
      "Resource":"*"
    }
  ]
}
```

<br>

### リソースベースのインラインポリシー

#### ・リソースベースのインラインポリシーとは

単一のAWSリソースにインポリシーのこと．すでにアタッチされていると，他のものにはアタッチできない．

#### ・バケットポリシー

S3にアタッチされる，自身へのアクセスを制御するためのインラインポリシーのこと．

#### ・ライフサイクルポリシー

ECRにアタッチされる，イメージの有効期間を定義するポリシー．コンソール画面から入力できるため，基本的にポリシーの実装は不要であるが，TerraformなどのIaCツールでは必要になる．

**＊実装例＊**

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images untagged",
      "selection": {
        "tagStatus": "untagged",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 10 images any",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}

```

#### ・信頼ポリシー

ロールにアタッチされる，Assume Roleを行うためのインラインポリシーのこと．

**＊実装例＊**

例えば，以下の信頼ポリシーを任意のロールに付与したとする．その場合，```Principal```の```ecs-tasks```が信頼されたエンティティと見なされ，ロールをアタッチすることができるようになる．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

信頼ポリシーでは，IAMユーザを信頼されたエンティティとして設定することもできる．

**＊実装例＊**

例えば，以下の信頼ポリシーを任意のロールに付与したとする．その場合，```Principal```のIAMユーザが信頼されたエンティティと見なされ，ロールをアタッチすることができるようになる．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<アカウントID>:user/<ユーザ名>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<適当な文字列>"
        }
      }
    }
  ]
}
```

<br>

### IAMポリシーを付与できる対象

#### ・IAMユーザに対する付与

![IAMユーザにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMユーザにポリシーを付与.jpeg)

#### ・IAMグループに対する付与

![IAMグループにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMグループにポリシーを付与.jpeg)

#### ・IAMロールに対する付与

![IAMロールにポリシーを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IAMロールにポリシーを付与.jpeg)

<br>

### ルートユーザ，IAMユーザ

#### ・ルートユーザとは

全ての権限をもったアカウントのこと．

#### ・IAMユーザとは

特定の権限をもったアカウントのこと．

#### ・```credentials```ファイル

AWS CLIでクラウドインフラを操作するためには，```credentials```ファイルに定義されたプロファイルが必要である．

```sh
$ aws configure set aws_access_key_id "XXXXX"
$ aws configure set aws_secret_access_key "XXXXX"
$ aws configure set aws_default_region "ap-northeast-1"
```

```
# Linux，Unixの場合：$HOME/.aws/<credentialsファイル名>
# Windowsの場合：%USERPROFILE%\.aws\<credentialsファイル名>

[default]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>

[user1]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>
```

#### ・AWS CLIの社内アクセス制限

特定の送信元IPアドレスを制限するポリシーをIAMユーザに付与することで，そのIAMユーザがAWS CLIの実行する時に，社外から実行できないように制限をかけられる．

**＊実装例＊**

```json
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Deny",
    "Action": "*",
    "Resource": "*",
    "Condition": {
      "NotIpAddress": {
        "aws:SourceIp": [
          "nn.nnn.nnn.nnn/32",
          "nn.nnn.nnn.nnn/32"
        ]
      }
    }
  }
}
```

#### ・AWS CLI

```sh
# ユーザ名を変更する．
$ aws iam update-user --user-name <現行のユーザ名> --new-user-name <新しいユーザ名>
```

<br>

### IAMグループ

#### ・IAMグループとは

IAMユーザをグループ化したもの．IAMグループごとにIAMロールを付与すれば，IAMユーザのIAMロールを管理しやすくなる．

![グループ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループ.png)

<br>

### IAMロール

#### ・IAMロールとは

IAMポリシーのセットを持つ

#### ・IAMロールの種類

| IAMロールの種類                  | 説明                                                         | 備考                                                         |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| サービスリンクロール             | AWSリソースを構築した時に自動的に作成されるロール．他にはアタッチできない専用のポリシーがアタッチされている． | ・「AWSServiceRoleForXxxxxx」という名前で自動的に構築される．特に設定せずとも，自動的にリソースにアタッチされる．<br>・関連するリソースを削除するまで，ロール自体できない． |
| クロスアカウントのアクセスロール |                                                              |                                                              |
| プロバイダのアクセスロール       |                                                              |                                                              |

#### ・IAMロールを付与する方法

まず，IAMグループに対して，IAMロールを紐づける．そのIAMグループに対して，IAMロールを付与したいIAMユーザを追加していく．

![グループに所属するユーザにロールを付与](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/グループに所属するユーザにロールを付与.png)

<br>

## 12-03. セキュリティ｜STS

### STS：Security Token Service

#### ・STSとは

AWSリソースに一時的にアクセスできる認証情報（アクセスキー，シークレットアクセスキー，セッショントークン）を発行する．この認証情報は，一時的なアカウント情報として使用できる．

![STS](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/STS.jpg)

<br>

### STSの手順

#### 1. IAMロールに信頼ポリシーを付与

必要なポリシーが設定されたIAMロールを構築する．その時，信頼ポリシーにおいて，ユーザの```ARN```を信頼されたエンティティとして設定しておく．これにより，そのユーザに対して，ロールをアタッチできるようになる．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<アカウントID>:user/<ユーザ名>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<適当な文字列>"
        }
      }
    }
  ]
}
```

#### 2. ロールを引き受けたアカウント情報をリクエスト

信頼されたエンティティ（ユーザ）から，STS（```https://sts.amazonaws.com```）に対して，ロールのアタッチをリクエストする．

```sh
#!/bin/bash

set -xeuo pipefail
set -u

# 事前に環境変数にインフラ環境名を代入する．
case $ENV in
    "test")
        aws_account_id="<作業環境アカウントID>"
        aws_access_key_id="<作業環境アクセスキーID>"
        aws_secret_access_key="<作業環境シークレットアクセスキー>"
        aws_iam_role_external_id="<信頼ポリシーに設定した外部ID>"
    ;;
    "stg")
        aws_account_id="<ステージング環境アカウントID>"
        aws_access_key_id="<ステージング環境アクセスキーID>"
        aws_secret_access_key="<ステージング環境シークレットアクセスキー>"
        aws_iam_role_external_id="<信頼ポリシーに設定した外部ID>"
    ;;
    "prd")
        aws_account_id="<本番環境アカウントID>"
        aws_access_key_id="<本番環境アクセスキーID>"
        aws_secret_access_key="<本番環境シークレットアクセスキー>"
        aws_iam_role_external_id="<信頼ポリシーに設定した外部ID>"
    ;;
    *)
        echo "The parameter ${ENV} is invalid."
        exit 1
    ;;
esac

# 信頼されたエンティティのアカウント情報を設定する．
aws configure set aws_access_key_id "$aws_account_id"
aws configure set aws_secret_access_key "$aws_secret_access_key"
aws configure set aws_default_region "ap-northeast-1"

# https://sts.amazonaws.com に，ロールのアタッチをリクエストする．
aws_sts_credentials="$(aws sts assume-role \
  --role-arn "arn:aws:iam::${aws_access_key_id}:role/${ENV}-<アタッチしたいIAMロール名>" \
  --role-session-name "<任意のセッション名>" \
  --external-id "$aws_iam_role_external_id" \
  --duration-seconds "<セッションの有効秒数>" \
  --query "Credentials" \
  --output "json")"
```

STSへのリクエストの結果，ロールがアタッチされた新しいIAMユーザ情報を取得できる．この情報には有効秒数が存在し，期限が過ぎると新しいIAMユーザになる．秒数の最大値は，該当するIAMロールの概要の最大セッション時間から変更できる．

![AssumeRole](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/AssumeRole.png)

レスポンスされるデータは以下の通り．

```json
{
  "AssumeRoleUser": {
    "AssumedRoleId": "<セッションID>:<セッション名>",
    "Arn": "arn:aws:sts:<新しいアカウントID>:assumed-role/<IAMロール名>/<セッション名>"
  },
  "Credentials": {
    "SecretAccessKey": "<シークレットアクセスキー>",
    "SessionToken": "<セッショントークン文字列>",
    "Expiration": "<セッションの期限>",
    "AccessKeyId": "<アクセスキーID>"
  }
}
```

#### 3. レスポンスされたデータからアカウント情報を抽出

jqを使用して，JSONデータからアカウント情報を抽出する．

jq：https://stedolan.github.io/jq/


```sh
#!/bin/bash

cat << EOF > assumed_user.sh
export AWS_ACCESS_KEY_ID="$(echo "$aws_sts_credentials" | jq -r '.AccessKeyId')"
export AWS_SECRET_ACCESS_KEY="$(echo "$aws_sts_credentials" | jq -r '.SecretAccessKey')"
export AWS_SESSION_TOKEN="$(echo "$aws_sts_credentials" | jq -r '.SessionToken')"
export AWS_ACCOUNT_ID="$aws_account_id"
export AWS_DEFAULT_REGION="ap-northeast-1"
EOF
```

#### 4. ```credentials```ファイルを作成

ロールを引き受けた新しいアカウントの情報を，```credentials```ファイルに書き込む．

```shell
#!/bin/bash

aws configure --profile ${ENV}-lumonde << EOF
$(echo "$aws_sts_credentials" | jq -r '.AccessKeyId')
$(echo "$aws_sts_credentials" | jq -r '.SecretAccessKey')
ap-northeast-1
json
EOF

echo aws_session_token = $(echo "$aws_sts_credentials" | jq -r '.SessionToken') >> ~/.aws/credentials
```

#### 5. 接続確認

ロールを引き受けた新しいアカウントを使用して，AWSリソースに接続できるかを確認する．

```sh
#!/bin/bash

aws s3 ls --profile <プロファイル名>
2020-xx-xx xx:xx:xx <tfstateファイルが管理されるバケット名>
```

<br>

## 13. コスト管理

### コスト管理の観点

#### ・スペック

#### ・時間単価

#### ・数量

#### ・月額料金

<br>

### EBS

#### ・ボリュームサイズ

ボリュームの使用率にかかわらず，構築されたボリュームの合計サイズに基づいて，料金が発生する．そのため，安易に500GiBを選んではいけない．

<br>

### ECS

#### ・ECRの容量

500MBを超えると，請求が発生するため，古いイメージを定期的に削除する必要がある．

<br>

### Lambda

#### ・実行時間の従量課金制

関数を実行している時間分だけ料金がかかる．関数を使用せずに設置しているだけであれば，料金はかからない．

### SES

#### ・送受信数

受信は```1000件/月```まで，送信は```62000/月```まで無料である．

<br>

## 14. タグ

### タグ付け戦略

#### ・よくあるタグ

| タグ名      | 用途                                                         |
| ----------- | ------------------------------------------------------------ |
| Name        | リソース自体に名前を付けられない場合に，代わりにタグで名付けるため． |
| Environment | 同一のAWS環境内に異なる実行環境が存在している場合に，それらを区別するため． |
| User        | 同一のAWS環境内にリソース別に所有者が存在している場合に，それらを区別するため． |

#### ・タグ付けによるフィルタリング

AWSの各リソースには，タグをつけることができる．例えば，AWSコストエクスプローラーにて，このタグでフィルタリングすることにより，任意のタグが付いたリソースの請求合計額を確認することができる．

