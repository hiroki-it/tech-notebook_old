# 勉強の方針

1. 必ず、実例として、それが扱われているのかを覚えること。
2. 必ず、言葉ではなく、イラストを用いて覚えること。
3. 必ず、知識の『点』と『点』を繋ぎ、『線』にしろ
4. 必ず、まとめることでインプットしているだけなので、口頭で説明してアプトプットしろ。
5. キタミ式で大枠をとらえて、過去問で肉付けしていく。



# 13-01. Malware の種類と特徴

### ◇ Malware の語源

『malicious（悪意のある）＋software（ソフトウェア）』



### ◇ Macroウイルス

Wordなどのワープロアプリや、Excelなどの表計算アプリに感染

![Macroウイルス](C:\Projects\summary_notes\SummaryNotes\Image\Macroウイルス.jpg)



### ◇ Worm

自己複製し、1つのコンピュータから、4つの経路（ネットワーク、メール、共有フォルダ、USB）を辿って、他のコンピュータに感染を広げていく。パソコンがグローバルIPで直接インターネットに接続していると感染しやすい。ワームを防ぐためには、パソコンにプライベートIPアドレスを設定し、NATやNAPTなどを介して、インターネットに接続させる必要がある。

**【具体例】**共有フォルダ経由での感染拡大

![Worm（共有フォルダ）](C:\Projects\summary_notes\SummaryNotes\Image\Worm（共有フォルダ）.jpg)



### ◇ トロイの木馬

**【具体例】**Google play で、過去にアプリとして忍び込んでいたトロイの木馬

![トロイの木馬](C:\Projects\summary_notes\SummaryNotes\Image\トロイの木馬.jpg)

感染方法がギリシャ神話上のトロイの木馬に似ていることに由来する。有用なプログラムであるように見せかけて、パソコン利用者に実行させることで感染。裏で不正な処理を行う。

※トロイの木馬はギリシャ神話に登場する。ギリシャ軍は難攻不落のトロイ城を陥落させるため、中に精鋭部隊を忍び込ませた木馬をトロイ城の近くに置いて帰った。戦利品だと勘違いしたトロイ軍は、城内に木馬を持ち帰った。夜中、木馬の中に隠れた精鋭部隊が自軍の兵士をトロイ城に引き入れ、城を制圧した。



### ◇ Spyware

パソコン利用者の個人情報を収集し、外部に送信する。

![スパイウェア](C:\Projects\summary_notes\SummaryNotes\Image\スパイウェア.png)

### ◇ Bot

あらかじめBot化させておいたパソコンを踏み台として、攻撃者の命令通りに動かす。

- **パソコンがボット化するまでのプロセス**

  ![ボット化のプロセス（パソコン）](C:\Projects\summary_notes\SummaryNotes\Image\ボット化のプロセス（パソコン）.jpg)

- **スマホがボット化するまでのプロセス**

  ![ボット化のプロセス（スマホ）](C:\Projects\summary_notes\SummaryNotes\Image\ボット化のプロセス（スマホ）.jpg)

- **Bot の使われ方**

  まず、攻撃対象のネットワーク内にあるパソコンをBot化させる。攻撃者は、Bot化したパソコンを踏み台としてサーバーを攻撃させるように、C&Cサーバーに命令を出す。

![C&Cサーバー](C:\Projects\summary_notes\SummaryNotes\Image\C&Cサーバー.png)



# 13-02. 不正アクセスと対策

### ◇ ソーシャルエンジニアリング

技術的な手法ではなく、人の弱みに付け込んでパスワードを取得し、アクセスする手法。



### ◇ 踏み台攻撃

対象のインターネット内のパソコンに攻撃プログラムを仕込んで置き、攻撃者からの命令でサーバを攻撃させる手法（※ボットを用いた攻撃など）



### ◇ パスワードリスト攻撃

漏洩したパスワードを用いて、正面から正々堂々とアクセスする手法。



### ◇ Brute-force 攻撃

Brute-forceは力ずくの意味。IDを固定して、パスワードを総当たりで試す手法。例えば、5桁数字のパスワードなら、9の5乗通りの組み合わせを試す。



### ◇ Reverse Brute-force 攻撃

パスワードを固定して、IDを総当たりで試す手法。



### ◇ SQL Injection

データベースのSQLクエリのパラメータとなる入力に、不正な文字列を入力して不正なSQLクエリを実行させ、データベースの情報を抜き取る手法。ただし、近年は減少傾向にある。

