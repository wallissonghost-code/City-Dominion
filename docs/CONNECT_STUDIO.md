# Conectar City Dominion ao Roblox Studio

## 1. Baixar o projeto
No Windows, abra o PowerShell e execute:

```powershell
git clone https://github.com/wallissonghost-code/City-Dominion.git
cd City-Dominion
```

## 2. Instalar Rokit
Instale o Rokit pelo repositório oficial e confirme que o comando `rokit` funciona no PowerShell.

## 3. Instalar Rojo e o plugin
Dentro da pasta do projeto:

```powershell
rokit install
rojo plugin install
```

## 4. Iniciar sincronização

```powershell
rojo serve default.project.json
```

O servidor deve aparecer em `localhost:34872`.

## 5. Conectar no Roblox Studio
1. Abra o Roblox Studio.
2. Abra um Baseplate vazio.
3. Na barra de Plugins, abra o plugin Rojo.
4. Clique em **Connect**.
5. Confirme a sincronização do projeto `CityDominion`.

Os scripts do repositório aparecerão em `ReplicatedStorage`, `ServerScriptService` e `StarterPlayerScripts` conforme `default.project.json`.

## 6. Testar
Clique em **Play** no Studio. O protótipo deve gerar a cidade e habilitar a HUD e os sistemas iniciais.

## Atalho
Depois da instalação inicial, você pode usar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-rojo.ps1
```
