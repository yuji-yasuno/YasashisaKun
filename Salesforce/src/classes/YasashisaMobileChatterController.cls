public with sharing class YasashisaMobileChatterController {
	public String entityId { get; set; }
	public YasashisaMobileChatterController() {
		this.entityId = ApexPages.currentPage().getParameters().get('entityId');
	}
}