trigger TrgPointFromSupplyInformation on SuppliedInformation__c (after insert) {
	User u = [SELECT Id,Point__c FROM User WHERE Id = :UserInfo.getUserId()];
	if(u.Point__c == null) {
		u.Point__c = 10;
	} else {
		u.Point__c += 10;
	}
	update u;
}