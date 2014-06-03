trigger TrgPointFromComment on FeedComment (after insert) {
	User u = [SELECT Id,Point__c FROM User WHERE Id = :UserInfo.getUserId()];
	if(u.Point__c == null) {
		u.Point__c = 1;
	} else {
		u.Point__c += 1;
	}
	update u;

	FeedComment comment = Trigger.new[0];
	FeedItem feed = [SELECT CreatedById,Id FROM FeedItem WHERE Id = :comment.FeedItemId];
	User postUser = [SELECT Id,Point__c FROM User WHERE Id = :feed.CreatedById];
	if(postUser.Id != u.Id) {
		if(postUser.Point__c == null) {
			postUser.Point__c = 1;
		} else {
			postUser.Point__c += 1;
		}
		update postUser;
	}
}