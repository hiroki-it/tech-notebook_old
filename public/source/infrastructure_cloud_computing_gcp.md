# Google Cloud Platform

## 01. GCPによるWebサービスのリリース

GCPから，グローバルIPアドレスと完全修飾ドメイン名が提供され，Webサービスがリリースされる．

### クラウドデザイン例

以下のデザイン例では，Dualシステムが採用されている．

![GCPのクラウドデザイン一例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/GCPのクラウドデザイン一例.png)

### GAE：Google App Engine：GAE

クラウドデプロイサーバとして働く．AWSにおけるElastic Beanstalkに相当する．



### GCE：Google Compute Engine

クラウドWebサーバとして働く．AWSにおけるEC2に相当する．



### SSLサーバ証明書の設置場所

#### ・認証局

| サーバ提供者 | 自社の中間認証局名    | ルート認証局名 |
| ------------ | --------------------- | -------------- |
| GCP          | Google Trust Services |                |