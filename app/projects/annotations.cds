using CVPortfolioService as service from '../../srv/cv-service';

annotate service.Projects with @(
    UI.SelectionFields : [
        title,
        company,
        industry_ID,
        projectType_ID,
        startDate,
        endDate,
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Value : company,
        },
        {
            $Type : 'UI.DataField',
            Value : industry.name,
            Label : '{i18n>Industry}',
        },
        {
            $Type : 'UI.DataField',
            Value : projectType.name,
            Label : '{i18n>ProjectType}',
        },
        {
            $Type : 'UI.DataField',
            Value : role,
            Label : '{i18n>Role}',
        },
        {
            $Type : 'UI.DataField',
            Value : startDate,
        },
        {
            $Type : 'UI.DataField',
            Value : endDate,
        },
    ],
    UI.HeaderInfo : {
        TypeName : '{i18n>Project}',
        TypeNamePlural : '{i18n>Projects}',
        Title : {
            $Type : 'UI.DataField',
            Value : title,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : description,
        },
    },
);
annotate service.Projects with {
    projectType @(
        Common.ExternalID : projectType.code,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'ProjectTypes',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : projectType_ID,
                    ValueListProperty : 'ID',
                },
            ],
            Label : '{i18n>ProjectType}',
        },
        Common.ValueListWithFixedValues : true,
        Common.Label : '{i18n>ProjectType}',
)};

annotate service.ProjectTypes with {
    code @(
        Common.Text : name,
        Common.Text.@UI.TextArrangement : #TextOnly,
    )
};

annotate service.Projects with {
    industry @(
        Common.Label : '{i18n>Industry}',
        Common.ExternalID : industry.code,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Industries',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : industry_ID,
                    ValueListProperty : 'ID',
                },
            ],
            Label : '{i18n>Industry}',
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Industries with {
    code @(
        Common.Text : name,
        Common.Text.@UI.TextArrangement : #TextFirst,
)};

