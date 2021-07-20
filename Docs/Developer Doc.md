## Work Around Current Issues
### Work around [Issue #34](https://github.com/Salesforce-org-Impact-Labs/FinAid/issues/34)
#### Issue Summary
The bot's **Bot User** setting must be set to a **Custom Chatbot User** instead of **Basic Chatter User** in order to have access to Salesforce Knowledge. The **Custom Chatbot User** setting requires a user with access to Knowledge to be specified. However, committing this configuration to the repo, can cause problems when deploying from the repo with a message such as:

>_Invalid value for Bot User field given. ERROR running force:source:push: Push failed_

#### Work-Around

Do the pre- and post-deployment steps in this section if the bot was committed to the repo with the `Bot User` setting set to a `Custom Chatbot User`, which when enabled requires a user to be specified. This is the case if element  `<botUser>USER_NAME</botUser>` element exists in `Alpha1.bot-meta.xml` metadata file under `force-app/main/default/bots`
##### Pre-Deployment
Manually delete the following element  `<botUser>USER_NAME</botUser>` from `Alpha1.bot-meta.xml` metadata file under `force-app/main/default/bots`

##### Post-Deployment
Reconfigure the bot to set the **Bot User** setting to a **Custom Chatbot User** and specify a user that has access to Knowledge, which the bot requires. Note that the bot must be deactivated in order to edit settings.

![Bot User setting](/Docs/images/FAFSABot-BotUserSetting.png). 

To get to the page shown in the image above,
1. Go to **Setup -> Feature Settings -> Service -> Service Cloud Einstein -> Einstein Bots** or search for "bot" in **Setup -> Quick Find** and click **Einstein Bots" to bring up the **Einstein Bots** page
2. On the **Eintein Bots** page, go to the **My Bots** section (_you may have to scroll down the page_) and click on the bot version you want to edit, e.g., **Version 3**. This brings up the **Einstein Bot Builder** page.
3. On the **Einstein Bot Builder** page, bring up the **Overview** page using the pick list on the top left corner of the pagge. Set the **Bot User** setting to use a **Custom Chatbot User** and specify a user that has access to Knowledge.

### Work around issue [Issue #36](https://github.com/Salesforce-org-Impact-Labs/FinAid/issues/36)
#### Issue Summary

Deployment using `cci flow run dev_org --org dev` (when creating a dev scratch org) and `sfdx force:source:deploy` fails with the error message below when using Article Answers

>_Invocation Target ID: bad value for restricted picklist field: generateKnowledgeLogData_

The deployment succeeds and the message disappears if the **Article Answers** dialog's **Generate Knowledge Feedback Log** action is deleted.

#### Work-Around

Do the following work around **if and only if** a bot version you want to deploy uses  **Article Answers**.

##### Pre-Deployment
Manually delete the **Article Answers** dialog's **Generate Knowledge Feedback Log** action in the `v3.botVersion-meta.xml` metadata file.

1. Locate the **Article Answers** dialog. Search for `<label>Article Answers</label>` in the `v3.botVersion-meta.xml` metadata file or whichever version of the bot you're trying to deploy under `force-app/main/default/bots`.
2. In the **Article Answers** dialog, locate `<botSteps>` that has the **Generate Knowledge Feedback Log** action and delete it. It should look something like the XML block below.
3. Repeat steps above for all versions that use **Article Answers** you want to deploy.
```   
<botDialogs>
    <botSteps>
        <botInvocation>
            <invocationActionName>generateKnowledgeLogData</invocationActionName>
            <invocationActionType>logFeedback</invocationActionType>
        </botInvocation>
        ...
    </botSteps>
    ...
    <description>Article Answers (Beta) can be used instead of the FAFSA Terms dialog</description>
    <developerName>Answer_Automation</developerName>
    <label>Article Answers</label>
    <showInFooterMenu>false</showInFooterMenu>
</botDialogs>
```
##### Post-Deployment
Restore the **Article Answers** dialog's **Generate Knowledge Feedback Log** action as shown in the image below. Do this for every metadata file from which it was manually deleted, e.g., `v3.botVersion-meta.xml` metadata file.

The action should be right after the **Was this useful?** question action of the **Article Answers** dialog. Basically, it just logs the user's answer to the question and its context.

![Generate Knowledge Feedback Log](./images/FAFSABot-ArticleAnswers-GenerateKnowledgeFeedbackLog.png)

To get to the page shown in the image above,
1. Go to **Setup -> Feature Settings -> Service -> Service Cloud Einstein -> Einstein Bots** or search for "bot" in **Setup -> Quick Find** and click **Einstein Bots" to bring up the **Einstein Bots** page
2. On the **Eintein Bots** page, go to the **My Bots** section and click on the FAFSA Bot version you want to edit, e.g., **Version 3**. This brings up the **Einstein Bot Builder** page.
3. On the **Einstein Bot Builder** page, switch to **Dialogs** using the pick list on the top left corner. Find the **Article Answers** dialog and click on it to edit it and add a **Generate Knowledge Feedback Log** action right after the the **Was this useful?** question action. NOTE: You have to deactivate the bot to edit.
