# Blocage robuste de Roblox — Environnement domestique

## 🎯 Objectif

Bloquer **définitivement Roblox** dans un environnement domestique multi-PC :

- via navigateur (Firefox, Chrome, Edge)
- via application Roblox
- via contournements DNS / DoH / QUIC
- sans droits administrateur pour les utilisateurs
- tout en conservant :
  - navigation web normale
  - développement (WSL, apt, VS Code)

---

## 🧱 Architecture finale

PC Windows
├─ Pare-feu Windows (autorité finale)
│ ├─ Bloque HTTP/HTTPS direct
│ ├─ Bloque QUIC (UDP 443)
│ └─ Autorise uniquement Proxy + DNS
│
├─ Proxy système forcé (WinINET)
│
├─ WSL Ubuntu
│ └─ Proxy configuré localement
│
└─ Utilisateurs non-admin (verrouillés)

Synology
└─ Proxy Server
├─ Règles DENY Roblox
└─ ACCEPT réseau local en dernier

AdGuard Home
└─ DNS filtré (complémentaire)


---

## 🔒 Pare-feu Windows — règles actives

### ❌ Blocages globaux
- TCP 80 / 443 (Internet direct)
- UDP 443 (QUIC / HTTP/3)

### ✅ Autorisations strictes
- TCP 3128 → IP du Synology (Proxy Server)
- UDP + TCP 53 → IP d’AdGuard Home

---

## 🌐 Proxy Windows (WinINET)

- Proxy forcé via **tâche planifiée**
- Appliqué **à chaque ouverture de session**
- Impossible à conserver modifié par un utilisateur non-admin

**Adresse du proxy :**
192.168.1.11:3128


---

## 🧠 Proxy Synology — configuration critique

### ⚠️ Ordre des règles (fondamental)

1. ❌ DENY `.roblox.com`
2. ❌ DENY `.rbxcdn.com`
3. ❌ DENY plages IP Roblox (optionnel)
4. ✅ ACCEPT réseau local (**TOUJOURS EN DERNIER**)

> ⚠️ Mettre l’ACCEPT réseau local avant les règles DENY permet un contournement.

---

## 🐧 WSL (Ubuntu)

WSL utilise sa propre pile réseau et **n’hérite pas du proxy Windows**.

### Configuration APT

**Fichier :** `/etc/apt/apt.conf.d/95proxy`
```conf
Acquire::http::Proxy "http://192.168.1.11:3128/";
Acquire::https::Proxy "http://192.168.1.11:3128/";



