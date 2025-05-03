public with sharing class LeadTriggerHandler {

    public static Boolean isTriggerExecuted = false;

    public static void handleAfterUpdate(Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        if(!isTriggerExecuted){
            updateLeadWhenScoreChanges(newMap, oldMap); 
            isTriggerExecuted = true;
        }    
    }

    public static void handleAfterInsert(Map<Id, Lead> newMap) {
        if(!isTriggerExecuted){
            updateLeadWhenScoreChanges(newMap, null);
            isTriggerExecuted = true;
        }
        
    }

    private static void updateLeadWhenScoreChanges(Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        List<Database.LeadConvert> leadsToUpdate = new List<Database.LeadConvert>();

        for (Lead lead : newMap.values()) {
            if (oldMap == null || lead.Score__c != oldMap.get(lead.Id).Score__c) {
                if (lead.Score__c != null && lead.Score__c > 80) {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(lead.Id);
                    lc.setConvertedStatus('Qualified');

                    leadsToUpdate.add(lc);
                }
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            Database.convertLead(leadsToUpdate, false);
        }
    }
}