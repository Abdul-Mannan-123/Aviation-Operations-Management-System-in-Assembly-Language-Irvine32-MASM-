![aviation-banner](https://dummyimage.com/1200x280/0a3d62/ffffff&text=Aviation+Operations+Management+System)

![Assembly](https://img.shields.io/badge/Language-Assembly-blue)
![MASM](https://img.shields.io/badge/Assembler-MASM32-green)
![Aviation System](https://img.shields.io/badge/Project-Aviation_System-orange)
![Academic](https://img.shields.io/badge/Type-Academic_Project-purple)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

# ✈️ Aviation Operations Management System (MASM32)

A fully working **Assembly Language Project** built using **MASM (Irvine32)** that manages aviation operations including flights, passengers, tickets, staff, and aircraft.

---

## ⭐ Features

### 🔐 Login System  
- Supports multiple employee IDs  
- 3-attempt lockout protection  

### 🛫 Flight Management  
- Add, view, delete, and update flights  
- Status control: Active / Delayed / Cancelled  

### 🎫 Ticket System  
- Book tickets  
- Cancel tickets  
- Display active bookings  

### 👥 Passenger Management  
- Add / delete passengers  
- View all or by flight  
- Bubble-sort by passenger ID  

### 🧑‍✈️ Staff Module  
- Add staff  
- Attendance tracking  
- Update working hours  
- Edit staff info  

### ✈️ Aircraft Tracking  
- Add aircraft  
- Mark available / unavailable / maintenance  
- Prevent duplicate IDs  
- Display full aircraft list  

---

## 🛠️ Tech Stack

- **Assembly (MASM32)**
- **Irvine32.inc**
- **Windows Console**
- **Modular Procedure-Based Architecture**

---

## 🚀 Run Instructions

```bash
ml /c /coff main.asm
link /subsystem:console main.obj Irvine32.lib
main.exe
