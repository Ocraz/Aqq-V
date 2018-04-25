# Aqq-V
App-V uses the Q: drive for hosting the virtual application during the application's session.
That's why lots of sysadmins exclude Q:\ from scanning in their AV tool of choice.
So, if Q: doesn't exist by default, why not create it in order to bypass AV? 

aqq-v_local.ps1 creates C: through Q: through either subst or net use and removes C: through P:, leaving Q:

aqq-v_usb.ps1 creates C: through P: and waits for an USB drive, which creates Q:
