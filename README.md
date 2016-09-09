# MyOps Slack Module

This module provides a MyOps notifier for Slack. It will notify a given Slack
Web Hook URL on various events. The supported events currently include:

* Whenever a collection changes its trigger
* Whenever a server status changes (up or down)

![Screenshot](https://share.adam.ac/16/9GRhQcuk.png)

## Installation

Add `myops-slack` plus required configuration to your MyOps configuration file at `/opt/myops/config/myops.yml`.

```yaml
modules:
  -
    name: myops-slack
    repo: adamcooke/myops-slack
    config:
      url: https://hooks.slack.com/services/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

      # The following configuration is optional

      # This is the channel name which messages will be posted to if you don't
      # wish to send them to the channel confiured in the URL
      channel: #ops
      # The username which will appear on messages sent by MyOps
      username: MyOps
      # This is the emoji icon. By default, there is no icon.
      icon: cow
```

Once, you've done this you can update the modules the application and restart it.

```
$ myops update-modules
$ myops restart
```
