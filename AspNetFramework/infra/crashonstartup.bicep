param appServiceName string
param appServicePlanName string
param logAnalyticsName string

var location = resourceGroup().location
var appInsightsName = '${appServiceName}-insights'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName
}

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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  kind: 'windows'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPINSIGHTS_PROFILERFEATURE_VERSION'
          value: '1.0.0'
        }
        {
          name: 'APPINSIGHTS_SNAPSHOTFEATURE_VERSION'
          value: '1.0.0'
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'DiagnosticServices_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_PreemptSdk'
          value: 'disabled'
        }
        {
          name: 'WEBAPP_CRASH_ON_STARTUP'
          value: 'true'
        }
      ]
    }
  }
}

resource appInsightsWebTestDefault 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${appServiceName}-webtest-default'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '${appServiceName}-webtest-default'
    Name: '${appServiceName}-webtest-default'
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
      RequestUrl: 'https://${webApp.properties.defaultHostName}/Scenarios/CrashOnStartup/CrashOnStartup1.aspx'
    }
    ValidationRules: {
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 100
    }
  }
}

resource appInsightsWebTestActual 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${appServiceName}-webtest-actual'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '${appServiceName}-webtest-actual'
    Name: '${appServiceName}-webtest-actual'
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
      RequestUrl: 'https://${webApp.properties.defaultHostName}/Scenarios/CrashOnStartup/CrashOnStartup1Actual.aspx'
    }
    ValidationRules: {
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 100
    }
  }
} 
