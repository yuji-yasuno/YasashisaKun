YasashisaKun
============

#やさしさくん

##概要
やさしさくんはより良い街づくりを市民の手で行っていくための支援アプリです。アプリを通して市民と行政、さらには地域の商業施設等が気軽に繋がることができます。繋がるために**情報共有**をキーポイントとします。
次はユースケースの一部です。

市民
 * 街の様子（施設の破損）等を行政へ報告
 * コミュニティ等に対して情報共有または検索
 * 獲得したポイントで商品に交換（例えば）※共有するとポイントがたまる仕組みです

行政
 * 市民、商業施設に対して手続き等の案内を行う
 * 市民からの報告を受け取り対策を行う

商業施設等
 * 市民へお得な情報を配信し広告等を行う
 * コミュニティでお客様と直接会話し顧客管理を行う

##スクリーンショット
###ホーム画面
<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0025.PNG" alt="ホーム画面" style="width: 100%; height: auto;"/>
ホーム画面ではコミュニティと履歴の2つのメニューを用意しています。

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0026.PNG" alt="クイックメニュー" style="width: 100%; height: auto;"/>
素早くメニューにアクセスしてもらうためにクイックメニューを用意してあります。
クイックメニューでは「ホーム画面」、「地図（情報提供のデータ）」、「情報提供（レコードを作成）」に素早くアクセスできます。

###コミュニティ選択及びコミュニティ画面 ※Chatter
<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0027.PNG" alt="コミュニティ選択" style="width: 100%; height: auto;"/>
コミュニティを選択する事ができます。
salesforceの組織で作成されたChatter Groupがここに反映されます。

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0028.PNG" alt="コミュニティでの会話" style="width: 100%; height: auto;"/>
ここでポストしたりコメントをしたりできます。

###情報共有画面
<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0030.PNG" alt="" style="width: 100%; height: auto;"/>
情報共有します。
写真と一緒に共有する事ができます。
また、自動で位置情報を取得し逆ジオコーディングしているため住所は入力不要です。
自動で住所も登録してくれます。

###情報共有マップ
<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0031.PNG" alt="情報共有マップ" style="width: 100%; height: auto;"/>
前の情報共有画面で登録したデータはマップで表示されます。
クイックメニューのピンアイコンをタップするとこの画面を表示できます。

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0037.PNG" alt="情報共有詳細" style="width: 100%; height: auto;"/>
google mapのInfo Windowをタップすると詳細情報を表示します。

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0034.PNG" alt="フィルタリング1" style="width: 100%; height: auto;"/>

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0035.PNG" alt="フィルタリング2" style="width: 100%; height: auto;"/>

<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0036.PNG" alt="フィルタリング3" style="width: 100%; height: auto;"/>
このように登録された情報の種類でフィルタリングをかけることもできます。

###履歴
<img src="https://dl.dropboxusercontent.com/u/37986965/YasashisaKun/IMG_0029.PNG" alt="履歴" style="width: 100%; height: auto;"/>
情報共有は履歴として残ります。
また情報共有をしたりコミュニティでの会話に積極的に参加するとポイントを獲得できます。
このポイントを利用して商品交換などのプログラムを取り入れても面白いと思います。

##コードに関して
Mobileフォルダにモバイルアプリのコードがあります。
CocoaPodsを利用してライブラリを追加しておりますので、プロジェクト開く際は次をクリックしてください。
YasashisaKun/Mobile/Yasashisa/Yasashisa.xcworkspace	

Salesforceフォルダ中にsalesforce組織にデプロイしてあるコードがあります。
主にポイント計算のロジックが入っています。
