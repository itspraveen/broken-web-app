param appServiceName string
var appServicePlanName = appServiceName
var location = resourceGroup().location
var webAppUrl = 'https://${webApp.properties.defaultHostName}'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  kind: 'windows'
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  kind: 'windows'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appServiceName}-insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource appInsightsWebTestSlowResponse1 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${appServiceName}-webtest-slowresponse-1'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '${appServiceName}-webtest-slowresponse-1'
    Name: '${appServiceName}-webtest-slowresponse-1'
    Enabled: true
    Frequency: 300
    Timeout: 30
    Kind: 'standard'
    Locations: [
      {
        Id: 'us-fl-mia-edge'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'us-ca-sjc-azr'
      }
      {
        Id: 'emea-gb-db3-azr'
      }
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    RetryEnabled: true
    Request: {
      RequestUrl: '${webAppUrl}/Scenarios/SlowResponse/SlowResponse1Actual.aspx'
    }
    ValidationRules: {
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 100
    }
  }
}

resource appInsightsWebTestSlowResponse2 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${appServiceName}-webtest-slowresponse-2'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '${appServiceName}-webtest-slowresponse-2'
    Name: '${appServiceName}-webtest-slowresponse-2'
    Enabled: true
    Frequency: 300
    Timeout: 30
    Kind: 'standard'
    Locations: [
      {
        Id: 'us-fl-mia-edge'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'us-ca-sjc-azr'
      }
      {
        Id: 'emea-gb-db3-azr'
      }
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    RetryEnabled: true
    Request: {
      RequestUrl: '${webAppUrl}/Scenarios/SlowResponse/SlowResponse2Actual.aspx'
    }
    ValidationRules: {
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 100
    }
  }
}

resource appInsightsWebTestSlowResponse3 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${appServiceName}-webtest-slowresponse-3'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '${appServiceName}-webtest-slowresponse-3'
    Name: '${appServiceName}-webtest-slowresponse-3'
    Enabled: true
    Frequency: 300
    Timeout: 30
    Kind: 'standard'
    Locations: [
      {
        Id: 'us-fl-mia-edge'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'us-ca-sjc-azr'
      }
      {
        Id: 'emea-gb-db3-azr'
      }
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    RetryEnabled: true
    Request: {
      RequestUrl: '${webAppUrl}/Scenarios/SlowResponse/SlowResponse3Actual.aspx'
    }
    ValidationRules: {
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 100
    }
  }
} 
