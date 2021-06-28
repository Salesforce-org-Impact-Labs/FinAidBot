# FinAid
Add a brief description of this project here, in Markdown format. It will be shown on the main page of the project's GitHub repository.
## Development 
### Quick Start
#### Prerequisites
1. [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.232.0.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm). The **Salesforce CLI** notes below includes CLI commands to get you started.
2. [Visual Studio Code](https://code.visualstudio.com) with the [Salesforce Extension Pack](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode) for VS Code.
3. [Dev Hub](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_setup_enable_devhub.htm?search_text=bot%20deploy). See also Dev Hub Setup notes below.
4. [CumulusCI (CCI)](https://cumulusci.readthedocs.io/en/latest/). While you can work on this project using just the Salesforce CLI and VS Code, using CCI and scratch orgs is highly recommended for efficiency. The **CumulusCI** section below includes CCI commands to verify your setup and get you started. 

#### Dev Hub Org Setup
1. [Add Salesforce DX Users](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_setup_add_users.htm#sfdx_setup_add_users). Salesforce license required: **Salesforce**, **Salesforce Platform**, **Developer**
2. Permission Set. Required to grant non Sys Admins access to
   1. Specific Salesforce DX objects
      1. Object Settings > **Scratch Org Infos** > Read, Create, Edit, and Delete
      2. Object Settings > **Active Scratch Orgs** > Read, Edit, and Delete
      3. Object Settings > **Namespace Registries** > Read
   2. Work with second-generation packages in the Dev Hub org. The permission set must also contain:
      1. System Permissions > **Create and Update Second-Generation Packages**
      2. This permission provides access to:
   

| Salesforce CLI Command |	Tooling API Object (Create and Edit) |
| :------------------------------| :------------------|
| `force:package:create`	     | Package2 |
| `force:package:version:create` |	 Package2VersionCreateRequest     |
| `force:package:version:update` | Package2Version |

#### Salesforce CLI
- Display current aliases
  - `sfdx alias:list`
- Add org aliases for convenience (these can also be set when authorizing an org). For example,
  - FinAid Dev Hub: `sfdx alias:set ImpactLabs-FinAid-DevHub=[FinAid Dev Hub Username]`
  - FinAid CDO: `sfdx alias:set ImpactLabs-FinAid-CDO=[FinAid CDO Username]`
  - To remove an org alias use: `sfdx alias:unset ImpactLabs-FinAid-CDO`
- Authorize a persistent org (use `--setalias` option to also set an org alias for convenience)
  - FinAid DevHub: `sfdx force:auth:web:login --setalias ImpactLabs-FinAid-DevHub --instanceurl https:///il-finaiddevhub-dev-ed.my.salesforce.com`
  - FinAid CDO: `sfdx force:auth:web:login --setalias ImpactLabs-FinAid-CDO --instanceurl https://impactlabseducationequity.my.salesforce.com`
- Display org details, for example,
  - Impact Labs Dev Hub using its previously set alias: `sfdx force:org:display --targetusername ImpactLabs-FinAid-DevHub`
  - Impact Labs CDO using its previously set alias: `sfdx force:org:display --targetusername ImpactLabs-FinAid-CDO`
- Display current configuration
  - `sfdx config:list`
- Set default dev hub username
  - `sfdx config:set defaultdevhubusername=ImpactLabs-FinAid-DevHub`
- Set default user name
  - `sfdx config:set defaultusername=ImpactLabs-FinAid-CDO` (overwrites previous setting)
- List metadata. Uses the `defaultusername` or what is specified in the `-u` or `--targetusername` parameter
  - Using the `defaultusername` setting: `sfdx force:mdapi:listmetadata -m Bot` 
  - Using a username: `sfdx force:mdapi:listmetadata -m Bot -u [Your username]` 
  - Using an alias: `sfdx force:mdapi:listmetadata -m Bot --targetusername ImpactLabs-FinAid-CDO` 
- Retrieve metadata from the org where customizations were done (typically a scratch org)
  - `sfdx force:source:retrieve -m Bot,BotVersion -u [alias or username for the org used for development]` 
- Deploy to a target org, the FinAid CDO in the example below.
  - `sfdx force:source:deploy -m Bot,BotVersion -u ImpactLabs-FinAid-CDO`
#### CumulusCI (CCI)
- [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/get_started.html) 
- Connect a persistent org to CCI. Example: connect the Impact Labs FinAid CDO:
  - `cci org connect ImpactLabs-FinAid-CDO --login-url https://impactlabseducationequity.my.salesforce.com`
    - `ImpactLabs-FinAid-CDO` could be any easy to remember alias for the org
    - This CCI command does NOT set a Salesforce CLI alias for the org. To do so, run the `sfdx alias:set` command for the org
    - See [cci org connect documentation](https://cumulusci.readthedocs.io/en/stable/connected_orgs.html?highlight=cci%20org#the-org-connect-command)
- Verify successful connection to the org
  - `cci org browser ImpactLabs-FinAid-CDO` 
- List connected orgs
  - `cci org list`
- Deploy project to the scratch org typically used for development
  - `cci flow run dev_org --org dev` (where `dev` is a  scratch org alias defined in the `orgs` under the CCI installation directory)
- Open the scratch org in your browser
  - `cci org browser dev` (opens the `dev` scratch org in your browser)
