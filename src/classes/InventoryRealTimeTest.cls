@isTest
private class InventoryRealTimeTest {
	
	@isTest static void test_UpdateInventory() {
		
		Merchandise__c merchandise1 = AddMerchandise('Desktop', 599.99, 150);
		Merchandise__c merchandise2 = AddMerchandise('Server', 1999.99, 200);

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new InventoryRealTimeMock.UpdateInventoryResponse());
		InventoryRealTime.Inventory inventory = InventoryRealTime.UpdateInventory();
		Test.stopTest();

		//check if we have 2 products in inventory
		system.assertEquals(inventory.RealTimeInventory.size(), 2);

		//check if desktop was updated from 100 to 200
		merchandise1 = GetMerchandiseByName('Desktop');
		system.assertEquals(merchandise1.Quantity__c, inventory.RealTimeInventory[0].qty);
	}

	private static Merchandise__c AddMerchandise(String name, Decimal price, Integer qty){
		Merchandise__c merchandise = new Merchandise__c(Name = name, Price__c = price, Quantity__c = qty);
		insert merchandise;
		return merchandise;
	}

	private static Merchandise__c GetMerchandiseByName(String name){
		Merchandise__c merchandise = [SELECT Id, Name, Price__c, Quantity__c FROM Merchandise__c WHERE Name =: name];
		return merchandise;
	}
}