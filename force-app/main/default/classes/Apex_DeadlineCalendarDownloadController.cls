public without sharing class Apex_DeadlineCalendarDownloadController {
    
    public FAFSA_Deadline__c FafsaDeadline {get;set;}
    public String FAFSA_DeadlineStr {get;set;}
    public integer DDDay{get;set;}
    public integer DDMonth{get;set;}
    public integer DDYear{get;set;}
    private final String statecode;
    public Apex_DeadlineCalendarDownloadController(){
        statecode = ApexPages.currentPage().getParameters().get('scode');
        if(statecode == null) statecode = 'Fed';
        FafsaDeadline = [select Deadline__c, Deadline_Date__c, Calendar_URL__c, Name, State__c,State_Abbreviated__c 
                         from FAFSA_Deadline__c where State_Abbreviated__c =: statecode ];
       // FAFSA_DeadlineDateStr = FafsaDeadline.Deadline_Date__c.format();
       // FAFSA_DeadlineDateStr = FAFSA_DeadlineDateStr.replace('/', '~');
      //  system.debug('FAFSA_DeadlineDateStr == ' + FAFSA_DeadlineDateStr);
        DDDay = FafsaDeadline.Deadline_Date__c.day();
        DDMonth = FafsaDeadline.Deadline_Date__c.month();
        DDYear = FafsaDeadline.Deadline_Date__c.year();
        FAFSA_DeadlineStr =  FafsaDeadline.Deadline__c.replace('\n','');
    }
}