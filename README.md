## このサイトについて

このサイトは，[Read the Docs](https://sphinx-rtd-theme.readthedocs.io/en/stable/) ，AWS，CircleCI，Terraformを使用して作成したサイトです．

クラウドサービス利用による金銭的な理由から本サイトは廃止し，Mkdocsに移行しました．

- [移行先サイト](https://hiroki-it.github.io/tech-notebook-mkdocs/)
- [移行先リポジトリ](https://github.com/hiroki-it/tech-notebook-mkdocs)

## クラウドインフラ構成図

Terraformのソースコードは，[tech-notebook-terraform](https://github.com/hiroki-it/tech-notebook-terraform) で管理しております．

Terraformにつきまして，CircleCIとAWS STSを用いたCICDは構築しておらず，手動でapplyしております．

![tech-notebook_aws_design](https://raw.githubusercontent.com/hiroki-it/tech-notebook-images/master/images/tech-notebook_aws_design.png)

<br>
