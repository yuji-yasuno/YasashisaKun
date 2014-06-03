trigger TrgPostSuppliedInformation on SuppliedInformation__c (after insert) {
	List<FeedItem> feeds = new List<FeedItem>();
	for (SuppliedInformation__c so : Trigger.new) {
		FeedItem feed = new FeedItem();
		feed.Body = UserInfo.getUserName() + 'さんが情報を共有しました。';
		feed.Type = 'LinkPost';
		feed.LinkUrl = '/' + so.Id;
		feed.Title = so.Name;
		feed.ParentId = so.Id;
		feeds.add(feed);
	}
	if(feeds.size() > 0) Database.insert(feeds, false);
}