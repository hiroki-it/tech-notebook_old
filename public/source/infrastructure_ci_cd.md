# CI & CD

## 01. CICDパイプライン

#### ・CICDパイプラインとは

Commitから本番環境へのDeployまでのプロセスを『継続的に』行うことを，CI：Continuous Integration』という．また，変更内容をステージング環境などに自動的に反映し，『継続的に』リリースすることを，CD：Continuous Deliveryという．

![CICDパイプライン](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/CICDパイプライン.png)

####  ・自動化できるプロセスとできないプロセス

| プロセス                     | 自動化の可否 | 説明                                             |
| ---------------------------- | ------------ | ------------------------------------------------ |
| Build                        | 〇           | CI/CDツールとIaCツールで自動化可能               |
| Unitテスト，Functionalテスト | 〇           | CI/CDツールとPHPUnitで自動化可能．               |
| Integrationテスト            | ✕            | テスト仕様書を作成し，動作を確認する必要がある． |
| Review                       | ✕            | GitHub上でレビューする必要がある．               |
| ステージング環境へのデプロイ | 〇           | CI/CDツールで自動化可能．                        |
| 本番環境へのデプロイ         | 〇           | CI/CDツールで自動化可能．                        |
