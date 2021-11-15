using GeoService as my from '../srv/geo-service';

annotate my.CustomerProcesses with @(

  UI.LineItem: [ 
    {$Type: 'UI.DataField', Value: customerId},
    {$Type: 'UI.DataField', Value: customerName},
    {$Type: 'UI.DataField', Value: customerCondition_conditionId, Criticality:  customerCondition.criticality}, // using foreign key (generated by CAP)
    {$Type: 'UI.DataField', Value: status_statusId, Criticality: status.criticality }  
  ],

  UI.HeaderInfo: {
    Title: { Value: customerName },
    Description: { Value: customerCountry},
    TypeName:'{i18n>type_customer}', 
    TypeNamePlural:'{i18n>type_customer_plural}',
    TypeImageUrl: 'sap-icon://customer'
  },
  
  UI.Identification: [
    {$Type: 'UI.DataField', Value: processId},
    {$Type: 'UI.DataField', Value: backendEventTime},
  ],

  
);

annotate my.CustomerProcesses with {   
  processId @readonly @title : '{i18n>title_process_id}' @UI.HiddenFilter;
  customerId @readonly @title : '{i18n>title_customer_id}';
  customerName @readonly @title : '{i18n>title_customer_name}' ;
  customerPhone @readonly @title : '{i18n>title_phone_number}'  @UI.HiddenFilter;
  customerMail @readonly @title : '{i18n>title_e_mail}'  @UI.HiddenFilter;
  customerCity @readonly @title : '{i18n>title_city}'  @UI.HiddenFilter;
  customerCountry @readonly @title : '{i18n>title_country}'  @UI.HiddenFilter;
  customerLanguage @readonly @title : '{i18n>title_language}'  @UI.HiddenFilter;
  customerCondition @title : '{i18n>title_customer_condition}'	@Common.Text: customerCondition.name; // nav prop
  comment @title : '{i18n>title_comment}' @UI.HiddenFilter@UI.MultiLineText;
  status  @title : '{i18n>title_status}' @Common.Text: status.name; // nav prop
  backendUrl @readonly @title : '{i18n>title_backend_url}'  @UI.HiddenFilter @UI.MultiLineText; 
  backendEventTime @readonly @title : '{i18n>title_event_time}' @UI.HiddenFilter;
  backendEventType @readonly @title : '{i18n>title_event_type}'  @UI.HiddenFilter;
  backendEventSource @readonly @title : '{i18n>title_event_source}'  @UI.HiddenFilter;
};

annotate my.Conditions with @(
	cds.odata.valuelist,
	UI: {
    LineItem: [
      {Value: name}, // both properties are mix-in from cds.common.CodeList
      {Value: descr} 
		],
		HeaderInfo: {
			TypeName: '{i18n>type_condition}',
			TypeNamePlural: '{i18n>type_condition_plural}',
      Title: {Value: name },
      Description: {Value: name }
		},
    Identification: [name, descr]
	}	
){	
  conditionId	@title : '{i18n>condition_id}'  @UI.HiddenFilter @Common.Text: { Text: name, TextArrangement: #TextOnly };	
  name		@title : '{i18n>condition_name}' ; //overriding default title from cds.common.CodeList
  descr		@title : '{i18n>condition_description}' ;  
};

annotate my.Status with @(
	cds.odata.valuelist,
	UI: {
    LineItem: [
      {Value: name}, 
      {Value: descr} 
		],
		HeaderInfo: {
			TypeName: '{i18n>type_status}',
			TypeNamePlural: '{i18n>type_status_plural}',
      Title: {Value: name },
      Description: {Value: name }
		},
    Identification: [name, descr]
	}	
){	
  statusId	@title : '{i18n>status_id}'  @UI.HiddenFilter @Common.Text: { Text: name, TextArrangement: #TextOnly };	
  name		@title : '{i18n>status_name}' ;
  descr		@title : '{i18n>status_description}' ; 
};



using GeoService as service from '../srv/geo-service';


annotate service.CustomerProcesses with @(
	UI: {		
		SelectionFields: [ customerId, customerCondition_conditionId, status_statusId ], 

		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>header_facet_relations}', Target: '@UI.FieldGroup#BuPaHeader'},
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>facet_label_customer_details}', Target: '@UI.FieldGroup#BuPaInfo'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>facet_label_manage_relations}', Target: '@UI.FieldGroup#Relation'},
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>facet_label_technical_info}', Target: '@UI.FieldGroup#TechnicalData'}		
		],
		FieldGroup#BuPaHeader: {
			Data: [ {Value: status.name, Criticality: status.criticality} ]   
		},
		FieldGroup#BuPaInfo: {
			Data: [
				{Value: customerName},
				{Value: customerId},				
				{Value: customerCountry},
				{Value: customerCity},
				{Value: customerPhone},
				{Value: customerMail},
				{Value: customerLanguage},
				{Value: comment}
			]
		},
		FieldGroup#Relation: {
			Data: [
				{Value: customerCondition_conditionId, Criticality: customerCondition.criticality}, 
				{Value: status_statusId, Criticality: status.criticality}, // using foreign key in case of navigation
			]
		},
		FieldGroup#TechnicalData: {
			Data: [
        {Value: customerId},
				{Value: processId},
				{Value: backendEventTime},
				{Value: backendEventType},
				{Value: backendEventSource},
				{Value: backendUrl}
			]
		}
	}
);