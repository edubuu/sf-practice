public class TestDataFactory {
    public static List<Opportunity> createOpportunityRecords(Integer count, Boolean isInsert, Id accountId){
        List<Opportunity> oppsList = new List<Opportunity>();

        for(Integer i = 0; i < count; i++){
            oppsList.add(
                new Opportunity(
                    Name = 'Test Opportunity ' + i,
                    AccountId = accountId,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(i)
                )
            );
        }

        if(isInsert){
            insert oppsList;
        }

        return oppsList;
    }
}