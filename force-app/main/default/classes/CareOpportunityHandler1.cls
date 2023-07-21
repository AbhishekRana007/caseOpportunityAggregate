public with sharing class CareOpportunityHandler1 implements ITrigger{
    public void bulkBefore(){
        system.debug('--- bulkBefore is called');
    }

    public void bulkAfter(){
        //this will only run on afterUpdate
        if (trigger.isAfter && trigger.isUpdate){
            //This will fetch and map required data from Opportunity object of particular Care__c Record
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
        //this will only run on afterUpdate
        if (trigger.isAfter && trigger.isUpdate){
            //the method will update sum,max,min,avg in Care__c object
            CareOpportunityHelper1.CareUpdater();
        }
        system.debug('--- andFinally called');
    }

}