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

    public static List<Account> createAccounts(String name, Boolean isInsert){
        List<Account> accsList = new List<Account>();

        for(Integer i = 0; i < count; i++){
            accsList.add(
                new Account(
                    Name = name
                )
            );
        }

        if (isInsert) {
            insert accsList;   
        }

        return accsList;
    }

    public static Account createAccount(Integer count, Boolean isInsert){
        Account acc = new Account(
            Name = 'Test Account ' + count
        );

        if (isInsert) {
            insert acc;
        }

        return acc;
    }

}