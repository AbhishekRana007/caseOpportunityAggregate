public with sharing class CareOpportunityHandler1 implements ITrigger{
    public void bulkBefore(){
        system.debug('--- bulkBefore is called');
    }

    public void bulkAfter(){
        //This will fetch and map required data from Opportunity object of particular Care__c Record
        if (trigger.isAfter && trigger.isUpdate){
            CareOpportunityHelper1.SoqlFetcher(Trigger.new );
        }
        system.debug('--- bulkAfter is called');
    }

    public void beforeInsert(sObject so){
        system.debug('--- beforeInsert is called');
    }

    public void beforeUpdate(SObject oldSo, SObject so){
        system.debug('--- beforeUpdate is called');
    }

    public void beforeDelete(SObject so){
        system.debug('--- beforeDelete is called');
    }

    public void afterInsert(SObject so){
        system.debug('--- afterInsert is called');
    }

    public void afterUpdate(SObject oldSo, SObject so){

        system.debug('--- afterUpdate is called');
    }

    public void afterDelete(SObject so){
        system.debug('--- afterDelete is called');
    }

    public void andFinally(){
        //the method will update sum,max,min,avg in Care__c object
        if (trigger.isAfter && trigger.isUpdate){
            CareOpportunityHelper1.CareUpdater();
        }
        system.debug('--- andFinally called');
    }

}