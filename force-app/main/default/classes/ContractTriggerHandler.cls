public with sharing class ContractTriggerHandler {

    public static void handleAfterInsert(List<Contract> lContrato, Map<Id,Contract> mContrato){
        ContratoTestCallout.bulkifyCallout(mContrato.keySet());
    }
}