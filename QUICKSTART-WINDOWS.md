# Quick Start สำหรับ Windows (ไม่ต้องติดตั้ง Codex CLI)

คู่มือนี้สำหรับเครื่องที่บริษัท block การติดตั้ง npm หรือต้องการใช้เฉพาะ ChatGPT Desktop

**เวลาติดตั้ง:** 5-10 นาที

## สิ่งที่ต้องมี

- ChatGPT Desktop (ดาวน์โหลดจาก [openai.com/chatgpt/desktop](https://openai.com/chatgpt/desktop))
- Web browser
- Virtual Key จากผู้ดูแล LiteLLM

## ขั้นตอน

### 1. ดาวน์โหลดและ Extract

1. เปิด https://github.com/pbseiya/codex-custom-api-settings
2. คลิกปุ่ม **Code** → **Download ZIP**
3. Extract ไฟล์ ZIP (คลิกขวา → **Extract All...**)
4. Rename folder จาก `codex-custom-api-settings-main` เป็น `codex-custom-api-settings`:

```cmd
cd %USERPROFILE%\
rename codex-custom-api-settings-main codex-custom-api-settings
```

### 2. สร้างไฟล์ .env

```cmd
if not exist "%USERPROFILE%\.codex" mkdir "%USERPROFILE%\.codex"
cd %USERPROFILE%\.codex
notepad .env
```

เพิ่ม:
```
ALIBABA_KEY=<assigned-virtual-key>
```

บันทึกและปิด

จำกัดสิทธิ์:
```cmd
icacls .env /inheritance:r /grant:r "%USERNAME%:(R,W)"
```

### 3. คัดลอกไฟล์ที่จำเป็น

```cmd
cd %USERPROFILE%\.codex
copy %USERPROFILE%\codex-custom-api-settings\model-catalog-alibaba.json .

cd %USERPROFILE%
copy codex-custom-api-settings\codex-selector.ps1 .
copy codex-custom-api-settings\codex-selector.bat .
```

### 4. เพิ่มเข้า PATH (ใช้ PowerShell)

```powershell
$selectorDir = $env:USERPROFILE
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$entries = @($userPath -split ';' | Where-Object { $_ })
if ($entries -notcontains $selectorDir) {
    $newUserPath = (@($entries) + $selectorDir) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User')
}
```

ปิด terminal ทุกหน้าต่าง แล้วเปิดใหม่

### 5. สร้าง Desktop Shortcuts (ใช้ PowerShell)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\codex-custom-api-settings\create-desktop-shortcuts.ps1"
```

จะได้ shortcuts:
- **Codex - OpenAI**
- **Codex - ALIBABA**

## ใช้งาน

### สลับเป็น Alibaba และเปิด ChatGPT Desktop

```cmd
codex-selector alibaba -RestartDesktop
```

### สลับกลับ OpenAI

```cmd
codex-selector openai -RestartDesktop
```

### หรือดับเบิลคลิก shortcut บน Desktop

## ตรวจสอบสถานะ

```cmd
codex-selector status
```

ควรเห็น:
```
mode=alibaba
desktop=running
```

## โมเดลที่ใช้ได้

- `deepseek-v4.1-flash`
- `qwen3.8-max`
- `qwen3.8-flash`

## หมายเหตุสำคัญ

- ChatGPT Desktop มี bundled Codex runtime อยู่แล้ว ไม่ต้องติดตั้ง Codex CLI แยก
- Selector เปลี่ยนทั้ง Codex CLI/TUI และ ChatGPT Desktop เพราะทั้งสองโปรแกรมอ่าน `%USERPROFILE%\.codex\config.toml` เดียวกัน
- หลังใช้คำสั่ง selector ให้ปิด Codex CLI/TUI ที่เปิดค้างอยู่แล้วเปิดใหม่
- หาก ChatGPT Desktop เปิดค้างอยู่ ให้ใช้ `-RestartDesktop` เพื่อให้แอปอ่านค่าใหม่

## ปัญหาที่พบบ่อย

### "codex-selector is not recognized"
- ปิดและเปิด PowerShell/CMD ใหม่
- ถ้ายังไม่พบ ให้ทำ Step 4 อีกครั้ง แล้วปิด terminal ทุกหน้าต่างก่อนเปิดใหม่

### "execution of scripts is disabled"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ChatGPT Desktop ไม่เปิด
ตรวจสอบว่า ChatGPT Desktop ติดตั้งเป็น Microsoft Store app หรือไม่:
```powershell
$app = Get-StartApps | Where-Object { $_.AppID -like 'OpenAI.Codex_*!App' } | Select-Object -First 1
if (-not $app) { throw 'Codex Desktop AppID not found' }
Start-Process ("shell:AppsFolder\" + $app.AppID)
```

## ต้องการความช่วยเหลือเพิ่มเติม?

ดูคู่มือฉบับเต็ม: [INSTALL-WINDOWS.md](INSTALL-WINDOWS.md)

เปิด issue ที่: https://github.com/pbseiya/codex-custom-api-settings/issues
