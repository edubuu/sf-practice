public without sharing class BatchCleanDuplicateContacts implements Database.Batchable<sObject>, Database.Stateful{

    Map<String,Id> mapRecentContact = new Map<String,Id>();
    Set<Id> idsToDelete = new Set<Id>();


    public Database.QueryLocator start(Database.BatchableContext BC){

        List<AggregateResult> duplicatedEmailResults = [SELECT Email FROM Contact WHERE Email != null GROUP BY Email HAVING COUNT(Id) > 1];

        Set<String> duplicatedEmails = new Set<String>();

        for (AggregateResult ar : duplicatedEmailResults) {
            duplicatedEmails.add((String) ar.get('Email'));
        }

        return Database.getQueryLocator([SELECT Id, Email FROM Contact WHERE Email IN :duplicatedEmails ORDER BY Email, CreatedDate DESC]);
    }


    public void execute(Database.BatchableContext BC, List<Contact> scope){
                
        for(Contact c: scope){
            String normalizedEmail = c.Email.trim().toLowerCase();
            if(!mapRecentContact.containsKey(normalizedEmail)){
                mapRecentContact.put(normalizedEmail,c.Id);
            }else{
                idsToDelete.add(c.Id);
            }
        }
    }

    public void finish(Database.BatchableContext BC){
        try{
            if(idsToDelete.size() > 0){
                List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE Id IN :idsToDelete];
                delete contactsToDelete;
            }
        }catch(Exception e){
          System.debug('Error on delete duplicated Contacts: ' + e.getMessage());
        }
    }
}