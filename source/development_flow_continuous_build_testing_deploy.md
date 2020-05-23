# 継続的な ビルド／テスト／デプロイ の流れ

## 01. CI/CDの流れ

### CI：Continuous Integration，CD：Continuous Deliveryとは

Code > Build > Test > Code > Build > Test ・・・ のサイクルを高速に回して，システムの品質を継続的に担保することを，『Continuous Integration』という．また，変更内容をステージング環境などに自動的に反映し，継続的にリリースすることを，『Continuous Delivery』という．

![cicdツールの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/cicdツールの種類.png)



## 02. CIツールによるビルドフェイズとテストフェイズの自動実行

### CircleCI

#### ・PHPUnitの自動実行

1. テストクラスを実装したうえで，新機能を設計実装する．

2. リポジトリへPushすると，CIツールがGituHubからブランチの状態を取得する．

3. CIツールによって，DockerHubから取得したDockerfileのビルド，PHPUnitなどが自動実行される．

4. 結果を通知することも可能．

![継続的インテグレーション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/継続的インテグレーション.png)

#### ・PHPStanの自動実行

#### ・Tips

ホストOS側で，以下のコマンドを実行する．

1. 設定ファイル（```config.yml```）の文法を検証

```bash
circleci config validate

# 以下の文章が表示されれば問題ない．
# Config file at .circleci/config.yml is valid.
```

2. ローカルでのビルド

```bash
circleci build .circleci/config.yml
```



## 03. CDツールによるデプロイフェイズの自動実行

### Capistrano

#### ・クラウドデプロイサーバにおけるデプロイ

1. 自身のパソコンからクラウドデプロイサーバにリモート接続する．
2. クラウドデプロイサーバの自動デプロイツール（例：Capistrano）が，クラウドデプロイサーバからクラウドWebサーバにリモート接続する．
3. 自動デプロイツールが，クラウドWebサーバのGitを操作し，```pull```あるいは```clone```を実行する．その結果，GitHubからクラウドデプロイサーバに指定のブランチの状態が取り込まれる．

![デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/デプロイ.png)



### AWS CodeDeploy

#### ・デプロイ

![CodeDeployを用いた自動デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CodeDeployを用いた自動デプロイ.png)

