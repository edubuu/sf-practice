public with sharing class OpportunityTriggerHandler {
    public static boolean isTriggerExecuted = false;

    public static void handleBeforeUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        if(!isTriggerExecuted){
            verifyCreditLimit(newMap, oldMap);
            isTriggerExecuted = true;
        }
    }
    public static void handleBeforeInsert(Map<Id, Opportunity> newMap){
        if (!isTriggerExecuted) {
            verifyCreditLimit(newMap, null);
            isTriggerExecuted = true;
        }
    }

    private static void verifyCreditLimit(Map<Id,Opportunity> newMap, Map<Id, Opportunity> oldMap){
        Set<Id> accToVerify = new Set<Id>();

        for(Opportunity o : newMap.values()){
            if(o.StageName == 'Closed Won' && (oldMap == null || oldMap.get(o.Id).StageName != 'Closed Won')){
                accToVerify.add(o.AccountId);
            }
        }

        Map<Id, Credit_Limit__c> creditLimits = new Map<Id, Credit_Limit__c>();

        for (Credit_Limit__c cl : [
            SELECT Id, Customer__c, Max_Credit__c, Used_Credit__c 
            FROM Credit_Limit__c 
            WHERE Customer__c IN :accToVerify
        ]) {
            creditLimits.put(cl.Customer__c, cl);
        }

        List<Credit_Limit__c> creditsToUpdate = new List<Credit_Limit__c>();
        for(Opportunity o : newMap.values()){
            Credit_Limit__c cl = creditLimits.get(o.AccountId);
            if(o.StageName == 'Closed Won' && (oldMap == null || oldMap.get(o.Id).StageName != 'Closed Won')){
                Decimal newValue = o.Amount + cl.Used_Credit__c;
                if(newValue > cl.Max_Credit__c){
                    o.addError('Not enough credit');
                }else{
                    cl.Used_Credit__c = newValue;
                    creditsToUpdate.add(cl);
                }
            }
        }

        if (!creditsToUpdate.isEmpty()) {
            update creditsToUpdate;
        }        
    }
}
