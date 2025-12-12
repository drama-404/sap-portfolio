using CVPortfolioService as service from '../../srv/cv-service';
annotate service.Projects with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'company',
                Value : company,
            },
            {
                $Type : 'UI.DataField',
                Label : 'industry',
                Value : industry,
            },
            {
                $Type : 'UI.DataField',
                Label : 'projectType',
                Value : projectType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'startDate',
                Value : startDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'endDate',
                Value : endDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'goal',
                Value : goal,
            },
            {
                $Type : 'UI.DataField',
                Label : 'role',
                Value : role,
            },
            {
                $Type : 'UI.DataField',
                Label : 'outcomes',
                Value : outcomes,
            },
            {
                $Type : 'UI.DataField',
                Label : 'durationMonths',
                Value : durationMonths,
            },
            {
                $Type : 'UI.DataField',
                Label : 'projectStatus',
                Value : projectStatus,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'company',
            Value : company,
        },
        {
            $Type : 'UI.DataField',
            Label : 'industry',
            Value : industry,
        },
        {
            $Type : 'UI.DataField',
            Label : 'projectType',
            Value : projectType,
        },
        {
            $Type : 'UI.DataField',
            Label : 'startDate',
            Value : startDate,
        },
    ],
);

