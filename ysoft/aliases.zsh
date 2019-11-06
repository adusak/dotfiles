restartSpooler() {
  launchctl unload -w /Library/LaunchAgents/com.ysoft.safeq.client.plist
  launchctl load -w /Library/LaunchAgents/com.ysoft.safeq.client.plist
  sudo launchctl unload -w /Library/LaunchDaemons/com.ysoft.safeq.spooler.plist
  sudo launchctl load -w /Library/LaunchDaemons/com.ysoft.safeq.spooler.plist
}