global with sharing class InventoryRealTime {

	webservice static Integer WS_UpdateInventory()
	{
		Inventory inventory = UpdateInventory();
		if(inventory != null && inventory.RealTimeInventory != null) {
			return inventory.RealTimeInventory.size();
		}
		return 0;
	}

	public static Inventory UpdateInventory()
	{
		HttpRequest req = new HttpRequest();
		String endpoint = 'https://ci-df14-warehouse.firebaseio.com/Inventory.json';
		req.setEndpoint(endpoint);
	    req.setMethod('GET');
	    Http h = new Http();
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 200){
        	if(res.getBody() != null && res.getBody() != '')
        	{
	        	InventoryRealTime.Inventory inventory = (InventoryRealTime.Inventory)JSON.deserialize(res.getBody(), InventoryRealTime.Inventory.class);
	        	system.debug('inventory : ' + inventory);
	        	if(inventory!=null) {
	        		List<Merchandise__c> merchandises = [SELECT Id, Name, Price__c, Quantity__c FROM Merchandise__c];
	        		for(Merchandise__c merchandise : merchandises) {
	        			for(Merchandise realTimeInventoryMerchanise : inventory.RealTimeInventory) {
	        				system.debug('name :'+realTimeInventoryMerchanise.name);
	        				if(merchandise.Name == realTimeInventoryMerchanise.name) {
	        					merchandise.Price__c = realTimeInventoryMerchanise.price;
	        					merchandise.Quantity__c = realTimeInventoryMerchanise.qty;
	        					
	        				}
	        			}
	        		}
	        		update merchandises;
	        		return inventory;
	        	}
			}
        }
        return null;
	}

	public class Inventory
	{
		public Merchandise[] RealTimeInventory;
	}

	public class Merchandise
	{
		public String name;
		public Decimal price;
		public Integer qty;
		public Merchandise(String name, Decimal price, Integer qty){
			this.name = name;
			this.price = price;
			this.qty = qty;
		}
	}
}