![SQLインジェクション](C:\Projects\summary_notes\SummaryNotes\Image\SQLインジェクション.jpg)

- **対策**

  データベースのSQLクエリのパラメータとなる入力では、SQLで特別な意味を持つ、『シングルクオーテーション』や『バックスラッシュ』を無効化させる。



### ◇ Back Door

例えば、Webサイトのカード決済画面やサーバに潜ませることによって、カード情報を第三者に送信する手法。

![バックドア](C:\Projects\summary_notes\SummaryNotes\Image\バックドア.png)



### ◇ Rainbow 攻撃

  ハッシュ化された暗号から、元のパスワードを解析する手法。



### ◇ DNS Cache Poisoning

キャッシュDNSサーバーがもつIPアドレスを偽のIPアドレスに変え、偽のWebサイトに強制的にアクセスさせる手法。

![DNSキャッシュポイズニング](C:\Projects\summary_notes\SummaryNotes\Image\DNSキャッシュポイズニング.gif)



### ◇ XSS：Cross Site Scripting

WebアプリケーションによるHTML出力のエスケープ処理の欠陥を悪用し，利用者のWebブラウザで悪意のあるスクリプトを実行させる 。

![Cross Cite Scripting](C:\Projects\summary_notes\SummaryNotes\Image\Cross Cite Scripting.png)

### ◇ Directory traversal

パス名を使ってファイルを指定し，管理者の意図していないファイルを不正に閲覧する。

![ディレクトリトラバーサル](C:\Projects\summary_notes\SummaryNotes\Image\ディレクトリトラバーサル.jpg)



# 13-03. セキュリティ技術の役割

### ◇ 盗聴（データの盗み取り）を防ぐ

『共通鍵暗号方式』や『公開鍵暗号方式』によって実現される。暗号アルゴリズムに基づく暗号方式を用いてデータを暗号化することによって、盗聴を防ぐ。

![盗聴_改竄_なりすまし](C:\Projects\summary_notes\SummaryNotes\Image\盗聴_改竄_なりすまし_1.png)

### ◇ 改竄（データの書き換え）を防ぐ

『ハッシュ関数』によって実現される。相手に送ったデータと相手が受け取ったデータが同じかどうかを確認することによって、改竄を防ぐ。

![盗聴_改竄_なりすまし](C:\Projects\summary_notes\SummaryNotes\Image\盗聴_改竄_なりすまし_2.png)

### ◇ なりすましを防ぐ

『デジタル署名』によって実現される。正しい相手であることを証明することによって、なりすましを防ぐ。

![盗聴_改竄_なりすまし](C:\Projects\summary_notes\SummaryNotes\Image\盗聴_改竄_なりすまし_3.png)



# 13-04. 暗号アルゴリズムの種類

次章における暗号方式の理論を実装するためのアルゴリズムを紹介していく。

### ◇ 共通鍵暗号アルゴリズム

- **DES 暗号：Data Encryption Standard**
- **AES 暗号：Advanced Encryption Standard**



### ◇ 公開鍵暗号アルゴリズム

- **RSA 暗号：Rivest-Shamir-Adleman cryptosystem**



# 13-05. 暗号アルゴリズムに基づく暗号方式

### ◇ 暗号方式の種類一覧

![暗号方式の種類](C:\Projects\summary_notes\SummaryNotes\Image\暗号方式の種類.png)



### ◇ 共通鍵暗号方式

送信者にあらかじめ秘密鍵を渡しておく。鍵の受け渡しを工夫しないと、共通鍵が傍受され悪用される可能性がある（**鍵配送問題**）。

**【具体例】**エクセルのファイルロック

**長所**：処理が速い

**短所**：鍵の配布が大変

![p437](C:\Projects\summary_notes\SummaryNotes\Image\p437.png)



### ◇ 公開鍵暗号方式 ⇒ 『受信者』に、秘密鍵による本人証明が必要

![公開鍵暗号方式](C:\Projects\summary_notes\SummaryNotes\Image\公開鍵暗号方式.png)

公開鍵暗号方式でも記載の通り、共通鍵暗号方式の鍵配送問題を解決すべく開発された。『RSA暗号』などによって実装される。送信者にあらかじめ公開鍵を渡しておく。公開鍵は暗号化しかできない。送信者は公開鍵で情報を暗号化する。自分はそれを秘密鍵で復号する。受信する場合、相手から公開鍵をもらう。

