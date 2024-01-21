#Requires -Version 5
#Requires -RunAsAdministrator

<#
.Synposis
    Uninstall packages that are pre-installed
#>

function Uninstall-Packages() {
    winget uninstall -e "Clipchamp"
    winget uninstall -e "Cortana"
    winget uninstall -e "Feedback Hub"
    winget uninstall -e "Get Help"
    winget uninstall -e "MSN Weather"
    winget uninstall -e "Mail and Calendar"
    winget uninstall -e "Microsoft 365 (Office)"
    winget uninstall -e "Microsoft Family"
    winget uninstall -e "Microsoft OneDrive"
    winget uninstall -e "Microsoft People"
    winget uninstall -e "Microsoft Photos"
    winget uninstall -e "Microsoft Sticky Notes"
    winget uninstall -e "Microsoft Teams"
    winget uninstall -e "Microsoft Tips"
    winget uninstall -e "Microsoft To Do"
    winget uninstall -e "Movies & TV"
    winget uninstall -e "News"
    winget uninstall -e "OneDrive"
    winget uninstall -e "Paint"
    winget uninstall -e "Phone Link"
    winget uninstall -e "Power Automate"
    winget uninstall -e "Quick Assist"
    winget uninstall -e "Solitaire & Casual Games"
    winget uninstall -e "Store Experience Host"
    winget uninstall -e "Windows Maps"
    winget uninstall -e "Windows Media Player"
    winget uninstall -e "Windows Notepad"
    winget uninstall -e "Windows Voice Recorder"
    winget uninstall -e "Windows Web Experience Pack"
    winget uninstall -e "Xbox Game Bar Plugin"
    winget uninstall -e "Xbox Game Bar"
    winget uninstall -e "Xbox Game Speech Window"
    winget uninstall -e "Xbox Identity Provider"
    winget uninstall -e "Xbox TCUI"
    winget uninstall -e "Xbox"
}

Uninstall-Packages
