// Script for presentation

//Delete previous records:
List<SObject> recordsToDelete = new List<SObject>();
recordsToDelete.addAll([SELECT Id FROM Account WHERE AccountNumber = 'Presentation']);
recordsToDelete.addAll([SELECT Id FROM Task WHERE CallObject = 'Presentation']);
delete recordsToDelete;

// Setup records:
Account parentForFlowTest = new Account(Name = 'Parent with Rating - for Unit Test', Rating = 'Warm', Description = 'For presentation.', AccountNumber = 'Presentation');

insert new List<SObject>{parentForFlowTest};