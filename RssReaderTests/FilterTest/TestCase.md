#  FilterTests
テストケース一覧です。
## sortMainListを使って sortメソッドのテスト
1. **containRead = false** で **read = false**の記事のみ表示されているかどうか
1. **containRead = true** で　**read = true**の記事も表示されているかどうか
1. **sortTypeが.pubDate, orderByDesc == true**の時に日付降順になっているかどうか
1. sortTypeが.pubDate, orderByDesc == falseの時に日付昇順になっているかどうか
1. sortTypeが.rssFeedType, orderByDesc == trueの時にRssFeedTypeごとの日付降順になっているかどうか
1. sortTypeが.rssFeedType, orderByDesc == falseの時にRssFeedTypeごとの日付昇順になっているかどうか
## sortMainListのテスト
1. pubDateがpubDateAfterを過ぎたArticleがスキップされているかどうか

## sortStarListのテスト
1. isStarのみかどうか

## sourtLaterReadListのテスト
1. laterReadのみかどうか