**長所**：鍵の配布が簡単

**短所**：処理が遅い

- **盗聴を防ぐことができる**

  受信者の公開鍵で暗号化した場合、受信者の秘密鍵でのみ復号可能。すなわち、第三者に復号（解読）されることはないと判断可能。



### ◇ ハイブリッド暗号方式 ⇒ 『受信者』に、秘密鍵による本人証明が必要

共通鍵暗号方式と公開鍵暗号方式を組み合わせた暗号方式。両方の方式の長所と短所を補う。

 ![ハイブリッド暗号](C:\Projects\summary_notes\SummaryNotes\Image\ハイブリッド暗号.png)



# 13-06. デジタル署名と公開鍵基盤

### ◇ デジタル署名 ⇒ 『送信者』に、秘密鍵による本人証明が必要

『公開鍵暗号方式とは逆の本人証明』と『ハッシュ関数』を利用したセキュリティ技術。『なりすまし』と『改竄』を防ぐことができる。

【送信者】

1. 平文をハッシュ化し、ダイジェストにする。
2. ダイジェストを秘密鍵（署名生成鍵）で暗号化し、暗号ダイジェスト（デジタル署名）を作成する。
3. 『平文』と『暗号ダイジェスト（デジタル署名）』の両方を送信

【受信者】

4. 『平文』と『暗号ダイジェスト（デジタル署名）』の両方を受信し、暗号ダイジェストを公開鍵（署名検証鍵）で復号し、ダイジェストにする。
5. 平文をハッシュ化し、ダイジェストにする。
6. 上記２つのダイジェストが同一なら、『なりすまし』と『改竄』が行われていないと判断

- **なりすましを防ぐことができる**

  特定の秘密鍵を持つのは、特定の送信者だけ。したがって、確かに送信者によって暗号化されたものだと判断可能。

- **改竄を防ぐことができる**

  送信者から送られた『平文』と『暗号ダイジェスト』のどちらかが、通信の途中で改竄された場合、これらのダイジェストが同じになることは確率的にありえない。したがって、確かに改竄されていないと判断可能。

![デジタル署名](C:\Projects\summary_notes\SummaryNotes\Image\デジタル署名.png)



- **ハッシュ関数**

  何かのデータを入力すると、規則性のない一定の桁数の値を出力する演算手法。

![ハッシュ関数](C:\Projects\summary_notes\SummaryNotes\Image\ハッシュ関数.png)



### ◇ 公開鍵暗号方式を組み込んだデジタル署名

『なりすまし』と『改竄』を防げるデジタル署名に、『盗聴』を防げる公開鍵暗号方式を組み込んだセキュリティ技術。

![デジタル署名と暗号化](C:\Projects\summary_notes\SummaryNotes\Image\デジタル署名と暗号化.png)



### ◇ PKI：Public Key Infrastructure（公開鍵基盤）

デジタル署名を用いたセキュリティインフラ技術

1. 送信者は、公開鍵と秘密鍵を作り、認証局に公開鍵とデジタル証明書を提出。

2. 認証局は、デジタル署名の入ったデジタル証明書を発行。

   ![デジタル証明書によるなりすまし防止1,2](C:\Projects\summary_notes\SummaryNotes\Image\デジタル証明書によるなりすまし防止-1,2.png)

3. 送信者は、受信者にメール、デジタル署名、デジタル証明書を送信。

4. よくわからない。

![デジタル証明書によるなりすまし防止3,4](C:\Projects\summary_notes\SummaryNotes\Image\デジタル証明書によるなりすまし防止-3,4.png)



# 13-07.  パケット交換方式におけるセキュリティ技術

### ◇ TCP/IP階層モデルとOSI参照モデルの対応関係（再掲）

![OSI参照モデルとTCPIPとヘッダ情報追加の位置.png](C:\Projects\summary_notes\SummaryNotes\Image\OSI参照モデルとTCPIPとヘッダ情報追加の位置.jpg)



### ◇ OSI参照モデルにおける各プロトコルの分類（再掲）

![セキュアプロトコル](C:\Projects\summary_notes\SummaryNotes\Image\セキュアプロトコル.jpg)



### ◇ データへのヘッダ情報追加とカプセル化（再掲）

![パケットの構造](C:\Projects\summary_notes\SummaryNotes\Image\パケットの構造.jpg)



# 13-08. アプリケーションデータのセキュリティ技術

