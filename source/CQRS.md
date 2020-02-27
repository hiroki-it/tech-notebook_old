# CQRS

## 01-01. CQRS：Command Query Responsibility Segregation（コマンドクエリ責務分離）

DBへのアクセス処理を書き込みと読み出しに分離する設計モデルのこと．DDDに部分的に組み込むことができる．```N+１```問題にも，対処できる．

![DDDにCQRSを組み込む](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/DDDにCQRSを組み込む.png)



### :pushpin: Command（書き込み）

具体的には，DBのデータをCreate，Read，Deleteする処理を指す．ドメイン層を経由する必要があるため，取得したデータから構成されるオブジェクトは，集約である．

1. リクエストは，アプリケーション層とDomain層を経由し，Infrastracture層の書き込み用RepositoryでDomainロジックを加味したSELECT文を作る．
2. SELECT文によって，書き込みに必要なデータをDBから取得する．
3. データを格納した集約を構成し，これのデータを更新する．
4. 集約を分解し，DBへ新しいデータを書き込む．



### :pushpin: Query（読み出し）

具体的には，DBのデータReadする処理を指す．ドメイン層を経由する必要がないため，取得したデータから構成されるオブジェクトは，集約ではなく，DTOである．

1. リクエストは，アプリケーション層を経由し（Domain層は経由しない），Infrastructure層の読み出し用のRepositoryでDomainロジックとは無関係のSELECT文を作る．
2. SELECT文によって，読み出しに必要なデータをDBから取り出す．
3. データを格納したDTOを構成する．
4. DTOはアプリケーション層を経由し，レスポンスされる．