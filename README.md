# SentinelAccess: Secure Remote-Boot Automation
<video src="presentation.mp4" width="800" controls>
  Twoja przeglądarka nie obsługuje odtwarzacza wideo.
</video>
*Wersja polska poniżej*

A high-performance Bash automation suite designed for secure, one-click remote access to a HomeLab infrastructure. This project was born out of a personal need to simplify a tedious daily routine of manual VPN connections, SSH hopping, and wake-on-lan triggers.

## The Challenge: Personal Need for Efficiency
As a HomeLab owner, managing my setup from remote locations (university, travel) was inefficient. The manual process involved at least four separate terminal commands and constant monitoring. I developed SentinelAccess to automate the entire workflow while maintaining a Zero Trust security posture:
- Tailscale (WireGuard): Creates a secure mesh VPN tunnel, removing the need for risky port forwarding.
- SSH Automation: Executes remote commands on the edge router using Ed25519 key-based authentication.
- L2 Broadcast: Uses the router as a trusted proxy to broadcast Magic Packets (WoL) within the local Ethernet segment.
- 
### Prerequisites & Important Setup Notes
To make this script work seamlessly, a few manual configurations are required beforehand:
1. **BIOS/UEFI Configuration:** Wake-on-LAN (WoL) must be explicitly enabled in the target workstation's BIOS and within the OS network adapter settings.
2. **Tailscale Network:** Both the client device (laptop) and the edge router (ZTE) must be authenticated and active on the same Tailscale tailnet.
3. **Tailscale Operator Privileges:** To allow the script to bring up Tailscale without `sudo` (which breaks automation), run this command once on your client machine: `sudo tailscale set --operator=$USER`.
4. **Remmina Profile:** You must manually configure and save a connection profile in Remmina first. Once saved, locate the `.remmina` configuration file (usually in `~/.local/share/remmina/`) and update the `REMMINA_PROFILE` path variable in the script.
5. **Passwordless SSH:** SSH key-based authentication must be set up between the client and the router so the script can execute `etherwake` without prompting for a password.

## System Components
- Automation: Bash scripts with advanced stream redirection (/dev/null) for a clean CLI experience.
- Network Edge: ZTE MF286D router running OpenWrt 23.05.
- VPN: Tailscale for encrypted, peer-to-peer connectivity.
- Client: Kali Linux (Laptop) and Remmina (RDP/VNC client).
- Target: Workstation supporting Wake-on-LAN.

### Usage
1. Make the script executable:
```bash
chmod +x sentinel_access.sh
```
2. Run the sequence:
```bash
./sentinel_access.sh
```

---

# Wersja Polska

Zautomatyzowany system w Bashu do bezpiecznego, zdalnego uruchamiania infrastruktury domowej (HomeLab). Projekt powstał z autentycznej potrzeby usprawnienia codziennego procesu zdalnego dostępu do moich zasobów IT.

## Wyzwanie: Rozwiązanie realnego problemu
Jako użytkownik HomeLabu, zarządzanie infrastrukturą z zewnątrz (np. z uczelni) wymagało ode mnie każdorazowego wykonywania serii uciążliwych czynności. Postanowiłem zautomatyzować ten proces, skracając go do jednego polecenia, przy zachowaniu rygorystycznych standardów bezpieczeństwa:
- Brak wystawionych portów: Dzięki Tailscale (WireGuard) router nie wymaga otwartych portów na świat.
- Izolacja L2: Pakiety Magic Packet są rozsyłane tylko wewnątrz sieci lokalnej przez router OpenWrt.
- Automatyzacja: Skrypt samodzielnie zarządza tunelem VPN i monitoruje dostępność maszyny przed startem klienta RDP.

## Jak to działa?
1. VPN Check: Skrypt weryfikuje status Tailscale i w razie potrzeby podnosi tunel.
2. Remote Trigger: Łączy się przez SSH z routerem ZTE (OpenWrt) i wykonuje polecenie etherwake.
3. Smart Polling: Monitoruje status sieciowy maszyny docelowej do momentu pełnego uruchomienia systemu.
4. Final Session: Automatycznie uruchamia program Remmina z odpowiednimi parametrami połączenia.

### Wymagania wstępne i ważne kruczki
Aby skrypt zadziałał poprawnie, konieczne jest wcześniejsze przygotowanie środowiska:
1. **Konfiguracja BIOS/OS:** Funkcja Wake-on-LAN (WoL) musi być włączona w BIOSie/UEFI komputera docelowego oraz we właściwościach jego karty sieciowej w systemie.
2. **Sieć VPN:** Zarówno urządzenie klienckie (laptop), jak i router (ZTE) muszą być dodane do tej samej sieci w Tailscale.
3. **Uprawnienia Tailscale:** Aby skrypt mógł włączać VPN bez proszenia o hasło `sudo`, wykonaj jednorazowo na swoim laptopie polecenie: `sudo tailscale set --operator=$USER`.
4. **Profil Remmina:** Zanim uruchomisz skrypt, skonfiguruj połączenie bezpośrednio w Remminie i zapisz je. Następnie odszukaj plik konfiguracyjny `.remmina` (zazwyczaj w katalogu `~/.local/share/remmina/`) i zaktualizuj ścieżkę w zmiennej `REMMINA_PROFILE` w skrypcie.
5. **Klucze SSH:** Wymagane jest skonfigurowanie logowania SSH bez hasła (z użyciem kluczy np. Ed25519) z laptopa na router, aby skrypt nie zacinał się na prośbie o hasło przy wysyłaniu Magic Packet.

## Technologie
- Skrypty: Bash (Linux).
- Router: ZTE MF286D z systemem OpenWrt.
- VPN: Tailscale (Mesh VPN).
- Zdalny pulpit: Remmina / RDP.
### Jak uruchomić?
1. Nadaj skryptowi uprawnienia do wykonywania:
```bash
chmod +x sentinel_access.sh
```
2. Odpal skrypt:
```bash
./sentinel_access.sh
```

Projekt stworzony w celu eliminacji powtarzalnych czynności konfiguracyjnych i zabezpieczenia dostępu do domowych zasobów, których używam na co dzień.
