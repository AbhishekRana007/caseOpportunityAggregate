@isTest
public class CareOpportunityTester1{
    //single record test
    @istest
    public static void test1(){

        //Inserting Custom setting to Test full Factory
        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        //inserting care to link it to opportunity
        Care__c cc = new Care__c();
        cc.Name = 'Care1';
        insert cc;

        //inserting Single Opportunity and linking it to care
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'New Opportunity';
        newOpportunity.StageName = 'Prospecting';
        newOpportunity.Care__c = cc.id;
        newOpportunity.Amount = 452555;
        newOpportunity.CloseDate = Date.today().addDays(30);
        insert newOpportunity;

        //updating Opportunity to trigger the code
        Opportunity newOpportunitys = [Select name, id, StageName
                                       from Opportunity];
        newOpportunitys.StageName = 'Closed Won';
        update newOpportunitys;
        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care1'];

        //All the assertion of updated fields of care
        system.assertEquals(452555, NewCare.TotalOpportunityAmount__c);
        system.assertEquals(452555, NewCare.MinimumOpportunity__c);
        system.assertEquals(452555, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(452555, NewCare.TotalOpportunityAverage__c);
    }

    //bulk record test
    @istest
    public static void test2(){
        //Inserting Custom setting to Test full Factory
        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        //inserting care to link it to opportunity
        Care__c cc = new Care__c();
        cc.Name = 'Care2';
        insert cc;

        //inserting multiple Opportunity and linking it to care
        LIST<opportunity> B = new LIST<opportunity>();

        for (integer i = 0; i < 20; i++){
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'New Opportunity' + i;
            newOpportunity.StageName = 'Prospecting';
            newOpportunity.Care__c = cc.id;
            newOpportunity.Amount = 452555+i;
            newOpportunity.CloseDate = Date.today().addDays(30);
            B.ADD(newOpportunity);
        }

        insert B;

        //updating Opportunity to trigger the code
        list<Opportunity> newOpportunitys = [Select name, id, StageName
                                             from Opportunity];
        for (Opportunity OO : newOpportunitys){
            OO.StageName = 'Closed Won';
        }
        update newOpportunitys;

        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care2'];
        Decimal x = NewCare.TotalOpportunityAmount__c;

        //All the assertion of updated fields of care
        system.assertEquals(9051290, x);
        system.assertEquals(452555, NewCare.MinimumOpportunity__c);
        system.assertEquals(452574, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(452564.5, NewCare.TotalOpportunityAverage__c);
    }

    //exception handling in this updation does not meet required Updation Criteria.
    @istest
    public static void test3(){

        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        Care__c cc = new Care__c();
        cc.Name = 'Care3';
        insert cc;

        LIST<opportunity> B = new LIST<opportunity>();

        for (integer i = 0; i < 20; i++){
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'New Opportunity' + i;
            newOpportunity.StageName = 'Prospecting';
            newOpportunity.Care__c = cc.id;
            newOpportunity.Amount = 452555;
            newOpportunity.CloseDate = Date.today().addDays(30);
            B.ADD(newOpportunity);
        }

        insert B;


        list<Opportunity> newOpportunitys = [Select name, id, StageName
                                             from Opportunity];
        for (Opportunity OO : newOpportunitys){
            OO.StageName = 'Closed Lost';
        }
        update newOpportunitys;

        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care3'];
        system.assertEquals(null, NewCare.TotalOpportunityAmount__c);
        system.assertEquals(null, NewCare.MinimumOpportunity__c);
        system.assertEquals(null, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(null, NewCare.TotalOpportunityAverage__c);
    }

    //Exception handling for other DML operations
    @ISTEST
    public static void inserterDeleter(){

        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'New Opportunity';
        newOpportunity.StageName = 'Prospecting';
        newOpportunity.Amount = 45255;
        newOpportunity.CloseDate = Date.today().addDays(30);
        insert newOpportunity;
        list<Opportunity> Opps = [Select name, id
                                  from opportunity];
        delete Opps;
    }

}