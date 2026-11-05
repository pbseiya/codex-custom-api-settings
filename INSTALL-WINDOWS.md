# Installation Guide for Windows

คู่มือนี้แนะนำการติดตั้ง Codex provider selector บน Windows 10/11

> **หมายเหตุ:** คู่มือนี้ใช้ทั้ง **Command Prompt (CMD)** และ **Windows PowerShell 5.1**
> - คำสั่ง CMD: `cmd` (ใช้ `%VARIABLE%`)
> - คำสั่ง PowerShell: `powershell` (ใช้ `$env:VARIABLE`)

## Prerequisites

### กรณี 1: ใช้ ChatGPT Desktop เท่านั้น (ไม่ต้องติดตั้ง Codex CLI)

**เหมาะสำหรับ:** เครื่องที่บริษัท block การติดตั้ง npm หรือต้องการใช้เฉพาะ ChatGPT Desktop

**สิ่งที่คุณต้องมี:**
- ChatGPT Desktop (ดาวน์โหลดจาก [openai.com/chatgpt/desktop](https://openai.com/chatgpt/desktop))
- Web browser สำหรับดาวน์โหลดไฟล์ ZIP
- Virtual Key จากผู้ดูแล LiteLLM

**หมายเหตุ:** ChatGPT Desktop มี bundled Codex runtime อยู่แล้ว ไม่ต้องติดตั้ง Codex CLI แยก

### กรณี 2: ใช้ Codex CLI เต็มรูปแบบ (ต้องติดตั้ง Node.js และ npm)

**เหมาะสำหรับ:** ผู้ที่ต้องการใช้ Codex CLI/TUI แบบ standalone

**สิ่งที่คุณต้องมี:**
- Node.js LTS (ติดตั้งจาก nodejs.org หรือ winget)
- npm (มาพร้อมกับ Node.js)
- Codex CLI (ติดตั้งผ่าน `npm install -g @openai/codex`)
- ChatGPT Desktop (ดาวน์โหลดจาก [openai.com/chatgpt/desktop](https://openai.com/chatgpt/desktop))
- Virtual Key จากผู้ดูแล LiteLLM

---

## Prerequisites (สำหรับกรณี 2 เท่านั้น)

### 1. ติดตั้ง Node.js และ npm

เลือกเพียงหนึ่งวิธี

#### วิธีที่ 1: ดาวน์โหลดจาก nodejs.org

วิธีนี้แนะนำสำหรับผู้ใช้ที่ไม่ต้องสลับ Node.js หลายรุ่น

1. ดาวน์โหลด Node.js รุ่น LTS จาก [nodejs.org](https://nodejs.org/)
2. รันไฟล์ `.msi`
3. ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่
4. ตรวจสอบ:

```cmd
node --version
npm --version
```

#### วิธีที่ 2: ใช้ winget

ตรวจสอบก่อนว่าเครื่องมี winget:

```powershell
winget --version
```

ถ้าพบ winget ให้ติดตั้ง Node.js รุ่น LTS:

```powershell
winget install OpenJS.NodeJS.LTS
```

ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่ จากนั้นตรวจสอบ:

```cmd
node --version
npm --version
```

#### วิธีที่ 3: ใช้ NVM for Windows 2.0.0

วิธีนี้เหมาะกับผู้ใช้ที่ต้องสลับ Node.js หลายรุ่น

1. เปิด [หน้า Download NVM](https://www.nvmnode.com/guide/download.html)
2. ดาวน์โหลด `nvm-2.0.0-amd64-setup.exe` สำหรับ Windows x64
3. รันตัวติดตั้ง และใช้ตำแหน่งที่โปรแกรมเสนอไว้
4. ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่
5. ตรวจสอบ:

```powershell
nvm version
```

ติดตั้งและเลือก Node.js รุ่น LTS:

```powershell
nvm install lts
nvm use lts
node --version
npm --version
```

ถ้า `nvm` ยังไม่พบ ให้ดูหัวข้อ Troubleshooting

#### วิธีที่ 4: ใช้ fnm

ตรวจสอบก่อนว่าเครื่องมี winget แล้วติดตั้ง fnm:

```powershell
winget --version
winget install Schniz.fnm
```

ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่ จากนั้นติดตั้ง Node.js รุ่น LTS:

```powershell
fnm install --lts
fnm use lts
fnm default lts
node --version
npm --version
```

#### แก้ปัญหา npm global PATH

ถ้า `npm install -g` สำเร็จ แต่คำสั่งที่ติดตั้งยังไม่พบ ให้เพิ่ม npm global directory ลง User PATH ด้วย PowerShell:

```powershell
$npmPrefix = npm prefix -g
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $npmPrefix) {
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$npmPrefix", 'User')
}
```

ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่

### 2. ติดตั้ง Codex CLI

ใช้ CMD:
```cmd
npm install -g @openai/codex
```

ตรวจสอบ:
```cmd
codex --version
```

### 3. ติดตั้ง ChatGPT Desktop

ดาวน์โหลดจาก [openai.com/chatgpt/desktop](https://openai.com/chatgpt/desktop)

ติดตั้งตามปกติ แล้วเปิดแอปอย่างน้อยหนึ่งครั้งเพื่อสร้าง `%USERPROFILE%\.codex`

### 4. ตรวจสอบ CODEX_HOME

Codex บน Windows ใช้ `%USERPROFILE%\.codex` เป็น default

ใช้ CMD:
```cmd
echo %USERPROFILE%\.codex
```

ควรเห็น: `C:\Users\<username>\.codex`

## Installation Steps

### Step 1: ดาวน์โหลด Source Code

#### กรณี 1: ChatGPT Desktop เท่านั้น (แนะนำ Download ZIP)

ใช้ Download ZIP เพราะไม่ต้องติดตั้ง git:

1. เปิด browser ไปที่: https://github.com/pbseiya/codex-custom-api-settings
2. คลิกปุ่ม **Code** (สีเขียว) → เลือก **Download ZIP**
3. Extract ไฟล์ ZIP (คลิกขวา → **Extract All...** หรือใช้ 7-Zip)
4. Rename folder จาก `codex-custom-api-settings-main` เป็น `codex-custom-api-settings`:

ใช้ CMD:
```cmd
cd %USERPROFILE%\
rename codex-custom-api-settings-main codex-custom-api-settings
```

หรือใช้ PowerShell:
```powershell
cd $env:USERPROFILE
Rename-Item codex-custom-api-settings-main codex-custom-api-settings
```

#### กรณี 2: Codex CLI เต็มรูปแบบ (เลือก Git Clone หรือ Download ZIP)

**วิธีที่ 1: Git Clone** (แนะนำสำหรับผู้ที่คุ้นเคยกับ git)

ใช้ CMD:
```cmd
cd %USERPROFILE%\
git clone https://github.com/pbseiya/codex-custom-api-settings.git
cd codex-custom-api-settings
```

หรือใช้ PowerShell:
```powershell
cd $env:USERPROFILE
git clone https://github.com/pbseiya/codex-custom-api-settings.git
cd codex-custom-api-settings
```

**ข้อดี:**
- อัพเดตง่ายด้วย `git pull`
- ติดตาม version และประวัติการเปลี่ยนแปลงได้

**วิธีที่ 2: Download ZIP** (สำหรับผู้ที่ไม่มี git)

ทำตามขั้นตอนเดียวกับกรณี 1 ด้านบน

**ข้อดี:**
- ไม่ต้องติดตั้ง git
- ไม่ต้อง setup authentication
- ง่ายและรวดเร็ว

**ข้อเสีย:**
- เมื่อมีอัพเดต ต้อง download ZIP ใหม่และ replace ไฟล์เอง
- ไม่มี version control

### Step 2: รับ Virtual Key จากผู้ดูแล LiteLLM

ขอ Virtual Key ที่เข้าถึง `deepseek-v4.1-flash`, `qwen3.8-max`, และ `qwen3.8-flash` จากผู้ดูแล LiteLLM อย่าสร้าง key ใหม่เองถ้าผู้ดูแลกำหนด key ให้แล้ว

### Step 3: สร้างไฟล์ .env

บนเครื่อง Windows ใช้ CMD:
```cmd
cd %USERPROFILE%\.codex
notepad .env
```

เพิ่ม:
```
ALIBABA_KEY=<assigned-virtual-key>
```

บันทึกและปิด

จำกัดสิทธิ์ไฟล์ให้ผู้ใช้ปัจจุบัน ไม่ต้องเปิด CMD แบบ Administrator:
```cmd
icacls .env /inheritance:r /grant:r "%USERNAME%:(R,W)"
```

### Step 4: สร้าง Model Catalog

คัดลอกไฟล์จาก repository ใช้ CMD:
```cmd
cd %USERPROFILE%\.codex
copy %USERPROFILE%\codex-custom-api-settings\model-catalog-alibaba.json .
```

### Step 5: ติดตั้ง codex-selector

คัดลอก PowerShell script ใช้ CMD:
```cmd
cd %USERPROFILE%
copy codex-custom-api-settings\codex-selector.ps1 .
```

### Step 6: ติดตั้ง Launcher Script

คัดลอก launcher จาก repository ใช้ CMD:

```cmd
copy %USERPROFILE%\codex-custom-api-settings\codex-selector.bat %USERPROFILE%\codex-selector.bat
```

launcher ตรวจ `codex-selector.ps1` ก่อนทำงาน หากไฟล์หาย แต่ repository ยังอยู่ที่ `%USERPROFILE%\codex-custom-api-settings` launcher จะคัดลอกไฟล์กลับให้อัตโนมัติ

### Step 7: เพิ่มเข้า User PATH

ใช้ PowerShell เพื่อเพิ่มเฉพาะ `%USERPROFILE%` ลง User PATH โดยไม่คัดลอก Machine PATH มาทับ:

```powershell
$selectorDir = $env:USERPROFILE
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$entries = @($userPath -split ';' | Where-Object { $_ })
if ($entries -notcontains $selectorDir) {
    $newUserPath = (@($entries) + $selectorDir) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User')
}
```

ปิดและเปิด PowerShell/CMD ใหม่เพื่อให้ PATH มีผล

### Step 8: สร้าง Desktop Shortcuts

เรียกสคริปต์ที่รวมอยู่ใน repository ด้วย PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\codex-custom-api-settings\create-desktop-shortcuts.ps1"
```

สคริปต์ใช้ Desktop path จริงของ Windows จึงรองรับเครื่องที่ Desktop อยู่ใน OneDrive และสร้างไอคอน:

- `Codex - OpenAI`
- `Codex - ALIBABA`

ดับเบิลคลิกไอคอนเพื่อสลับ provider และ restart ChatGPT/Codex Desktop โดยอัตโนมัติ

## สรุปวิธีใช้งานประจำวัน

ใช้ selector ก่อนเปิด Codex เพื่อกำหนดว่า Codex CLI/TUI และ ChatGPT Desktop จะเรียก provider ใด

### ใช้ ALIBABA

CMD:

```cmd
codex-selector alibaba
codex
```

PowerShell:

```powershell
& "$env:USERPROFILE\codex-selector.bat" alibaba
codex
```

โหมดนี้ใช้ LiteLLM ThinkStation และแสดงเฉพาะโมเดลต่อไปนี้:

- `deepseek-v4.1-flash`
- `qwen3.8-max`
- `qwen3.8-flash`

ถ้าต้องการสลับโหมดและเปิด ChatGPT Desktop ใหม่ทันที ให้ใช้:

CMD:

```cmd
codex-selector alibaba -RestartDesktop
```

PowerShell:

```powershell
& "$env:USERPROFILE\codex-selector.bat" alibaba -RestartDesktop
```

### ใช้ OpenAI

CMD:

```cmd
codex-selector openai
codex
```

PowerShell:

```powershell
& "$env:USERPROFILE\codex-selector.bat" openai
codex
```

โหมดนี้กลับไปใช้บัญชี OpenAI และ catalog โมเดลทั้งหมดที่บัญชีได้รับ

ถ้าต้องการสลับโหมดและเปิด ChatGPT Desktop ใหม่ทันที ให้ใช้:

CMD:

```cmd
codex-selector openai -RestartDesktop
```

PowerShell:

```powershell
& "$env:USERPROFILE\codex-selector.bat" openai -RestartDesktop
```

### ตรวจสอบโหมดปัจจุบัน

CMD:

```cmd
codex-selector status
```

PowerShell:

```powershell
& "$env:USERPROFILE\codex-selector.bat" status
```

`codex-selector` เปลี่ยนทั้ง Codex CLI/TUI และ ChatGPT Desktop เพราะทั้งสองโปรแกรมอ่าน `%USERPROFILE%\.codex\config.toml` เดียวกัน หลังใช้คำสั่ง selector ให้ปิด Codex CLI/TUI ที่เปิดค้างอยู่แล้วเปิดใหม่ หาก ChatGPT Desktop เปิดค้างอยู่ ให้ใช้ `-RestartDesktop` เพื่อให้แอปอ่านค่าใหม่

## Testing

`codex-selector.bat` เป็น Windows batch launcher ที่เรียก `codex-selector.ps1` ให้เอง

- **CMD:** เรียก `codex-selector` ได้โดยตรง
- **PowerShell:** ต้องระบุ path เป็น `codex-selector.bat` หรือ `.\codex-selector.bat` เพราะ PowerShell ไม่ค้นหาไฟล์ใน directory ปัจจุบันโดยอัตโนมัติ
- หาก `%USERPROFILE%` อยู่ใน `PATH` และเปิด terminal ใหม่แล้ว PowerShell อาจเรียก `codex-selector.bat` ได้โดยไม่ต้องใส่ `.\` แต่คู่มือนี้ใช้ชื่อไฟล์เต็มเพื่อลดความสับสน

### Test 1: ตรวจสอบ Status

ใช้ CMD:
```cmd
codex-selector status
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" status
```

ควรเห็น:
```
mode=openai
desktop=stopped
```

### Test 2: สลับเป็น ALIBABA

ใช้ CMD:
```cmd
codex-selector alibaba
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" alibaba
```

ควรเห็น:
```
mode=alibaba
backup=C:\Users\<username>\.codex\backups\selector\config-YYYYMMDD-HHMMSS-NNNNNNNNN.toml
desktop=stopped
```

### Test 3: เปิด ChatGPT Desktop

ใช้ CMD:
```cmd
codex-selector alibaba -RestartDesktop
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" alibaba -RestartDesktop
```

ChatGPT Desktop ควรเปิดขึ้นมา

### Test 4: ตรวจสอบ Model Picker

ใน ChatGPT Desktop:
1. คลิกที่ model selector (มุมบนขวา)
2. ควรเห็น:
   - deepseek-v4.1-flash
   - qwen3.8-max
   - qwen3.8-flash

### Test 5: ทดสอบ CLI

ใช้ PowerShell ค้นหา runtime ที่มากับ Desktop แล้วทดสอบ:

```powershell
$codex = Get-ChildItem "$env:LOCALAPPDATA\OpenAI\Codex\bin" -Filter codex.exe -File -Recurse |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1 -ExpandProperty FullName
& $codex exec --skip-git-repo-check "Reply exactly ALIBABA_OK"
```

ใช้ Codex runtime ที่มากับ Desktop เพราะ runtime นี้มี Windows sandbox helper ครบกว่า `codex.exe` รุ่น standalone บางรุ่น

ควรเห็น `provider: alibaba` และคำตอบ `ALIBABA_OK`

### Test 6: สลับกลับ OpenAI

ใช้ CMD:
```cmd
codex-selector openai -RestartDesktop
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" openai -RestartDesktop
```

ใน ChatGPT Desktop ควรเห็น OpenAI models ทั้งหมด

## Troubleshooting

### ปัญหา: "codex-selector is not recognized"

**สาเหตุ:** PATH ยังไม่ถูกตั้ง (สำหรับ codex-selector.bat)

**แก้:**
1. ปิดและเปิด PowerShell/CMD ใหม่
2. ถ้ายังไม่พบ ให้ทำ Step 7 อีกครั้ง แล้วปิด terminal ทุกหน้าต่างก่อนเปิดใหม่

### ปัญหา: "codex is not recognized"

**สาเหตุ:** npm prefix ไม่มีใน PATH

**แก้:** ใช้ PowerShell เพื่ออ่าน npm prefix จริง:
```powershell
$npmPrefix = npm prefix -g
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $npmPrefix) {
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$npmPrefix", 'User')
}
```

แล้วปิด terminal ทุกหน้าต่างก่อนเปิดใหม่

หรือใช้ `npx` แทน:
```cmd
npx @openai/codex --version
```

### ปัญหา: "nvm is not recognized"

ปิด Windows Terminal ทุกหน้าต่างแล้วเปิดใหม่ก่อน ถ้ายังไม่พบ ให้ค้นหา `nvm.exe`:

```powershell
Get-ChildItem "$env:LOCALAPPDATA" -Filter nvm.exe -File -Recurse -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName
```

เพิ่ม folder ที่มี `nvm.exe` ลง User PATH โดยแทนค่า `<NVM-FOLDER>` ด้วยผลลัพธ์ที่พบ:

```powershell
$nvmDir = '<NVM-FOLDER>'
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $nvmDir) {
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$nvmDir", 'User')
}
```

ปิด terminal ทุกหน้าต่าง เปิดใหม่ แล้วรัน `nvm version`

### ปัญหา: "execution of scripts is disabled"

**สาเหตุ:** PowerShell execution policy

**แก้:** ใช้ PowerShell:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ปัญหา: ChatGPT Desktop ไม่เปิด

**สาเหตุ:** ChatGPT/Codex Desktop บน Windows มักติดตั้งเป็น Microsoft Store/MSIX app ซึ่งไม่มี executable path แบบคงที่

**การทำงานของ selector:**
1. ค้นหา App ID ที่ลงทะเบียนไว้ด้วย `Get-StartApps`
2. หากไม่พบ จึงลอง path ของการติดตั้งแบบ executable ปกติ

ตรวจว่า Store app เปิดได้ด้วย PowerShell:

```powershell
$app = Get-StartApps | Where-Object { $_.AppID -like 'OpenAI.Codex_*!App' } | Select-Object -First 1
if (-not $app) { throw 'Codex Desktop AppID not found' }
Start-Process ("shell:AppsFolder\" + $app.AppID)
```

### ปัญหา: `too few unicode value digits` ตอนเปิด Desktop

**สาเหตุ:** Windows path ที่ใช้ backslash เช่น `C:\Users\...` ถูกเขียนใน TOML double-quoted string ทำให้ `\U` ถูกตีความเป็น Unicode escape

selector เวอร์ชันปัจจุบันแปลง catalog path เป็น forward slash อัตโนมัติ:

```toml
model_catalog_json = "C:/Users/<username>/.codex/model-catalog-alibaba.json"
```

ถ้าเคยใช้ selector รุ่นเก่า ให้ดาวน์โหลดหรือ pull repository รุ่นล่าสุด แล้วติดตั้ง `codex-selector.ps1` ใหม่ก่อนเริ่มขั้นตอนทดสอบตั้งแต่ต้น

### ปัญหา: `Model provider alibaba not found`

**สาเหตุ:** `config.toml` ยังไม่มีตาราง `[model_providers.alibaba]`

selector เวอร์ชันปัจจุบันเพิ่มตาราง provider ให้อัตโนมัติเมื่อเลือก ALIBABA ดาวน์โหลด repository รุ่นล่าสุด แล้วติดตั้ง `codex-selector.ps1` ใหม่

### ปัญหา: Windows sandbox helper ทำงานไม่ได้

หาก shell tool รายงาน `codex-windows-sandbox-setup.exe` หาย ให้ตรวจว่ากำลังใช้ Codex runtime ตัวใด รุ่น standalone อาจไม่มี helper อยู่ข้าง executable

หาก log รายงาน `node_repl.exe ... being used by another process` ให้ปิด ChatGPT และ Codex ทุกหน้าต่างก่อนลองใหม่ ปัญหานี้เป็น Windows sandbox ของ Codex ไม่ใช่ปัญหาการเชื่อมต่อ ALIBABA

### ปัญหา: TLS handshake timeout

**สาเหตุ:** ThinkStation ติดต่อ Alibaba Token Plan ไม่ได้

**แก้:**
1. ตรวจสอบ internet connectivity บน ThinkStation
2. ตรวจสอบ firewall rules
3. ลองใช้ OpenAI ชั่วคราว: `codex-selector openai`

### ปัญหา: Config ไม่ถูกแก้ไข

**สาเหตุ:** PowerShell script ไม่มีสิทธิ์เขียนไฟล์

**แก้:** ใช้ CMD:
```cmd
REM ตรวจสอบสิทธิ์
icacls %USERPROFILE%\.codex\config.toml

REM ให้สิทธิ์แก้ไข
icacls %USERPROFILE%\.codex\config.toml /grant %USERNAME%:M
```

## Usage Examples

### สลับโหมดโดยไม่ restart Desktop

ใช้ CMD:
```cmd
codex-selector openai
codex-selector alibaba
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" openai
& "$env:USERPROFILE\codex-selector.bat" alibaba
```

### สลับโหมดพร้อม restart Desktop

ใช้ CMD:
```cmd
codex-selector openai -RestartDesktop
codex-selector alibaba -RestartDesktop
```

ใช้ PowerShell:
```powershell
& "$env:USERPROFILE\codex-selector.bat" openai -RestartDesktop
& "$env:USERPROFILE\codex-selector.bat" alibaba -RestartDesktop
```

### ใช้ Desktop Shortcut

ดับเบิลคลิก shortcut บน Desktop:
- **Codex - OpenAI** → สลับเป็น OpenAI และ restart Desktop
- **Codex - ALIBABA** → สลับเป็น ALIBABA และ restart Desktop

## Next Steps

หลังจากติดตั้งสำเร็จ:

1. ทดสอบทั้งสองโหมด (OpenAI และ ALIBABA)
2. รายงานปัญหาที่พบใน GitHub Issues
3. ปรับแต่ง config ตามต้องการ

## Support

ถ้าพบปัญหา:
- เปิด GitHub Issue: https://github.com/pbseiya/codex-custom-api-settings/issues
- ระบุ: Windows version, error message, steps to reproduce
