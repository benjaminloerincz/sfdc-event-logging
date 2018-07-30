# Advanced Logging with Platform Events
Salesforce Logging framework powered by Platform Events

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/)

Documentation
-------------

"Platform Events provide a means to send notifications from your code without fear of rollback, making them an ideal means to communicate diagnostics about your code. Apply Platform Events with worked examples to enhance your logging skills while making it easier to diagnose issues without debug logs! The session will include a small library and Lightning Component to monitor log output real time!"

- Dreamforce 2017 Session **Recording**, [Advanced Logging with Platform Events](https://www.youtube.com/watch?v=yYeurYnasVc)
- Dreamforce 2017 Session **Slides**, [Advanced Logging with Platform Events](https://www.slideshare.net/secret/IZg60GFyxpnfXA)

Deploying to a Sandbox
-----
Make a temporary directory to convert your source
```
mkdir src
```
Convert project to metadata API format
```
sfdx force:source:convert -d src/ --packagename eventlogging
```

Authenticate to your org

Sandbox
```
sfdx force:auth:web:login --setalias sandbox --instanceurl https://test.salesforce.com
```
Production
```
sfdx force:auth:web:login --setalias prod --instanceurl https://test.salesforce.com
```
Custom Domain
```
sfdx force:auth:web:login --setalias customm-domain --instanceurl https://org.my.salesforce.com
```

Deploy to Org
```
sfdx force:mdapi:deploy -d src/ -l RunSpecifiedTests -r LogTest,SessionControllerTest --wait 30 -u "org_alias"
```

Notes
-----

- Deploy My Domain
- Assign Event Logger Permission Set
