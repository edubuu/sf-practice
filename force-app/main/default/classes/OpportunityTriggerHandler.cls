public with sharing class OpportunityTriggerHandler {
    public static boolean isTriggerExecuted = false;

    public static void handleBeforeUpdate(List<Opportunity> oppsList){
        if(!isTriggerExecuted){
            verifyCreditLimit(oppsList);
            isTriggerExecuted = true;
        }
    }

    public static void handleBeforeInsert(List<Opportunity> oppsList){
        if(!isTriggerExecuted){
            verifyCreditLimit(oppsList);
            isTriggerExecuted = true;
        }
    }

    private static void verifyCreditLimit(List<Opportunity> oppsList){
        Set<Id> accToVerify = new Set<Id>();
        //Map<Id, Opportunity> oppsFiltered = new Map <Id,Opportunity>();
        List<Opportunity> oppsFiltered = new List<Opportunity>();
    
        for(Opportunity o : oppsList){
            if(o.StageName == 'Closed Won' && /*oldMap.get(o.Id).StageName != 'Closed Won' &&*/ o.AccountId != null){                
            	accToVerify.add(o.AccountId);
                oppsFiltered.add(o);
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
        
        for(Opportunity o : oppsFiltered){

            Credit_Limit__c cl = creditLimits.get(o.AccountId);

            if (cl == null) {
                o.addError('No credit limit record found for this account.');
                continue;
            }    

            Decimal oppAmount = o.Amount != null ? o.Amount : 0;
            Decimal usedCredit = cl.Used_Credit__c != null ? cl.Used_Credit__c : 0;
            Decimal maxCredit = cl.Max_Credit__c != null ? cl.Max_Credit__c : 0;

            Decimal newValue = oppAmount + usedCredit;

            if (newValue > maxCredit) {
                o.addError('No hay suficiente crédito disponible.');
            } else {
                cl.Used_Credit__c = newValue;
                creditsToUpdate.add(cl);
            }
        }

        if (!creditsToUpdate.isEmpty()) {
            update creditsToUpdate;
        }        
    }
}