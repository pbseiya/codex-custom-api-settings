# Installation Guide for Linux

คู่มือนี้แนะนำการติดตั้ง Codex provider selector บน Linux (Ubuntu/Debian, Fedora, Arch)

## Prerequisites

### 1. ติดตั้ง Node.js และ npm

เลือกวิธีใดวิธีหนึ่งด้านล่าง:

#### วิธีที่ 1: ใช้ apt (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install -y nodejs npm
```

#### วิธีที่ 2: ใช้ NodeSource (Ubuntu/Debian รุ่นใหม่กว่า)

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
```

Node.js จะมาพร้อมกับ npm

#### วิธีที่ 3: ใช้ dnf (Fedora)

```bash
sudo dnf install -y nodejs npm
```

#### วิธีที่ 4: ใช้ pacman (Arch)

```bash
sudo pacman -S nodejs npm
```

ตรวจสอบการติดตั้ง:

```bash
node --version
npm --version
```

### 2. ติดตั้ง Codex CLI

ใช้ npm:

```bash
npm install -g @openai/codex
```

ตรวจสอบ:

```bash
codex --version
```

### 3. ติดตั้ง ChatGPT Desktop

ดาวน์โหลดจาก [openai.com/chatgpt/desktop](https://openai.com/chatgpt/desktop)

สำหรับ Ubuntu/Debian (.deb):

```bash
wget https://chatgpt.com/download/linux-deb -O chatgpt.deb
sudo dpkg -i chatgpt.deb
sudo apt install -f  # แก้ไข dependencies ถ้ามีปัญหา
```

สำหรับ Fedora (.rpm):

```bash
wget https://chatgpt.com/download/linux-rpm -O chatgpt.rpm
sudo rpm -i chatgpt.rpm
```

ติดตั้งตามปกติ แล้วเปิดแอปอย่างน้อยหนึ่งครั้งเพื่อสร้าง `~/.codex`

### 4. ตรวจสอบ CODEX_HOME

Codex บน Linux ใช้ `~/.codex` เป็น default

ตรวจสอบ:

```bash
echo $HOME/.codex
```

ควรเห็น: `/home/<username>/.codex`

## Installation Steps

### Step 1: ดาวน์โหลด Source Code

เลือกวิธีใดวิธีหนึ่งด้านล่าง:

#### วิธีที่ 1: Git Clone (แนะนำสำหรับผู้ที่คุ้นเคยกับ git)

```bash
cd $HOME
git clone https://github.com/pbseiya/codex-custom-api-settings.git
cd codex-custom-api-settings
```

**ข้อดี:**
- อัพเดตง่ายด้วย `git pull`
- ติดตาม version และประวัติการเปลี่ยนแปลงได้

**ข้อเสีย:**
- ต้องติดตั้ง git
- ต้อง setup GitHub authentication (SSH key หรือ Personal Access Token)

#### วิธีที่ 2: Download ZIP (แนะนำสำหรับผู้ที่ไม่มี git)

1. เปิด browser ไปที่: https://github.com/pbseiya/codex-custom-api-settings
2. คลิกปุ่ม **Code** (สีเขียว) → เลือก **Download ZIP**
3. Extract ไฟล์ ZIP:

```bash
cd $HOME
unzip codex-custom-api-settings.zip
mv codex-custom-api-settings-main codex-custom-api-settings
```

4. ตรวจสอบว่ามีไฟล์ครบ:

```bash
ls codex-custom-api-settings
```

ควรเห็น:
- `codex-selector`
- `model-catalog-alibaba.json`
- `desktop/codex-openai.desktop`
- `desktop/codex-alibaba.desktop`
- `INSTALL-LINUX.md`
- `README.md`
- และไฟล์อื่นๆ

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

สร้างไฟล์ .env:

```bash
cd $HOME/.codex
nano .env
```

เพิ่ม:

```
ALIBABA_KEY=<assigned-virtual-key>
```

บันทึกและปิด (Ctrl+O, Enter, Ctrl+X)

จำกัดสิทธิ์ไฟล์:

```bash
chmod 600 $HOME/.codex/.env
```

### Step 4: สร้าง Model Catalog

คัดลอกไฟล์จาก repository:

```bash
cd $HOME/.codex
cp $HOME/codex-custom-api-settings/model-catalog-alibaba.json .
```

### Step 5: ติดตั้ง codex-selector

สร้างโฟลเดอร์ bin ถ้ายังไม่มี:

```bash
mkdir -p $HOME/.local/bin
```

คัดลอก selector:

```bash
cp $HOME/codex-custom-api-settings/codex-selector $HOME/.local/bin/
chmod +x $HOME/.local/bin/codex-selector
```

ตรวจสอบว่า `codex-selector` ใช้ได้หรือไม่:

```bash
python3 -m py_compile $HOME/.local/bin/codex-selector && echo "✓ codex-selector syntax OK"
```

ถ้าไม่มี Python3 ต้องติดตั้งก่อน:

```bash
sudo apt install python3  # Ubuntu/Debian
sudo dnf install python3  # Fedora
sudo pacman -S python     # Arch
```

เพิ่มเข้า PATH ถ้ายังไม่มี:

```bash
# ตรวจสอบว่า ~/.local/bin อยู่ใน PATH หรือยัง
echo $PATH | grep -q "$HOME/.local/bin" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
```

ตรวจสอบ:

```bash
codex-selector status
```

ควรเห็น:

```
mode=openai
desktop=stopped
```

### Step 6: ติดตั้ง Desktop Shortcuts

คัดลอก .desktop files:

```bash
mkdir -p $HOME/.local/share/applications
cp $HOME/codex-custom-api-settings/desktop/*.desktop $HOME/.local/share/applications/
```

อัปเดต desktop database:

```bash
update-desktop-database $HOME/.local/share/applications/
```

ตอนนี้จะมีไอคอนใน Application Menu:

- **Codex — OpenAI** → สลับเป็น OpenAI และ restart Desktop
- **Codex — ALIBABA** → สลับเป็น ALIBABA และ restart Desktop

## สรุปวิธีใช้งานประจำวัน

ใช้ selector ก่อนเปิด Codex เพื่อกำหนดว่า Codex CLI/TUI และ ChatGPT Desktop จะเรียก provider ใด

### ใช้ ALIBABA

```bash
codex-selector alibaba
codex
```

โหมดนี้ใช้ LiteLLM ThinkStation และแสดงเฉพาะโมเดลต่อไปนี้:

- `deepseek-v4.1-flash`
- `qwen3.8-max`
- `qwen3.8-flash`

ถ้าต้องการสลับโหมดและเปิด ChatGPT Desktop ใหม่ทันที:

```bash
codex-selector alibaba --restart-desktop
```

### ใช้ OpenAI

```bash
codex-selector openai
codex
```

โหมดนี้กลับไปใช้บัญชี OpenAI และ catalog โมเดลทั้งหมดที่บัญชีได้รับ

ถ้าต้องการสลับโหมดและเปิด ChatGPT Desktop ใหม่ทันที:

```bash
codex-selector openai --restart-desktop
```

### ตรวจสอบโหมดปัจจุบัน

```bash
codex-selector status
```

`codex-selector` เปลี่ยนทั้ง Codex CLI/TUI และ ChatGPT Desktop เพราะทั้งสองโปรแกรมอ่าน `~/.codex/config.toml` เดียวกัน หลังใช้คำสั่ง selector ให้ปิด Codex CLI/TUI ที่เปิดค้างอยู่แล้วเปิดใหม่ หาก ChatGPT Desktop เปิดค้างอยู่ ให้ใช้ `--restart-desktop` เพื่อให้แอปอ่านค่าใหม่

## Testing

### Test 1: ตรวจสอบ Status

```bash
codex-selector status
```

ควรเห็น:

```
mode=openai
desktop=stopped
```

### Test 2: สลับเป็น ALIBABA

```bash
codex-selector alibaba
```

ควรเห็น:

```
mode=alibaba
backup=/home/<username>/codex-custom-api-settings/backups/selector/config-YYYYMMDD-HHMMSS-NNNNNNNNN.toml
desktop=stopped
```

### Test 3: เปิด ChatGPT Desktop

```bash
codex-selector alibaba --restart-desktop
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

```bash
codex exec --skip-git-repo-check "Reply exactly ALIBABA_OK"
```

ควรเห็น `provider: alibaba` และคำตอบ `ALIBABA_OK`

### Test 6: สลับกลับ OpenAI

```bash
codex-selector openai --restart-desktop
```

ใน ChatGPT Desktop ควรเห็น OpenAI models ทั้งหมด

## Troubleshooting

### ปัญหา: "codex-selector: command not found"

**สาเหตุ:** `~/.local/bin` ไม่มีใน PATH

**แก้:**

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
```

หรือเปิด terminal ใหม่

### ปัญหา: "codex: command not found"

**สาเหตุ:** Codex CLI ไม่ได้ติดตั้ง หรือ npm global bin ไม่มีใน PATH

**แก้:**

```bash
# ตรวจสอบว่าติดตั้งหรือยัง
npm list -g @openai/codex

# ถ้ายังไม่ได้ติดตั้ง
npm install -g @openai/codex

# ตรวจสอบ npm prefix
npm config get prefix

# เพิ่ม bin directory เข้า PATH ถ้ายังไม่มี
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
```

### ปัญหา: ChatGPT Desktop ไม่เปิด

**สาเหตุ:** `chatgpt` command ไม่มีใน PATH

**แก้:**

```bash
# ตรวจสอบว่าติดตั้งหรือยัง
which chatgpt

# ถ้าไม่มี อาจต้อง logout/login หรือ restart desktop environment
# หรือเปิดจาก Application Menu โดยตรง
```

### ปัญหา: "ALIBABA_KEY is missing"

**สาเหตุ:** ไฟล์ `.env` ไม่มีหรือไม่มี key

**แก้:**

```bash
# ตรวจสอบว่าไฟล์มีอยู่หรือยัง
cat $HOME/.codex/.env

# ถ้าไม่มี หรือไม่มี key
nano $HOME/.codex/.env
# เพิ่ม: ALIBABA_KEY=<assigned-virtual-key>
chmod 600 $HOME/.codex/.env
```

### ปัญหา: "missing catalog"

**สาเหตุ:** ไฟล์ `model-catalog-alibaba.json` หายไป

**แก้:**

```bash
cp $HOME/codex-custom-api-settings/model-catalog-alibaba.json $HOME/.codex/
```

### ปัญหา: TLS handshake timeout

**สาเหตุ:** ThinkStation ติดต่อ Alibaba Token Plan ไม่ได้

**แก้:**

1. ตรวจสอบ internet connectivity บน ThinkStation
2. ตรวจสอบ firewall rules
3. ลองใช้ OpenAI ชั่วคราว:

```bash
codex-selector openai
```

### ปัญหา: Config ไม่ถูกแก้ไข

**สาเหตุ:** ไม่มีสิทธิ์เขียนไฟล์

**แก้:**

```bash
# ตรวจสอบสิทธิ์
ls -la $HOME/.codex/config.toml

# ให้สิทธิ์เขียน
chmod 644 $HOME/.codex/config.toml
```

## Updating

ถ้าติดตั้งด้วย git:

```bash
cd $HOME/codex-custom-api-settings
git pull
```

ถ้า download ZIP:

```bash
# download ZIP ใหม่ แล้ว extract ทับไฟล์เดิม
cd $HOME
rm -rf codex-custom-api-settings
unzip codex-custom-api-settings.zip
mv codex-custom-api-settings-main codex-custom-api-settings
```

จากนั้น copy ไฟล์ที่เปลี่ยนแปลง:

```bash
cp $HOME/codex-custom-api-settings/codex-selector $HOME/.local/bin/
cp $HOME/codex-custom-api-settings/desktop/*.desktop $HOME/.local/share/applications/
update-desktop-database $HOME/.local/share/applications/
```

## Uninstalling

1. ลบ selector:

```bash
rm $HOME/.local/bin/codex-selector
```

2. ลบ desktop shortcuts:

```bash
rm $HOME/.local/share/applications/codex-openai.desktop
rm $HOME/.local/share/applications/codex-alibaba.desktop
update-desktop-database $HOME/.local/share/applications/
```

3. ลบ repository (ถ้าต้องการ):

```bash
rm -rf $HOME/codex-custom-api-settings
```

4. ลบ Codex CLI (ถ้าต้องการ):

```bash
npm uninstall -g @openai/codex
```

5. ลบ ChatGPT Desktop (ถ้าต้องการ):

Ubuntu/Debian:

```bash
sudo apt remove chatgpt
```

Fedora:

```bash
sudo rpm -e chatgpt
```

## Usage Examples

### สลับโหมดโดยไม่ restart Desktop

```bash
codex-selector openai
codex-selector alibaba
```

### สลับโหมดพร้อม restart Desktop

```bash
codex-selector openai --restart-desktop
codex-selector alibaba --restart-desktop
```

### ใช้ Desktop Shortcut

คลิกไอคอนใน Application Menu:

- **Codex — OpenAI** → สลับเป็น OpenAI และ restart Desktop
- **Codex — ALIBABA** → สลับเป็น ALIBABA และ restart Desktop

## Next Steps

หลังจากติดตั้งสำเร็จ:

1. ทดสอบทั้งสองโหมด (OpenAI และ ALIBABA)
2. รายงานปัญหาที่พบใน GitHub Issues
3. ปรับแต่ง config ตามต้องการ

## Support

ถ้าพบปัญหา:

- เปิด GitHub Issue: https://github.com/pbseiya/codex-custom-api-settings/issues
- ระบุ: Linux distribution, version, error message, steps to reproduce
