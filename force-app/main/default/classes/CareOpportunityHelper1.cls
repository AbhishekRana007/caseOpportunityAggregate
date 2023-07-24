public with sharing class CareOpportunityHelper1{
    //this will store soql data (max,min,avg,sum)
    private static List<AggregateResult> aggregateResults;
    //this will store id of the aggregated Opportunity CareId
    private static set<id> ids = new set<id>();
    //it will store id of Care as key and Aggregate field as value
    private static map<id, AggregateResult> Aggregatemap = new Map<id, AggregateResult>();
    public static void SoqlFetcher(list<Opportunity> opportunityList){

        for (Opportunity acc : opportunityList){

            //this will store only id of care that have been triggerd
            if (acc.Care__c != null){
                ids.add(acc.Care__c);
            }
        }

        //this will only  fetch record of those opportunity and aggregate it on amount  which has been triggred
        aggregateResults = [select sum(amount)sum, avg(amount)avg, max(amount)max, min(amount)min, Care__c
                            from Opportunity
                            where Care__c in:ids and StageName = 'Closed Won'
                            group by Care__c];

        //it will not call function mapper if list is empty
        if (!aggregateResults.isEmpty()){


            Mapper();
        }
    }

    //the function will map CareId and ITS related aggregate result
    public static void Mapper(){

        for (AggregateResult result : aggregateResults){
            ID CareId = (Id) result.get('Care__c');
            Aggregatemap.put(CareId, result);
        }
    }

    //updation will ocuure in this
    public static void CareUpdater(){

        //it will only fetch care records that is needed
        if (!Aggregatemap.isEmpty()){
            List<Care__c> CareUpdater = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                                         from Care__c
                                         where id in:ids];

            //assignment of max,min,avg,sum is occured here
            for (Care__c accs : CareUpdater){
                aggregateResult OneAggregate = Aggregatemap.get(accs.id);
                accs.TotalOpportunityAmount__c = (Decimal) OneAggregate.get('sum');
                accs.TotalOpportunityAverage__c = (Decimal) OneAggregate.get('avg');
                accs.MinimumOpportunity__c = (Decimal) OneAggregate.get('min');
                accs.MaxOpportunityAmount__c = (Decimal) OneAggregate.get('max');
            }

            // system.debug(acc[0].TotalOpportunityAmount__c);
            if (!CareUpdater.isEmpty()){
                Database.SaveResult[] updateResults = Database.update (CareUpdater, false);

                // Process the update results
                for (Database.SaveResult sr : updateResults){
                    if (sr.isSuccess()){
                        // Record updated successfully
                    } else{
                        for (Database.Error err : sr.getErrors()){
                            // Handle the errors
                            System.debug('Error Message: ' + err.getMessage());
                            System.debug('Status Code: ' + err.getStatusCode());
                        }
                    }
                }

            }
        }
    }

}