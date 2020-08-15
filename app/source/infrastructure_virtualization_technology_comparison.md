# 仮想化技術の比較

## 01. 仮想化技術の種類

###  仮想化技術とは

自身の開発環境でWebサイトを動かしたい場合，まず，パソコン内にLinux環境のWebサーバ，APサーバ，DBサーバなどの物理サーバを仮想的に構築する．そして，自身のパソコンをクライアント，各仮想サーバをリクエスト先に見立てて，SSHプロトコルを用いてこれらのサーバにリモートログインする．仮想環境の構築方法にはいくつか種類がある．



### ホスト型仮想化

#### ・ホスト型仮想化とは

ホストOS上で，各サーバを仮想的に構築する．

#### ・Provider例

| 名前                 |
| -------------------- |
| VMware Workstation   |
| Oracle VM VirtualBox |

![ホスト型仮想化](https://user-images.githubusercontent.com/42175286/60386396-3afbd080-9acf-11e9-9094-f61aa839dc04.png)



### ハイパーバイザー型仮想化

#### ・ハイパーバイザー型仮想化とは

BIOSから起動したハイパーバイザー上で，各サーバを仮想的に構築する（※ホストOSは用いない）．

#### ・Provider例

| 名前                      |
| ------------------------- |
| VMware vSphere Hypervisor |
| Xen                       |
| KVM                       |

![ハイパーバイザー型仮想化](https://user-images.githubusercontent.com/42175286/60386395-3afbd080-9acf-11e9-9fbe-6287753cb43a.png)



### コンテナ型仮想化

#### ・コンテナ型仮想化とは

ホストOS上で，サーバではなく，サーバとしての機能を持つコンテナを仮想的に構築する．カーネルのリソースを分割できるNamespace（PID namespace，Network namespace，UID namespace）とControl Groupsを用いて，単一のOS上に独立したコンテナを構築する．

→ DockerToolboxがちょい違う

#### ・Provider例

| 名前   |
| ------ |
| Docker |
| LXC    |
| OpenVZ |

![コンテナ型仮想化](https://user-images.githubusercontent.com/42175286/60386394-3afbd080-9acf-11e9-96fd-321a88dbadc5.png)



## 01-02. 各仮想化のパフォーマンスの比較

### 起動速度の違い

ホスト型とハイパーバイザ型では，ハードウェア（CPU，メモリ，ハードディスク）とゲストOSを仮想化することが必要である．一方で，コンテナ型では，ハードウェアとゲストOSの仮想化は行わず，namespaceを用いてコンテナを構成するため，その分起動が速い．

![サーバ仮想化](https://user-images.githubusercontent.com/42175286/60386143-57e2d480-9acc-11e9-88b7-99a566346aba.png)



### 処理速度の違い

#### ・Overheadの小ささ

ゲストOS上のアプリを操作する場合，ホスト型とハイパーバイザ型では，ハードウェアやハイパーバイザーを経由する必要がある．この分だけ，時間（Overhead）を要する．一方で，コンテナ型では，各コンテナがホストOSとカーネルを共有するため，Overheadが小さい．

![仮想化](https://user-images.githubusercontent.com/42175286/60386143-57e2d480-9acc-11e9-88b7-99a566346aba.png)

#### ・Overheadの比較

sysbenchというベンチマークツールを用いて，CPU・メモリ・ファイルI/Oに着目し，物理マシン・コンテナ型仮想化（Docker）・ホスト型仮想化（VirtualBox）のパフォーマンスを比較．

![各仮想化の比較](https://user-images.githubusercontent.com/42175286/60386476-27049e80-9ad0-11e9-92d8-76eed8927392.png)

