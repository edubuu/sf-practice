@isTest
private class OpportunityTriggerHandlerTest {

    @isTest
    static void verifyCreditLimitFalse() {
        
        Account acc1 = TestDataFactory.createAccount('TestAccount', true);

        Credit_Limit__c cl1 = new Credit_Limit__c(Customer__c = acc1.Id, Max_Credit__c = 100, Used_Credit__c = 100);
        insert cl1;

        List<Opportunity> opps = TestDataFactory.createOpportunityRecords(1, true, acc1.Id);
        Test.startTest();
            opps[0].Amount = 1;
        	opps[0].StageName = 'Closed Won';
            try {
        		update opps[0];
        		System.assert(false, 'Debió lanzarse una excepción por crédito insuficiente, pero no ocurrió.');
   		 	} catch (DmlException e) {
        		System.assert(e.getMessage().contains('No hay suficiente crédito disponible.'), 'El mensaje de error no es el esperado.');
    		}
        Test.stopTest();

        List<Credit_Limit__c> creditRetrieved = [SELECT Max_Credit__c, Used_Credit__c FROM Credit_Limit__c WHERE Customer__c = :acc1.Id];
        System.assertEquals(1, creditRetrieved.size(), true);
        System.assertEquals(100, creditRetrieved[0].Used_Credit__c, true);
    }
    
    
    @isTest
    static void verifyCreditLimitTrue() {
        Account acc1 = TestDataFactory.createAccount('TestAccount', true);

        Credit_Limit__c cl1 = new Credit_Limit__c(Customer__c = acc1.Id, Max_Credit__c = 100, Used_Credit__c = 99);
        insert cl1;

        List<Opportunity> opps = TestDataFactory.createOpportunityRecords(1, true, acc1.Id);
        opps[0].Amount = 1;
        opps[0].StageName = 'Closed Won';
        Test.startTest();
            update opps[0];
        Test.stopTest();

        List<Credit_Limit__c> creditRetrieved = [SELECT Max_Credit__c, Used_Credit__c FROM Credit_Limit__c WHERE Customer__c = :acc1.Id];
        System.assertEquals(1, creditRetrieved.size(), true);
        System.assertEquals(100, creditRetrieved[0].Used_Credit__c, true);
    }
}