### ◇ **S/MIME：Secure MIME**

公開鍵暗号方式に基づく技術。アプリにおいて、デジタル署名による認証の機能を、メールに追加することができる。

 ![S_MIME](C:\Projects\summary_notes\SummaryNotes\Image\S_MIME.png)



# 13-09. アプリケーション層のセキュアプロトコル

### ◇ SSH：Secure Shell

公開鍵暗号方式に基づくセキュアプロトコル。アプリケーション層で、データの暗号化を担う。暗号方式と認証方式の技術を用いて、リモートコンピュータとの通信を安全に行う。公開鍵暗号方式が用いられる。例えば、クライアント側SSHソフトには、『OpenSSH』、『Apache MINA/SSHD』があり、またサーバ側SSHソフトには、お『OpenSSH』、『TeraTerm』、『Putty』がある。

![ssh接続](C:\Projects\summary_notes\SummaryNotes\Image\ssh接続.png)



# 13-10. トランスポート層のセキュアプロトコル

### ◇ SSL/TLS

ハイブリッド暗号方式に基づくセキュアプロトコル。トランスポート層で、パケットのヘッダ情報の暗号化を担う。インターネットVPNの実現のために用いられる。

![SSLによるインターネットVPN](C:\Projects\summary_notes\SummaryNotes\Image\SSLによるインターネットVPN.jpg)

**【具体例】**

Chromeでは、SSL接続に不備があると、以下のような警告が表示される。

![SSL接続に不備がある場合の警告](C:\Projects\summary_notes\SummaryNotes\Image\SSL接続に不備がある場合の警告.jpg)



# 13-11. ネットワーク層のセキュアプロトコル

### ◇ IPsec

共通鍵暗号方式に基づくセキュアプロトコル。ネットワーク層で、パケットのヘッダ情報の暗号化を担う。インターネットVPNの実現のために用いられる。盗聴を防ぐことができる。

![IPsecによるインターネットVPN](C:\Projects\summary_notes\SummaryNotes\Image\IPsecによるインターネットVPN.jpg)

- **IPsecによるパケットのカプセル化**

![IPsecによるカプセル化](C:\Projects\summary_notes\SummaryNotes\Image\IPsecによるカプセル化.jpg)



### ◇ VPN：Virtual Private Network（仮想プライベートネットワーク）

異なるネットワーク間で安全な通信を行うための仕組み。IPsecやSSL/TLSによって実現される。

![VPN（ネットワーク間）](C:\Projects\summary_notes\SummaryNotes\Image\VPN（ネットワーク間）.png)



# 13-12. その他のセキュリティ技術

### ◇ メール受信におけるセキュリティ

- **OP25B（Outbound Port 25 Blocking）**
- **SPF（Sender Policy Framework）**



### ◇ パスワードの保存方法

平文で保存しておくと、流出した時に勝手に使用されてしまうため、ハッシュ値で保存するべきである。

![ハッシュ値で保存](C:\Projects\summary_notes\SummaryNotes\Image\ハッシュ値で保存.png)



### ◇ 生体認証

![生体認証-1](C:\Projects\summary_notes\SummaryNotes\Image\生体認証-1.png)



![生体認証-2](C:\Projects\summary_notes\SummaryNotes\Image\生体認証-2.png)



### ◇ Web beacon

webページに、サーバに対してHTTPリクエストを送信するプログラムを設置し、送信されたリクエストを集計するアクセス解析方法。例えば、1x1の小さなGif「画像」などを設置する。



### ◇ Penetration テスト

既知のサイバー攻撃を意図的に行い、システムの脆弱性を確認するテストのこと。

**【具体例】**株式会社LACによるPenetration テストサービス

![ペネトレーションテスト](C:\Projects\summary_notes\SummaryNotes\Image\ペネトレーションテスト.png)



# 13-13. セキュリティガイドライン

### ◇ セキュリティマネジメントの３要素

![情報セキュリティ３要素](C:\Projects\summary_notes\SummaryNotes\Image\情報セキュリティ３要素.jpg)

- **Confidentiality（機密性）**

  許可された人のみが情報にアクセスできるようにすること。

- **Integrity（完全性）**

  情報が書き換えられることがないこと。

- **Availability（可用性）**

  許可された人が必要な時に必要な情報を利用できること。

  

### ◇ セキュリティポリシー



### ◇ プライバシーマーク 



### ◇ サイバーセキュリティ経営ガイドライン



