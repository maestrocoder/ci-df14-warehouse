public class InventoryRealTimeMock {
	public class UpdateInventoryResponse implements HttpCalloutMock{
		 public HTTPResponse respond(HTTPRequest req) {
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            InventoryRealTime.Inventory inventory = new InventoryRealTime.Inventory();
            inventory.RealTimeInventory = new  InventoryRealTime.Merchandise[]{
            	new InventoryRealTime.Merchandise('Desktop', 599.99, 200),
            	new InventoryRealTime.Merchandise('Server', 1999.99, 300)
            };
            String responseJSON = JSON.serialize(inventory);
            res.setBody(responseJSON);
            res.setStatusCode(200);
            return res;
        }
	}
}