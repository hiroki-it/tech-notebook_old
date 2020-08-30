# CQRS設計

## 01. CQRS設計：Command Query Responsibility Segregation（コマンドクエリ責務分離）

### CQRS設計とは

DBへのアクセス処理を書き込みと読み出しに分離する設計のこと．DDDに部分的に組み込むことができる．```N+１```問題にも，対処できる．

![DDDにCQRSを組み込む](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DDDにCQRSを組み込む.png)



### Command（書き込み）

具体的には，DBのレコードをCreate，Read，Deleteする処理を指す．ドメイン層を経由する必要があるため，取得したレコードから構成されるオブジェクトは，集約である．

1. リクエストは，アプリケーション層とDomain層を経由し，Infrastracture層の書き込み用RepositoryでDomainロジックを加味したSELECT文を作る．
2. SELECT文によって，書き込みに必要なレコードをDBから取得する．
3. レコードを格納した集約を構成し，これのレコードを更新する．
4. 集約を分解し，DBへ新しいレコードを書き込む．



### Query（読み出し）

具体的には，DBのレコードをReadする処理を指す．ドメイン層を経由する必要がないため，取得したレコードから構成されるオブジェクトは，集約ではなく，DTOである．

1. リクエストは，アプリケーション層を経由し（Domain層は経由しない），Infrastructure層の読み出し用のRepositoryでDomainロジックとは無関係のSELECT文を作る．
2. SELECT文によって，読み出しに必要なレコードをDBから取り出す．
3. レコードを格納したDTOを構成する．
4. DTOはアプリケーション層を経由し，レスポンスされる．