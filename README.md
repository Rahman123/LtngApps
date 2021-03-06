***Keyboard Shortcuts***

[You Tube Demo](https://www.youtube.com/watch?v=fpHJYhiIVuc)

[AppExchange Listing](https://appexchange.salesforce.com/listingDetail?listingId=a0N3A00000EFp5PUAT)


<a href="https://githubsfdeploy.herokuapp.com?owner=jrattanpal&repo=LtngApps">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

<br/><br/>
**KEYBOARD SHORTCUTS**

***LAKeyboardShortcutList.cmp***:
- Component to add keyboard shortcuts
- User choices are stored as JSON string to custom object
- "shortcutsDefault" can be used by admins to provide a default JSON key map for new users who haven't created any shortcuts yet


***LAKeyboardShortcutAdd.cmp***:
- Component to list keyboard shortcuts
- User choices are retrieved from custom object and displayed as list

***LAKeyboard.cmp***
- Adds LAKeyboardShortcutList.cmp and LAKeyboardShortcutAdd.cmp as nested components in lightning:tab
- afterRender on renderer takes care of loading those shortcuts as settings those for document.onkeydown
- Users can use buttons below "Path" to fetch current page path; With or without query params (anything after ?)


**Credits**

I have used following libraries in my projects. These helped me reduce development times by almost 50-60%
- [ETLC_ApexBridge](https://github.com/eltoroit/ETLC_ApexBridge)
- [CodeScience CSUtils](https://github.com/CodeScience/CSUtils/tree/sec-rev/src/classes)

Thanks,
<br/>
[Jaswinder Rattanpal](www.rattanpal.com)

