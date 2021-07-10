# FinAid
_TO DO: Add a brief description of this project here, in Markdown format. It will be shown on the main page of the project's GitHub repository._

## Development 
### Quick Start
#### Prerequisites
1. [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.232.0.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm). The **Salesforce CLI** notes below includes CLI commands to get you started.
2. [Visual Studio Code](https://code.visualstudio.com) with the [Salesforce Extension Pack](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode) for VS Code.
3. [Dev Hub](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_setup_enable_devhub.htm?search_text=bot%20deploy). See also Dev Hub Setup notes below.
4. [CumulusCI (CCI)](https://cumulusci.readthedocs.io/en/latest/). While you can work on this project using just the Salesforce CLI and VS Code, using CCI and scratch orgs is highly recommended for efficiency. The **CumulusCI** section below includes CCI commands to verify your setup and get you started. 

#### Salesforce CLI
##### Prerequisite Check
- Authorize a Dev Hub org. Use the `--setdefaultdevhubusername` option for CumulusCI.
  - FinAid DevHub: `sfdx force:auth:web:login --setalias ImpactLabs-FinAid-DevHub --setdefaultdevhubusername --instanceurl https:///il-finaiddevhub-dev-ed.my.salesforce.com`

- Display current configuration. For CumulusCI, the `defaultdevhubusername` should be set to your Dev Hub's username or its alias.
  - `sfdx config:list`

##### Developing with SFDX and CLI
- List metadata. Uses the `defaultusername` or what is specified in the `-u` or `--targetusername` parameter
  - Using the `defaultusername` setting: `sfdx force:mdapi:listmetadata -m Bot` 
  - Using a username: `sfdx force:mdapi:listmetadata -m Bot -u [Your username]` 
  - Using an alias: `sfdx force:mdapi:listmetadata -m Bot --targetusername ImpactLabs-FinAid-CDO` 
- Retrieve metadata from the org where customizations were done (typically a scratch org)
  - Named Einstein Bot and Version: `sfdx force:source:retrieve -m Bot:Alpha1,BotVersion:Alpha1.v1 -u [alias or username for the org used for development]` (Alpha1 is the bot name, Alpha1.v1 is the version)
  - All Einstein Bots: `sfdx force:source:retrieve -m Bot,BotVersion -u [alias or username for the org used for development]`
  - Named Chat Deployment: `sfdx force:source:retrieve -m LiveChatDeployment:live_agent_setup_flow -u ImpactLabs-RT-DE`
  - Named Queue: `sfdx force:source:retrieve -m Queue:FAFSA_Bots -u ImpactLabs-RT-DE`
  - Named Queue Routing Config: `sfdx force:source:retrieve -m QueueRoutingConfig:FAFSA_Bots -u ImpactLabs-RT-DE`
  - Permission Set (for Dev Hub org): `sfdx force:source:retrieve -m PermissionSet:SFDX_Developer_Perms -u ImpactLabs-RT-DevHub`
- Deploy to a target org, the FinAid CDO in the example below.
  - Named Einstein Bot and Version: `sfdx force:source:deploy -m Bot:Alpha1,BotVersion:Alpha1.v1 -u ImpactLabs-FinAid-CDO`
  - All Einstein Bots: `sfdx force:source:deploy -m Bot,BotVersion -u ImpactLabs-FinAid-CDO`

##### Helpful Commands
- Authorize a persistent org (use `--setalias` option to also set an org alias for convenience)
  - FinAid CDO: `sfdx force:auth:web:login --setalias ImpactLabs-FinAid-CDO --instanceurl https://impactlabseducationequity.my.salesforce.com`
- Display org details, for example,
  - Impact Labs Dev Hub using its previously set alias: `sfdx force:org:display --targetusername ImpactLabs-FinAid-DevHub`
  - Impact Labs CDO using its previously set alias: `sfdx force:org:display --targetusername ImpactLabs-FinAid-CDO`
- Display current aliases
  - `sfdx alias:list`
- Add org aliases for convenience (these can also be set when authorizing an org). For example,
  - FinAid Dev Hub: `sfdx alias:set ImpactLabs-FinAid-DevHub=[FinAid Dev Hub Username]`
  - FinAid Clean Demo Org (CDO): `sfdx alias:set ImpactLabs-FinAid-CDO=[FinAid CDO Username]`
  - To remove an org alias use: `sfdx alias:unset ImpactLabs-FinAid-CDO`
- Display current configuration
  - `sfdx config:list`
- Set default dev hub username
  - `sfdx config:set defaultdevhubusername=ImpactLabs-FinAid-DevHub`
- Set default user name
  - `sfdx config:set defaultusername=ImpactLabs-FinAid-CDO` (overwrites previous setting)

  
#### CumulusCI (CCI)
##### Prerequisite Check
- [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/get_started.html)
- Connect DevHub service. The `--project` flag makes the service available only to the project.
  - `cci service connect devhub FinAid-DevHub --project` 
- List Services
  - `cci service list`
- List connected orgs. This should include the org the default Dev Hub
  - `cci org list`
- Display project info - includes project's **git** branching prefixes, source format (should be _sfdx_)
  - `cci project info`

##### Developing with CCI
- Create a scratch org for development based on the `/orgs/dev.json` configuration. Do your customizations in this org for later retrieval, commit to `GitHub` and deployment
  - `cci org info dev`
- Set up an org as a development environment for _unmanaged metadata_. The task below _builds an unmanaged org designed for development use. It’s typically used with an org whose configuration is `dev`_. See [Cumulus CI Key Concepts](https://cumulusci.readthedocs.io/en/latest/concepts.html?highlight=cci%20flow%20run%20dev_org#tasks-and-flows)
  - `cci flow run dev_org --org dev` (where `dev` is the scratch org alias)
- Open the scratch org in your browser
  - `cci org browser dev` (opens the `dev` scratch org in your browser)
- List orgs
  - `cci org list`
- List `dev` org changes for a specific metadata type
  - `cci task run list_changes --org dev --include "^Bot:, BotVersion:"`
- Retrieve changes from the `dev` org
  - `cci task run retrieve_changes --org dev --include "^Bot:, BotVersion:"`
- Deploy changes. Use the `dx_push` task for SFDX source formats. 
  - `cci task run dx_push`
- Deploy only specific metadata types. Use SFDX command to deploy named metadata types. Better clarity on the `cci task` below is needed. 
  - `sfdx force:source:deploy -m Bot:Alpha1,BotVersion:Alpha1.v1 -u ImpactLabs-FinAid-CDO`
  - `cci task run dx_push --extra` (investigate if and how `dx_push` task can be used to deploy named metadata types)
##### Helpful Commands
- List all available CCI flows and tasks
  - `cci flow list`
  - `cci task list`
- Display more information about a specified CCI flow or task
  - `cci flow info <flow name>` 
  - `cci task info <task name>`

#### Working with Persistent Orgs
We can take advantage of a persistent org to allow more people to see development progress. One such org is the Clean Demo Org (CDO) we created for this purpose.

- Connect a persistent org to CCI. Example: connect the Impact Labs FinAid Clean Demo Org (CDO):
  - `cci org connect ImpactLabs-FinAid-CDO --login-url https://impactlabseducationequity.my.salesforce.com`
    - `ImpactLabs-FinAid-CDO` could be any easy to remember alias for the org
    - This CCI command does NOT set a Salesforce CLI alias for the org. To do so, run the `sfdx alias:set` command for the org
    - See [cci org connect documentation](https://cumulusci.readthedocs.io/en/stable/connected_orgs.html?highlight=cci%20org#the-org-connect-command)
- Verify successful connection to the org
  - `cci org browser ImpactLabs-FinAid-CDO` 
- List connected orgs
  - `cci org list`


#### Dev Hub Org Setup
1. [Add Salesforce DX Users](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_setup_add_users.htm#sfdx_setup_add_users). Salesforce license required: **Salesforce**, **Salesforce Platform**, **Developer**
2. Create and assign Permission Set. Required to grant non Sys Admins access to
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
