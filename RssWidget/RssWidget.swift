//
//  RssWidget.swift
//  RssWidget
//
//  Created by 若江照仁 on 2022/03/26.
//

import WidgetKit
import SwiftUI
import Nuke

struct Provider: TimelineProvider {
    var articles: [Article] = {
        let realm = RealmManager.realm
        let realmArticles = realm.objects(RealmArticle.self)
        var articleList = [Article]()
        for realmArticle in realmArticles {
            var article = Article(item: Item(title: realmArticle.title, pubDate: realmArticle.pubDate, link: realmArticle.link, guid: realmArticle.guid), rssFeedTitle: realmArticle.rssFeedTitle, rssFeedUrl: realmArticle.rssFeedUrl, rssFeedFaviconUrl: realmArticle.rssFeedFaviconUrl, tag: realmArticle.tag)
            article.isStar = realmArticle.isStar
            article.laterRead = realmArticle.laterRead
            article.read = realmArticle.read
            articleList.append(article)
        }
        return articleList
    }()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), article: articles.randomElement())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), article: articles.randomElement())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, article: articles.randomElement())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let article: Article?
}

struct RssWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack{
            Text("オススメ記事")
                .font(.headline)
                .frame(width: .infinity, height: 20, alignment: Alignment(horizontal: .leading, vertical: .center))
                .fixedSize(horizontal: true, vertical: true)
            HStack{
                LinkURLImageView(url: URL(string: entry.article!.rssFeedFaviconUrl)!,
                                             imageUrlString: entry.article!.rssFeedFaviconUrl,
                                             isSyncURLImage: true)
                .body.frame(width: 20, height: 20, alignment: Alignment(horizontal: .center, vertical: .center))
                Text(entry.article?.item.title ?? "No Item" )
                    .font(.body)
            }
            .padding()
        }
    }
}

@main
struct RssWidget: Widget {
    let kind: String = "RssWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RssWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct RssWidget_Previews: PreviewProvider {
    static var previews: some View {
        RssWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                article: Article(
                    item: Item(
                        title: "Swiftで・・・",
                        pubDate: nil,
                        link: "http://test",
                        guid: "abcde"
                    ),
                    rssFeedTitle: "Qiita",
                    rssFeedUrl: "test",
                    rssFeedFaviconUrl: "https://cdn.qiita.com/assets/favicons/public/production-c620d3e403342b1022967ba5e3db1aaa.ico",
                    tag: "tag")
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
